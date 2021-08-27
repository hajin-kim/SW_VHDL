library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity tb_SW_main is

end entity ; -- tb_SW_main

architecture tb of tb_SW_main is

	component SW_main is
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
	end component ; -- SW_main

	constant tb_NUM_PE:	integer := 3;
	constant tb_SEQ_DATA_LEN_CHECKER_WIDTH:	integer := 16;
	constant tb_SEQ_DATA_WIDTH:	integer := 2;
	constant tb_VAL_DATA_WIDTH:	integer := 20;
	constant tb_ALPHA:	integer := -5;
	constant tb_BETA:	integer := -2;

	signal tb_clock:	std_logic;
	signal tb_clock_d1:	std_logic;
	signal tb_clock_d2:	std_logic;
	signal tb_clock_d3:	std_logic;
	signal tb_areset_n:	std_logic;
	
	signal tb_S_size: std_logic_vector(15 downto 0);
	signal tb_T_size: std_logic_vector(15 downto 0);
	
	signal tb_init_all: std_logic;
	signal tb_init_all_done: std_logic;

	signal tb_areset_n_S:	std_logic;
	signal tb_move_in_S:	std_logic;
	signal tb_S_in:	std_logic_vector(tb_SEQ_DATA_WIDTH-1 downto 0) ;
	signal tb_init_in:	std_logic;
	signal tb_T_in:	std_logic_vector(tb_SEQ_DATA_WIDTH-1 downto 0) ;

	signal tb_Max_in:	std_logic_vector(tb_VAL_DATA_WIDTH-1 downto 0) ;
	signal tb_F_in:	std_logic_vector(tb_VAL_DATA_WIDTH-1 downto 0) ;
	signal tb_V_in:	std_logic_vector(tb_VAL_DATA_WIDTH-1 downto 0) ;
	signal tb_V_in_alpha:	std_logic_vector(tb_VAL_DATA_WIDTH-1 downto 0) ;

	signal tb_S_out:	std_logic_vector(tb_SEQ_DATA_WIDTH-1 downto 0) ;
	signal tb_init_out:	std_logic;
	signal tb_T_out:	std_logic_vector(tb_SEQ_DATA_WIDTH-1 downto 0) ;

	signal tb_Max_out:	std_logic_vector(tb_VAL_DATA_WIDTH-1 downto 0) ;
	signal tb_F_out:	std_logic_vector(tb_VAL_DATA_WIDTH-1 downto 0) ;
	signal tb_V_out:	std_logic_vector(tb_VAL_DATA_WIDTH-1 downto 0) ;
	signal tb_V_out_alpha:	std_logic_vector(tb_VAL_DATA_WIDTH-1 downto 0);

begin

-- DUT
	dut: SW_main
	generic map (
		NUM_PE	=> tb_NUM_PE,
		SEQ_DATA_LEN_CHECKER_WIDTH	=> 16,
		SEQ_DATA_WIDTH	=> tb_SEQ_DATA_WIDTH,
		VAL_DATA_WIDTH	=> tb_VAL_DATA_WIDTH,
		ALPHA	=> tb_ALPHA,
		BETA	=> tb_BETA
	)
	port map (
		clock	=> tb_clock,
		clock_d1	=> tb_clock_d1,
		clock_d2	=> tb_clock_d2,
		clock_d3	=> tb_clock_d3,
		areset_n	=> tb_areset_n,
		
		S_size	=> tb_S_size,
		T_size	=> tb_T_size,

		init_all	=> tb_init_all,
		init_all_done	=> tb_init_all_done,

		areset_n_S	=> tb_areset_n_S,
		move_in_S	=> tb_move_in_S,
		S_in	=> tb_S_in,
		init_in	=> tb_init_in,
		T_in	=> tb_T_in,

		Max_in	=> tb_Max_in,
		F_in	=> tb_F_in,
		V_in	=> tb_V_in,
		V_in_alpha	=> tb_V_in_alpha,

		S_out	=> tb_S_out,
		init_out	=> tb_init_out,
		T_out	=> tb_T_out,

		Max_out	=> tb_Max_out,
		F_out	=> tb_F_out,
		V_out	=> tb_V_out,
		V_out_alpha	=> tb_V_out_alpha
	);

