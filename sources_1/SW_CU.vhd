library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity SW_CU is
	generic (
		NUM_PE:	integer := 3;

		DATA_LENGTH:	integer := 16;
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

		areset_n_S:	in std_logic;
		move_in_S:	in std_logic;
		S_in:	in std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
		init_in:	in std_logic;
		T_in:	in std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
		
		Max_in:	in std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
		F_in:	in std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
		V_in:	in std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
		V_in_alpha:	in std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;

		S_out:	out std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
		init_out:	out std_logic;
		T_out:	out std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
		
		Max_out:	out std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
		F_out:	out std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
		V_out:	out std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
		V_out_alpha:	out std_logic_vector(VAL_DATA_WIDTH-1 downto 0);


		-- data size
		S_size:	in std_logic_vector(DATA_LENGTH-1 downto 0) ;
		T_size:	in std_logic_vector(DATA_LENGTH-1 downto 0) ;

		-- S counter
		S_counter_reset_n:	out std_logic;
		S_counter_avail:	out std_logic;
		S_counter_data:	in std_logic_vector(DATA_LENGTH-1 downto 0) ;

		-- T counter
		T_counter_reset_n:	out std_logic;
		T_counter_avail:	out std_logic;
		T_counter_data:	in std_logic_vector(DATA_LENGTH-1 downto 0)


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
	)
	signal sw_cu_state : state;

	-- Counter result
	signal S_counter_done: std_logic;
	signal T_counter_done: std_logic;

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
						if ( move_S_in = '1' ) then
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
	-- 0: use PE input
	-- 1: use TB input
	proc_FIFO_ctrl : process ( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				pseudo_fifo_use_PE_in	<= '0';
			else
				if ( sw_cu_state = IDLE ) then
					pseudo_fifo_use_PE_in <= '0';
				elsif ( sw_cu_state = FEED_S ) then
					pseudo_fifo_use_PE_in <= '1';
				end if ;
			end if ;
		end if ;
	end process ; -- proc_FIFO_ctrl



	-- FIFO logic
	-- 1 cycle delay
	proc_FIFO_ctrl : process ( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				init_out	<= '0';
				T_out	<= '0';
				Max_out	<= '0';
				F_out	<= '0';
				V_out	<= '0';
				V_out_alpha	<= '0';
			else
				init_out	<= init_in;
				T_out	<= T_in;
				Max_out	<= Max_in;
				F_out	<= F_in;
				V_out	<= V_in;
				V_out_alpha	<= V_in_alpha;
			end if ;
		end if ;
	end process ; -- proc_FIFO_ctrl

	-- S counter logic
	-- reset on IDLE
	proc_S_counter_reset_n : process ( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				S_counter_reset_n <= '0';
			else
				if ( sw_cu_state = IDLE ) then
					S_counter_reset_n <= '0';
				else then
					S_counter_reset_n <= '1';
				end if ;
			end if ;
		end if ;
	end process ; -- proc_S_counter_reset_n

	-- start on FEED_S
	proc_S_counter_avail : process ( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				proc_S_counter_avail <= '0';
			else
				if ( sw_cu_state = FEED_S ) then
					proc_S_counter_avail <= '1';
				else then
					proc_S_counter_avail <= '0';
				end if ;
			end if ;
		end if ;
	end process ; -- proc_S_counter_avail

	-- set on the done flag
	proc_S_counter_done : process( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				S_counter_done <= '0';
			else
				if ( S_counter_reset_n = '0' ) then
					S_counter_done <= '0';
				elsif ( S_counter_data = S_size) then
					S_counter_done <= '1';
				end if ;
			end if ;
		end if ;
	end process ; -- proc_S_counter_done


	-- T counter logic
	proc_T_counter_reset_n : process ( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				T_counter_reset_n <= '0';
			else
				if ( sw_cu_state = FEED_T )
					T_counter_reset_n <= '1';
				else
					T_counter_reset_n <= '0';
				end if ;
			end if ;
		end if ;
	end process ; -- proc_S_counter_reset_n

	T_counter_avail <= '1';

	proc_T_counter_done : process( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				T_counter_done <= '0';
			else
				if ( T_counter_reset_n = '0' ) then
					T_counter_done <= '0';
				elsif ( T_counter_data = T_size) then
					T_counter_done <= '1';
				end if ;
			end if ;
		end if ;
	end process ; -- proc_T_counter_done


	-- SW_PE_array logic
	proc_move_out_S : process( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				move_out_S <= '0';
			else
				if ( sw_cu_state = FEED_S ) then
					move_out_S <= '1';
				else
					move_out_S <= '0';
				end if ;
			end if ;
		end if ;
	end process ; -- proc_move_in_S

	proc_init_out : process( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				init_out <= '0';
			else
				if ( sw_cu_state = FEED_T ) then
					init_out <= '1';
				else
					init_out <= '0';
				end if ;
			end if ;
		end if ;
	end process ; -- proc_init_out

end architecture ; -- SW_CU_arch