library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity SW_mid_gen is
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
end entity ; -- SW_mid_gen

architecture SW_mid_gen_arch of SW_mid_gen is

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

	signal V_in:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
	signal sig_sub_result:	std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;

begin

	V_in	<= data_in(VAL_DATA_WIDTH*2-1 downto VAL_DATA_WIDTH);

	-- sub(V, alpha)
	V_alpha: signed_add
	generic map (
		DATA_WIDTH	=> VAL_DATA_WIDTH
	)
	port map (
		A_in	=> V_in,
		B_in	=> to_signed(ALPHA, VAL_DATA_WIDTH),
		
		Add_out	=> sig_sub_result
	);

	-- Data delay logic
	proc_data : process( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				init_out <= '0';
				T_out <= to_unsigned(0, SEQ_DATA_WIDTH);
				V_out <= to_unsigned(0, VAL_DATA_WIDTH);
				V_out_alpha	<= to_unsigned(0, VAL_DATA_WIDTH);
				F_out <= to_unsigned(0, VAL_DATA_WIDTH);
			else
				init_out	<= data_in(MEM_DATA_WIDTH-1);
				T_out	<= data_in(MEM_DATA_WIDTH-2 downto VAL_DATA_WIDTH*2);
				V_out	<= V_in;
				V_out_alpha	<= sig_sub_result;
				F_out	<= data_in(VAL_DATA_WIDTH-1 downto 0);
			end if ;
		end if ;
	end process ; -- proc_data




end architecture ; -- SW_mid_gen_arch