-- Clock
	process
	begin
		tb_clock <= '0';
		while (true) loop
			wait for 5ns;
			tb_clock <= not tb_clock;
		end loop;
	end process ;
	
	process
	begin
		tb_clock_d1 <= '0';
		wait for 2.5ns;
		while (true) loop
			wait for 5ns;
			tb_clock_d1 <= not tb_clock_d1;
		end loop;
	end process ;
	
	process
	begin
		tb_clock_d2 <= '0';
		wait for 5ns;
		while (true) loop
			wait for 5ns;
			tb_clock_d2 <= not tb_clock_d2;
		end loop;
	end process ;
	
	process
	begin
		tb_clock_d3 <= '0';
		wait for 7.5ns;
		while (true) loop
			wait for 5ns;
			tb_clock_d3 <= not tb_clock_d3;
		end loop;
	end process ;

-- Initial reset
	process
	begin
		tb_areset_n <= '0';
		tb_areset_n_S <= '0';
		wait for 13ns;
		tb_areset_n <= '1';
		tb_areset_n_S <= '1';
		while (true) loop
			wait for 1ms;
		end loop ;
	end process;
			
-- MAIN
	process 
	begin
---------------------------------
--GIVE YOUR TESTBENCH HERE:

	-- Initial state
		tb_move_in_S <= '0';
		tb_S_in <= std_logic_vector(to_signed(0, tb_SEQ_DATA_WIDTH)) ;
		tb_init_in	<= '0';
		tb_T_in <= std_logic_vector(to_signed(0, tb_SEQ_DATA_WIDTH)) ;

		tb_Max_in <= std_logic_vector(to_signed(0, tb_VAL_DATA_WIDTH)) ;
		tb_F_in <= std_logic_vector(to_signed(0, tb_VAL_DATA_WIDTH)) ;
		tb_V_in <= std_logic_vector(to_signed(0, tb_VAL_DATA_WIDTH)) ;
		tb_V_in_alpha <= std_logic_vector(to_signed(tb_ALPHA, tb_VAL_DATA_WIDTH)) ;


	-- Initial process

-- Score array
--		S:	00	01	10	11
--	T:		A	C	G	T
--	00	A	2	-7	-5	-7
--	01	C	-7	2	-7	-5
--	10	G	-5	-7	2	-7
--	11	T	-7	-5	-7	2

		wait for 15ns;

	-- Begin T
		tb_T_size <= std_logic_vector(to_unsigned(3, tb_SEQ_DATA_LEN_CHECKER_WIDTH));
		-- T1
		tb_init_all <= '1';
		tb_init_in	<= '1';
		tb_T_in <= "00";
		wait for 10ns;
		-- T2
		tb_init_in	<= '1';
		tb_T_in <= "00";
		wait for 10ns;
		-- T3
		tb_init_in	<= '1';
		tb_T_in <= "10";
		wait for 10ns;
	-- End T
		tb_init_all <= '0';
		tb_init_all_done <= '1';
		tb_init_in	<= '0';

	-- Begin S
		tb_S_size <= std_logic_vector(to_unsigned(3, tb_SEQ_DATA_LEN_CHECKER_WIDTH));
		-- S1
		tb_move_in_S <= '1';
		tb_S_in <= "00";
		wait for 10ns;
		-- S2
		tb_move_in_S <= '1';
		tb_S_in <= "10";
		wait for 10ns;
		-- S3
		tb_move_in_S <= '1';
		tb_S_in <= "01";
		wait for 10ns;
	-- End S
		tb_move_in_S <= '0';

	-- Loop
		while (true) loop
			wait for 1ms;
		end loop;
---------------------------------
	end process;


end architecture ; -- arch