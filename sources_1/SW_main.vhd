library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity SW_main is
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
		clock_d1:	in std_logic;
		clock_d2:	in std_logic;
		clock_d3:	in std_logic;
		areset_n:	in std_logic;
		
		-- data size
		S_size:	in std_logic_vector(SEQ_DATA_LEN_CHECKER_WIDTH-1 downto 0) ;
		T_size:	in std_logic_vector(SEQ_DATA_LEN_CHECKER_WIDTH-1 downto 0) ;

		init_all:	in std_logic;
		init_all_done:	in std_logic;

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
		V_out_alpha:	out std_logic_vector(VAL_DATA_WIDTH-1 downto 0)

	) ;
end entity ; -- SW_main

architecture SW_main_arch of SW_main is

	constant MEM_DATA_WIDTH: integer := SEQ_DATA_WIDTH + VAL_DATA_WIDTH * 2 + 1;


	component SW_CU is
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

			-- S counter
			S_counter_data:	in std_logic_vector(SEQ_DATA_LEN_CHECKER_WIDTH-1 downto 0) ;
			S_counter_reset_n:	out std_logic;
			S_counter_enable:	out std_logic;

			-- T counter
			T_counter_data:	in std_logic_vector(SEQ_DATA_LEN_CHECKER_WIDTH-1 downto 0) ;
			T_counter_reset_n:	out std_logic;
			T_counter_enable:	out std_logic;

			-- mid comb
			ctrl_use_PE_T_in:	in std_logic


		) ;
	end component ; -- SW_CU


	component SW_PE_array is
		generic (
			NUM_PE:	integer := 3;

			SEQ_DATA_WIDTH: integer := 2;
			VAL_DATA_WIDTH:	integer := 20;

			ALPHA:	integer := -5;
			BETA:	integer := -2
		) ;
		port (
			clock:	in std_logic;
			clock_d1:	in std_logic;
			clock_d2:	in std_logic;
			clock_d3:	in std_logic;
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
			V_out_alpha:	out std_logic_vector(VAL_DATA_WIDTH-1 downto 0)

		) ;
	end component ; -- SW_PE_array


	component signed_max_DFF is
		generic (
			DATA_WIDTH:	integer := 20
		) ;
		port (
			clock: in std_logic;
			areset_n: in std_logic;
			enable: in std_logic;

			A_in:	in std_logic_vector(DATA_WIDTH-1 downto 0) ;
			B_in:	in std_logic_vector(DATA_WIDTH-1 downto 0) ;
			
			Max_out:	out std_logic_vector(DATA_WIDTH-1 downto 0)
		) ;
	end component ; -- signed_max_DFF


	component SW_mid_comb is
		generic (
			SEQ_DATA_WIDTH: integer := 2;
			VAL_DATA_WIDTH:	integer := 20;

			MEM_DATA_WIDTH:	integer := 43
		) ;
		port (
			clock:	in std_logic ;
			areset_n: in std_logic ;

			ctrl_use_PE_T_in:	in std_logic ;

			init_in:	in std_logic ;
			T_in:	in std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
			V_in:	in std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
			F_in:	in std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;

			initial_init_in:	in std_logic ;
			initial_T_in:	in std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;

			data_out:	out std_logic_vector(SEQ_DATA_WIDTH + VAL_DATA_WIDTH * 2 downto 0)
		) ;
	end component ; -- SW_mid_comb


	component SW_pseudo_FIFO is
		generic (
			SEQ_DATA_WIDTH: integer := 2;
			VAL_DATA_WIDTH:	integer := 20;

			MEM_DATA_WIDTH:	integer := 43;
			MEM_ADDR_WIDTH: integer := 4
		) ;
		port (
			clock:	in std_logic ;
			areset_n: in std_logic ;

			w_data_in:	in std_logic_vector(MEM_DATA_WIDTH-1 downto 0) ;

			r_data_out:	out std_logic_vector(MEM_DATA_WIDTH-1 downto 0)
		) ;
	end component ; -- SW_pseudo_FIFO


	component SW_mid_gen is
		generic (
			SEQ_DATA_WIDTH: integer := 2;
			VAL_DATA_WIDTH:	integer := 20;

			MEM_DATA_WIDTH:	integer := 43;

			ALPHA:	integer := -5
		) ;
		port (
			clock:	in std_logic ;
			areset_n: in std_logic ;

			data_in:	in std_logic_vector(MEM_DATA_WIDTH-1 downto 0) ;

			init_out:	out std_logic ;
			T_out:	out std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
			V_out:	out std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
			V_out_alpha:	out std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
			F_out:	out std_logic_vector(VAL_DATA_WIDTH-1 downto 0)
		) ;
	end component ; -- SW_mid_gen


	component counter is
		generic (
			DATA_LENGTH:	integer := 16
		) ;
		port (
			clock:	in std_logic;
			areset_n:	in std_logic;
			enable:	in std_logic;
			Q_out:	out std_logic_vector(DATA_LENGTH-1 downto 0)
		) ;
	end component ; -- counter


	signal sig_Max_array:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0);
	signal sig_Max_result:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0);

	signal sig_PE_init_out:	std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
	signal sig_PE_T_out:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_PE_F_out:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_PE_V_out:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;

	signal sig_PE_init_in:	std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
	signal sig_PE_T_in:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_PE_F_in:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_PE_V_in:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_PE_V_in_alpha:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;

	signal sig_FIFO_w_data_in:	std_logic_vector(SEQ_DATA_WIDTH + VAL_DATA_WIDTH * 2 downto 0) ;
	signal sig_FIFO_r_data_out:	std_logic_vector(SEQ_DATA_WIDTH + VAL_DATA_WIDTH * 2 downto 0) ;

	signal S_counter_reset_n:	std_logic ;
	signal S_counter_enable:	std_logic ;
	signal S_counter_data:	std_logic_vector(15 downto 0) ; --TODO
	signal T_counter_reset_n:	std_logic ;
	signal T_counter_enable:	std_logic ;
	signal T_counter_data:	std_logic_vector(15 downto 0) ; --TODO

	signal sig_ctrl_move_S:	std_logic;
	signal sig_ctrl_use_PE_T_in:	std_logic;

