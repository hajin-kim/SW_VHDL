library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity SW_PE is
	generic (
		SEQ_DATA_WIDTH: integer := 2;
		VAL_DATA_WIDTH:	integer := 20
	) ;
	port (
		clock:	in std_logic;
		clock_d1:	in std_logic;
		clock_d2:	in std_logic;
		clock_d3:	in std_logic;
		areset_n:	in std_logic

		S_in:	in std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
		T_in:	in std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
		
		Max_in:	in std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
		F_in:	in std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
		V_in:	in std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
		V_in_alpha:	in std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;

		S_out:	out std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
		T_out:	out std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
		
		Max_out:	out std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
		F_out:	out std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
		V_out:	out std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
		V_out_alpha:	out std_logic_vector(VAL_DATA_WIDTH-1 downto 0)

	) ;
end entity ; -- SW_PE

architecture SW_PE_arch of SW_PE is

	component SW_PE_max is
		generic (
			VAL_DATA_WIDTH:	integer := 20
		) ;
		port (
			A_in:	in std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
			B_in:	in std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
			
			max_out:	out std_logic_vector(VAL_DATA_WIDTH-1 downto 0)
		) ;
	end component ; -- SW_PE_max


	component DFF is
		generic (
			DATA_WIDTH:	integer := 20
		) ;
		port (
			clock: in std_logic;
			areset_n: in std_logic;
			D_in:	in std_logic_vector(DATA_WIDTH-1 downto 0) ;
			Q_out:	out std_logic_vector(DATA_WIDTH-1 downto 0)
		) ;
	end component ; -- DFF

-- Sequence flow
	signal sig_DFF_S_out:	std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
	signal sig_DFF_T_out:	std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
-- V_diag_sigma
	signal sig_DFF_V_diag:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_V_diag_sigma:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_DFF_V_diag_sigma:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
-- E_out
	signal sig_max_E:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_DFF_E_out:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
-- F_out
	signal sig_max_F:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_DFF_F_out:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;

-- V_out
	sig_max_E_F:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	sig_DFF_max_E_F:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	sig_max_V:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	sig_DFF_V_out:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
-- Max_out
	sig_max_Max_out:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	sig_DFF_Max_out:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
begin
-- Sequence flow
	DFF_S_out:	DFF
	generic map (
		DATA_WIDTH => SEQ_DATA_WIDTH
	)
	port map (
			clock	=> clock,
			areset_n	=> areset_n,
			D_in	=> S_in,
			Q_out	=> sig_DFF_S_out
	);

	S_out <= sig_DFF_S_out;

	DFF_T_out:	DFF
	generic map (
		DATA_WIDTH => SEQ_DATA_WIDTH
	)
	port map (
			clock	=> clock,
			areset_n	=> areset_n,
			D_in	=> T_in,
			Q_out	=> sig_DFF_T_out
	);

	T_out <= sig_DFF_T_out;


-- V diagonal +- sigma
	DFF_V_diag:	DFF
	generic map (
		DATA_WIDTH => VAL_DATA_WIDTH
	)
	port map (
			clock	=> clock,
			areset_n	=> areset_n,
			D_in	=> V_in,
			Q_out	=> sig_DFF_V_diag
	);
	--TODO: LUT
	--	sig_DFF_S_out (LUT) T_in --> sig_sigma
	--	clock_d1
	--TODO: SIGMA
	--	sig_DFF_V_diag + sig_sigma --> sig_V_diag_sigma
	DFF_V_diag_sigma:	DFF
	generic map (
		DATA_WIDTH => VAL_DATA_WIDTH
	)
	port map (
			clock	=> clock_d3,
			areset_n	=> areset_n,
			D_in	=> sig_V_diag_sigma,
			Q_out	=> sig_DFF_V_diag_sigma
	);


-- E_out
	--TODO: E_in_beta
	--TODO: self_V_in_alpha
	--TODO: max_E
	DFF_F_out:	DFF
	generic map (
		DATA_WIDTH => VAL_DATA_WIDTH
	)
	port map (
			clock	=> clock_d2,
			areset_n	=> areset_n,
			D_in	=> sig_max_E,
			Q_out	=> sig_DFF_E_out
	);


-- F_out
	--TODO: F_in_beta
	--TODO: max_F
	DFF_F_out:	DFF
	generic map (
		DATA_WIDTH => VAL_DATA_WIDTH
	)
	port map (
			clock	=> clock_d2,
			areset_n	=> areset_n,
			D_in	=> sig_max_F,
			Q_out	=> sig_DFF_F_out
	);

	F_out <= sig_DFF_F_out;


-- V_out
	--TODO: max_E_F
	--	sig_DFF_E_out (MAX) sig_DFF_F_out --> sig_max_E_F
	DFF_max_E_F:	DFF
	generic map (
		DATA_WIDTH => VAL_DATA_WIDTH
	)
	port map (
			clock	=> clock_d3,
			areset_n	=> areset_n,
			D_in	=> sig_max_E_F,
			Q_out	=> sig_DFF_max_E_F
	);
	--TODO: max_V
	--	sig_DFF_max_E_F (MAX) sig_DFF_V_diag_sigma --> sig_max_V
	DFF_V_out:	DFF
	generic map (
		DATA_WIDTH => VAL_DATA_WIDTH
	)
	port map (
			clock	=> clock,
			areset_n	=> areset_n,
			D_in	=> sig_max_V,
			Q_out	=> sig_DFF_V_out
	);

	V_out <= sig_DFF_V_out;

-- Max_out
	--TODO: max_Max_out
	--	max_in (MAX) sig_DFF_V_out --> sig_max_Max_out
	DFF_Max_out:	DFF
	generic map (
		DATA_WIDTH => VAL_DATA_WIDTH
	)
	port map (
			clock	=> clock,
			areset_n	=> areset_n,
			D_in	=> sig_max_Max_out,
			Q_out	=> sig_DFF_Max_out
	);

	Max_out <= sig_DFF_Max_out;
end architecture ; -- SW_PE_arch