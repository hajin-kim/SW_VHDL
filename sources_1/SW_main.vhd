library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity SW_main is
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
end entity ; -- SW_main

architecture SW_main_arch of SW_main is


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

			A_in:	in std_logic_vector(DATA_WIDTH-1 downto 0) ;
			B_in:	in std_logic_vector(DATA_WIDTH-1 downto 0) ;
			
			Max_out:	out std_logic_vector(DATA_WIDTH-1 downto 0)
		) ;
	end component ; -- signed_max_DFF


	signal sig_Max_array:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0);
	signal sig_Max_result:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0);


begin

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
		init_in	=> init_in;
		T_in	=> T_in,

		Max_in	=> Max_in,
		F_in	=> F_in,
		V_in	=> V_in,
		V_in_alpha	=> V_in_alpha,

		S_out	=> S_out,
		init_out	=> init_out,
		T_out	=> T_out,

		Max_out	=> sig_Max_array,
		F_out	=> F_out,
		V_out	=> V_out,
		V_out_alpha	=> V_out_alpha
	);


	signed_max_DFF_E_out:	signed_max_DFF
	generic map (
		DATA_WIDTH => VAL_DATA_WIDTH
	)
	port map (
			clock	=> clock,
			areset_n	=> areset_n,
			A_in	=> sig_Max_array,
			B_in	=> sig_Max_result,
			Max_out	=> sig_Max_result
	);

	Max_out <= sig_Max_result;

end architecture ; -- SW_main_arch