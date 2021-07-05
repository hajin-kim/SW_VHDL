library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity SW_PE is
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
	

	component signed_add is
		generic (
			DATA_WIDTH:	integer := 20
		) ;
		port (
			A_in:	in std_logic_vector(DATA_WIDTH-1 downto 0) ;
			B_in:	in std_logic_vector(DATA_WIDTH-1 downto 0) ;
			
			Add_out:	out std_logic_vector(DATA_WIDTH-1 downto 0)
		) ;
	end component ; -- signed_add


	component signed_sub is
		generic (
			DATA_WIDTH:	integer := 20
		) ;
		port (
			A_in:	in std_logic_vector(DATA_WIDTH-1 downto 0) ;
			B_in:	in std_logic_vector(DATA_WIDTH-1 downto 0) ;
			
			Sub_out:	out std_logic_vector(DATA_WIDTH-1 downto 0)
		) ;
	end component ; -- signed_sub


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


	component SW_PE_LUT is
		generic (
			SEQ_DATA_WIDTH: integer := 2;
			VAL_DATA_WIDTH:	integer := 20
		) ;
		port (
			clock: in std_logic;
			areset_n: in std_logic;

			S_in:	in std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
			T_in:	in std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
			
			Sigma_out:	out std_logic_vector(VAL_DATA_WIDTH-1 downto 0)
		) ;
	end component ; -- SW_PE_LUT


-- Constants
	signal sig_alpha:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_beta:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
-- Sequence flow
	signal sig_DFF_S_out:	std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
	signal sig_DFF_T_out:	std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
	signal sig_clock_S_out:	std_logic ;
-- V_diag_sigma
    signal sig_sigma:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_DFF_V_diag:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_V_diag_sigma:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_DFF_V_diag_sigma:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_reset_dff_v_diag_sigma:	std_logic ;
-- E_out
	signal sig_E_in_beta:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_self_V_in_alpha:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_DFF_E_out:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
-- F_out
	signal sig_F_in_beta:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_DFF_F_out:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
-- V_out
	signal sig_DFF_max_E_F:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_DFF_V_out:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
-- Max_out
	signal sig_DFF_Max_out:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;


begin
-- Constants
	sig_alpha <= std_logic_vector(to_signed(ALPHA, VAL_DATA_WIDTH));
	sig_beta <= std_logic_vector(to_signed(BETA, VAL_DATA_WIDTH));


-- Sequence flow
	DFF_S_out:	DFF
	generic map (
		DATA_WIDTH => SEQ_DATA_WIDTH
	)
	port map (
			clock	=> sig_clock_S_out,
			areset_n	=> areset_n_S,
			D_in	=> S_in,
			Q_out	=> sig_DFF_S_out
	);

	sig_clock_S_out <= clock AND move_in_S;

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

	LUT: SW_PE_LUT
	generic map (
		SEQ_DATA_WIDTH	=> SEQ_DATA_WIDTH,
		VAL_DATA_WIDTH	=> VAL_DATA_WIDTH
	)
	port map (
			clock	=> clock_d1,
			areset_n	=> areset_n,

			S_in	=> sig_DFF_S_out,
			T_in	=> T_in,
			
			Sigma_out	=> sig_sigma
	);

	V_diag_sigma: signed_add
	generic map (
		DATA_WIDTH	=> VAL_DATA_WIDTH
	)
	port map (
			A_in	=> sig_DFF_V_diag,
			B_in	=> sig_sigma,
			
			Add_out	=> sig_V_diag_sigma
	);

	DFF_V_diag_sigma:	DFF
	generic map (
		DATA_WIDTH => VAL_DATA_WIDTH
	)
	port map (
			clock	=> clock_d3,
			areset_n	=> sig_reset_dff_v_diag_sigma,
			D_in	=> sig_V_diag_sigma,
			Q_out	=> sig_DFF_V_diag_sigma
	);

	sig_reset_dff_v_diag_sigma <= areset_n AND (NOT sig_V_diag_sigma(VAL_DATA_WIDTH-1));

-- E_out
	E_in_beta: signed_sub
	generic map (
		DATA_WIDTH	=> VAL_DATA_WIDTH
	)
	port map (
			A_in	=> sig_DFF_V_diag,
			B_in	=> sig_beta,
			
			Sub_out	=> sig_E_in_beta
	);

	self_V_in_alpha: signed_sub
	generic map (
		DATA_WIDTH	=> VAL_DATA_WIDTH
	)
	port map (
			A_in	=> sig_DFF_V_out,
			B_in	=> sig_alpha,
			
			Sub_out	=> sig_self_V_in_alpha
	);

	V_out_alpha <= sig_self_V_in_alpha;

	signed_max_DFF_E_out:	signed_max_DFF
	generic map (
		DATA_WIDTH => VAL_DATA_WIDTH
	)
	port map (
			clock	=> clock_d2,
			areset_n	=> areset_n,
			A_in	=> sig_E_in_beta,
			B_in	=> sig_self_V_in_alpha,
			Max_out	=> sig_DFF_E_out
	);


-- F_out
	F_in_beta: signed_sub
	generic map (
		DATA_WIDTH	=> VAL_DATA_WIDTH
	)
	port map (
			A_in	=> F_in,
			B_in	=> sig_beta,
			
			Sub_out	=> sig_F_in_beta
	);

	signed_max_DFF_F_out:	signed_max_DFF
	generic map (
		DATA_WIDTH => VAL_DATA_WIDTH
	)
	port map (
			clock	=> clock_d2,
			areset_n	=> areset_n,
			A_in	=> sig_F_in_beta,
			B_in	=> V_in_alpha,
			Max_out	=> sig_DFF_F_out
	);

	F_out <= sig_DFF_F_out;


-- V_out
	signed_max_DFF_max_E_F:	signed_max_DFF
	generic map (
		DATA_WIDTH => VAL_DATA_WIDTH
	)
	port map (
			clock	=> clock_d3,
			areset_n	=> areset_n,
			A_in	=> sig_DFF_E_out,
			B_in	=> sig_DFF_F_out,
			Max_out	=> sig_DFF_max_E_F
	);

	signed_max_DFF_V_out:	signed_max_DFF
	generic map (
		DATA_WIDTH => VAL_DATA_WIDTH
	)
	port map (
			clock	=> clock,
			areset_n	=> areset_n,
			A_in	=> sig_DFF_max_E_F,
			B_in	=> sig_DFF_V_diag_sigma,
			Max_out	=> sig_DFF_V_out
	);

	V_out <= sig_DFF_V_out;


-- Max_out
	signed_max_DFF_Max_out:	signed_max_DFF
	generic map (
		DATA_WIDTH => VAL_DATA_WIDTH
	)
	port map (
			clock	=> clock,
			areset_n	=> areset_n,
			A_in	=> max_in,
			B_in	=> sig_DFF_V_out,
			Max_out	=> sig_DFF_Max_out
	);

	Max_out <= sig_DFF_Max_out;


end architecture ; -- SW_PE_arch