begin

	init_out	<= sig_PE_init_out
	T_out	<= sig_PE_T_out
	F_out	<= sig_PE_F_out
	V_out	<= sig_PE_V_out


	CU:	SW_CU
	generic map (
		NUM_PE	=> NUM_PE,

		SEQ_DATA_LEN_CHECKER_WIDTH	=> SEQ_DATA_LEN_CHECKER_WIDTH,
		SEQ_DATA_WIDTH	=> SEQ_DATA_WIDTH,
		VAL_DATA_WIDTH	=> VAL_DATA_WIDTH,

		ALPHA	=> ALPHA,
		BETA	=> BETA
	)
	port map (
		clock	=> clock,
		areset_n	=> areset_n,

		-- data size
		S_size	=> S_size,
		T_size	=> T_size,

		init_all	=> init_all,
		init_all_done	=> init_all_done,

		move_S_in	=> move_in_S,
		init_in 	=> init_in,	-- TODO: 이거 init_in 아닌거같은데 

		ctrl_move_S	=> sig_ctrl_move_S,

		-- S counter
		S_counter_data	=> sig_S_counter_data,
		S_counter_reset_n	=> sig_S_counter_reset_n,
		S_counter_enable	=> sig_S_counter_enable,

		-- T counter
		T_counter_data	=> sig_T_counter_data,
		T_counter_reset_n	=> sig_T_counter_reset_n,
		T_counter_enable	=> sig_T_counter_enable,

		-- mid comb
		ctrl_use_PE_T_in	=> sig_ctrl_use_PE_T_in


	) ;


	PE_array:	SW_PE_array
	generic map (
		NUM_PE	=> NUM_PE,

		SEQ_DATA_WIDTH	=> SEQ_DATA_WIDTH,
		VAL_DATA_WIDTH	=> VAL_DATA_WIDTH,

		ALPHA	=> ALPHA,
		BETA	=> BETA
	)
	port map (
		clock	=> clock,
		clock_d1	=> clock_d1,
		clock_d2	=> clock_d2,
		clock_d3	=> clock_d3,
		areset_n	=> areset_n,

		areset_n_S	=> areset_n_S,
		move_in_S	=> move_in_S,
		S_in	=> S_in,
		init_in	=> init_in,
		T_in	=> T_in,

		Max_in	=> Max_in,
		F_in	=> F_in,
		V_in	=> V_in,
		V_in_alpha	=> V_in_alpha,

		S_out	=> S_out,
		init_out	=> sig_PE_init_out,
		T_out	=> sig_PE_T_out,

		Max_out	=> sig_Max_array,
		F_out	=> sig_PE_F_out,
		V_out	=> sig_PE_V_out,
		V_out_alpha	=> V_out_alpha
	);


	signed_max_DFF_E_out:	signed_max_DFF
	generic map (
		DATA_WIDTH => VAL_DATA_WIDTH
	)
	port map (
		clock	=> clock,
		areset_n	=> areset_n,
		enable	=> '1',
		A_in	=> sig_Max_array,
		B_in	=> sig_Max_result,
		Max_out	=> sig_Max_result
	);

	Max_out <= sig_Max_result;


	mid_comb:	SW_mid_comb
	generic map (
		SEQ_DATA_WIDTH	=> SEQ_DATA_WIDTH,
		VAL_DATA_WIDTH	=> VAL_DATA_WIDTH,

		MEM_DATA_WIDTH	=> MEM_DATA_WIDTH
	)
	port map (
		clock	=> clock,
		areset_n	=> areset_n,

		ctrl_use_PE_T_in 	=> sig_ctrl_use_PE_T_in,

		init_in	=> sig_PE_init_out,
		T_in	=> sig_PE_T_out,
		V_in	=> sig_PE_V_out,
		F_in	=> sig_PE_F_out,

		initial_init_in	=> init_in,
		initial_T_in	=> T_in,

		data_out	=> sig_FIFO_w_data_in
	) ;


	pseudo_FIFO:	SW_pseudo_FIFO
	generic map (
		SEQ_DATA_WIDTH	=> SEQ_DATA_WIDTH,
		VAL_DATA_WIDTH	=> VAL_DATA_WIDTH,

		MEM_DATA_WIDTH	=> MEM_DATA_WIDTH,
		MEM_ADDR_WIDTH	=> 4	--TODO
	)
	port map (
		clock	=> clock,
		areset_n	=> areset_n,

		w_data_in	=> sig_FIFO_w_data_in,

		r_data_out	=> sig_FIFO_r_data_out
	) ;


	mid_gen:	SW_mid_gen
	generic map (
		SEQ_DATA_WIDTH	=> SEQ_DATA_WIDTH,
		VAL_DATA_WIDTH	=> VAL_DATA_WIDTH,

		MEM_DATA_WIDTH	=> MEM_DATA_WIDTH,

		ALPHA	=> ALPHA
	)
	port map (
		clock	=> clock,
		areset_n	=> areset_n,

		data_in	=> sig_FIFO_r_data_out,

		init_out	=> sig_PE_init_in,
		T_out	=> sig_PE_T_in,
		V_out	=> sig_PE_V_in,
		V_out_alpha	=> sig_PE_V_in_alpha,
		F_out	=> sig_PE_F_in
	) ;


	S_counter:	counter
	generic map (
		DATA_LENGTH	=> SEQ_DATA_LEN_CHECKER_WIDTH -- TODO
	)
	port map (
		clock	=> clock,
		areset_n	=> S_counter_reset_n,
		enable 	=> S_counter_enable,
		Q_out 	=> S_counter_data
	) ;


	T_counter:	counter
	generic map (
		DATA_LENGTH	=> SEQ_DATA_LEN_CHECKER_WIDTH -- TODO
	)
	port map (
		clock	=> clock,
		areset_n	=> T_counter_reset_n,
		enable 	=> T_counter_enable,
		Q_out 	=> T_counter_data
	) ;

end architecture ; -- SW_main_arch