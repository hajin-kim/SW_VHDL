library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity SW_PE_array is
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
end entity ; -- SW_PE_array

architecture SW_PE_array_arch of SW_PE_array is


	component SW_PE is
		generic (
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
	end component ; -- SW_PE

	type sig_array is array (0 to NUM_PE) of std_logic;
	type seq_slv_array is array (0 to NUM_PE) of std_logic_vector(SEQ_DATA_WIDTH-1 downto 0);
	type val_slv_array is array (0 to NUM_PE) of std_logic_vector(VAL_DATA_WIDTH-1 downto 0);

	signal sig_S:	seq_slv_array;
	signal sig_init_in:	sig_array;
	signal sig_T:	seq_slv_array;
	
	signal sig_Max:	val_slv_array;
	signal sig_F:	val_slv_array;
	signal sig_V:	val_slv_array;
	signal sig_V_alpha:	val_slv_array;


begin

-- Generate PEs
	gen_SW_PE : for i in 0 to NUM_PE-1 generate

		PE:	SW_PE
		generic map (
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
			S_in	=> sig_S(NUM_PE-i-1),
			init_in	=> sig_init_in(i),
			T_in	=> sig_T(i),

			Max_in	=> sig_Max(i),
			F_in	=> sig_F(i),
			V_in	=> sig_V(i),
			V_in_alpha	=> sig_V_alpha(i),

			S_out	=> sig_S(NUM_PE-i),
			init_out	=> sig_init_in(i+1),
			T_out	=> sig_T(i+1),

			Max_out	=> sig_Max(i+1),
			F_out	=> sig_F(i+1),
			V_out	=> sig_V(i+1),
			V_out_alpha	=> sig_V_alpha(i+1)
		);

	end generate gen_SW_PE; -- gen_SW_PE

	sig_S(0)	<= S_in;
	sig_init_in(0)	<= init_in;
	sig_T(0)	<= T_in;
	sig_Max(0)	<= Max_in;
	sig_F(0)	<= F_in;
	sig_V(0)	<= V_in;
	sig_V_alpha(0)	<= V_in_alpha;

	S_out	<= sig_S(NUM_PE);
	init_out	<= sig_init_in(NUM_PE);
	T_out	<= sig_T(NUM_PE);
	Max_out	<= sig_Max(NUM_PE);
	F_out	<= sig_F(NUM_PE);
	V_out	<= sig_V(NUM_PE);
	V_out_alpha	<= sig_V_alpha(NUM_PE);

end architecture ; -- SW_PE_array_arch