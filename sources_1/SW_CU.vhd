library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity SW_CU is
	generic (
		NUM_PE:	integer := 3;

		SEQ_DATA_LEN_CHECKER_WIDTH:	integer := 16;
		SEQ_DATA_WIDTH: integer := 2;
		VAL_DATA_WIDTH:	integer := 20;

		ALPHA:	integer := -5;
		BETA:	integer := -2
	) ;
	port (
		clock:	in std_logic;
		--clock_d1:	in std_logic;
		--clock_d2:	in std_logic;
		--clock_d3:	in std_logic;
		areset_n:	in std_logic;

		-- data size
		S_size:	in std_logic_vector(SEQ_DATA_LEN_CHECKER_WIDTH-1 downto 0) ;
		T_size:	in std_logic_vector(SEQ_DATA_LEN_CHECKER_WIDTH-1 downto 0) ;

		init_all:	in std_logic;
		init_all_done:	in std_logic;

		move_S_in:	in std_logic;
		init_in:	in std_logic;

		ctrl_move_S:	out std_logic;
		ctrl_send_data: out std_logic;

		-- S counter
		S_counter_data:	in std_logic_vector(SEQ_DATA_LEN_CHECKER_WIDTH-1 downto 0) ;
		S_counter_reset_n:	out std_logic;
		S_counter_enable:	out std_logic;

		-- T counter
		T_counter_data:	in std_logic_vector(SEQ_DATA_LEN_CHECKER_WIDTH-1 downto 0) ;
		T_counter_reset_n:	out std_logic;
		T_counter_enable:	out std_logic;

		-- mid comb
		ctrl_use_PE_T_in:	out std_logic


	) ;
end entity ; -- SW_CU

architecture SW_CU_arch of SW_CU is

	-- State variable
	type state is (
		IDLE,
		INIT,
		FEED_S,
		FEED_T,
		WAIT_T_OUT,
		RECEIVE_MID
	);
	signal sw_cu_state : state;

	-- Counter result
	signal S_counter_done: std_logic;
	signal sig_S_counter_reset_n: std_logic;
	signal T_counter_done: std_logic;
	signal sig_T_counter_reset_n: std_logic;

begin

	-- State logic
	proc_state : process( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				sw_cu_state <= IDLE;
			else
				case( sw_cu_state ) is
					when IDLE =>
						--wait for init
						if ( init_all = '1' ) then
							sw_cu_state <= INIT;
						end if ;

					when INIT =>
						if ( init_all_done = '1' ) then
							sw_cu_state <= FEED_S;
						end if ;
					
					when FEED_S =>
						if ( move_S_in = '0' ) then
							sw_cu_state <= FEED_T;
						end if ;

					when FEED_T =>
						if ( T_counter_done = '1' ) then
							sw_cu_state <= WAIT_T_OUT;
						end if ;
					
					when WAIT_T_OUT =>
						if ( init_in = '1' ) then
							sw_cu_state <= RECEIVE_MID;
						end if ;

					when RECEIVE_MID =>
						if ( init_in = '0' ) then
							sw_cu_state <= FEED_S;	-- TODO: IDLE
						end if ;

					when others =>
						sw_cu_state <= IDLE;
				end case;
			end if ;
		end if ;
	end process ; -- proc_state


	-- FIFO logic
	-- 0: use TB input
	-- 1: use PE input
	proc_FIFO_ctrl : process ( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				ctrl_use_PE_T_in	<= '0';
			else
				if ( sw_cu_state = IDLE ) then
					ctrl_use_PE_T_in <= '0';
				elsif ( sw_cu_state = FEED_S ) then
					ctrl_use_PE_T_in <= '1';
				end if ;
			end if ;
		end if ;
	end process ; -- proc_FIFO_ctrl


	-- S counter logic
	-- reset on IDLE
	proc_S_counter_reset_n : process ( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				sig_S_counter_reset_n <= '0';
			else
				if ( sw_cu_state = IDLE ) then
					sig_S_counter_reset_n <= '0';
				else
					sig_S_counter_reset_n <= '1';
				end if ;
			end if ;
		end if ;
	end process ; -- proc_S_counter_reset_n
	
	S_counter_reset_n <= sig_S_counter_reset_n;

	-- start on FEED_S
	proc_S_counter_enable : process ( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				S_counter_enable <= '0';
			else
				if ( sw_cu_state = FEED_S ) then
					S_counter_enable <= '1';
				else
					S_counter_enable <= '0';
				end if ;
			end if ;
		end if ;
	end process ; -- proc_S_counter_enable

	-- set on the done flag
	proc_S_counter_done : process( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				S_counter_done <= '0';
			else
				if ( sig_S_counter_reset_n = '0' ) then
					S_counter_done <= '0';
				elsif ( S_counter_data = S_size) then
					S_counter_done <= '1';	--TODO
				end if ;
			end if ;
		end if ;
	end process ; -- proc_S_counter_done


	-- T counter logic
	proc_T_counter_reset_n : process ( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				sig_T_counter_reset_n <= '0';
				ctrl_send_data <= '0';
			else
				if ( sw_cu_state = FEED_T ) then
					sig_T_counter_reset_n <= '1';
					ctrl_send_data <= '1';
				else
					sig_T_counter_reset_n <= '0';
					ctrl_send_data <= '0';
				end if ;
			end if ;
		end if ;
	end process ; -- proc_S_counter_reset_n
	
	T_counter_reset_n <= sig_T_counter_reset_n;

	T_counter_enable <= '1';

	proc_T_counter_done : process( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				T_counter_done <= '0';
			else
				if ( sig_T_counter_reset_n = '0' ) then
					T_counter_done <= '0';
				elsif ( T_counter_data = T_size) then
					T_counter_done <= '1';
				end if ;
			end if ;
		end if ;
	end process ; -- proc_T_counter_done


	-- SW_PE_array logic
	proc_move_S_out : process( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				ctrl_move_S <= '0';
			else
				if ( sw_cu_state = FEED_S ) then
					ctrl_move_S <= '1';
				else
					ctrl_move_S <= '0';
				end if ;
			end if ;
		end if ;
	end process ; -- proc_move_S_in

	--proc_init_out : process( clock )
	--begin
	--	if( rising_edge(clock) ) then
	--		if ( areset_n = '0' ) then
	--			init_out <= '0';
	--		else
	--			if ( sw_cu_state = FEED_T ) then
	--				init_out <= '1';
	--			else
	--				init_out <= '0';
	--			end if ;
	--		end if ;
	--	end if ;
	--end process ; -- proc_init_out

end architecture ; -- SW_CU_arch