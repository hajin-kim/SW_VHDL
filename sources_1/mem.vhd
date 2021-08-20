library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity mem is
  generic (
	MEM_DATA_WIDTH: integer := 16 ;
	MEM_ADDR_WIDTH: integer := 4
  ) ;
  port (
	clock: in std_logic;
	areset_n: in std_logic;

	w_en: in std_logic;

	w_addr: in std_logic_vector(MEM_ADDR_WIDTH-1 downto 0) ;
	w_data: in std_logic_vector(MEM_DATA_WIDTH-1 downto 0) ;

	r_data: out std_logic_vector(MEM_DATA_WIDTH-1 downto 0)
  ) ;
end entity ; -- mem

architecture mem_arch of mem is

	component mem_4 is
	  generic (
  	MEM_DATA_WIDTH: integer := 16
	  ) ;
	  port (
		clock: in std_logic;
		areset_n: in std_logic;

		w_en: in std_logic;

		w_addr: in std_logic_vector(3 downto 0) ;
		w_data: in std_logic_vector(MEM_DATA_WIDTH-1 downto 0) ;

		r_data: out std_logic_vector(MEM_DATA_WIDTH-1 downto 0)
	  ) ;
	end component ; -- mem_4


	signal w_en_0: std_logic;
	signal r_data_0: std_logic_vector(MEM_DATA_WIDTH-1 downto 0) ;

begin

-- requires selection
	w_en_0 <= w_en;
	r_data <= r_data_0;

	--w_en_0 <= '1' when ((w_en = '1') and (w_addr = "0000")) else '0';
	--w_en_1 <= '1' when ((w_en = '1') and (w_addr = "0001")) else '0';
	--w_en_2 <= '1' when ((w_en = '1') and (w_addr = "0010")) else '0';
	--w_en_3 <= '1' when ((w_en = '1') and (w_addr = "0011")) else '0';
	--w_en_4 <= '1' when ((w_en = '1') and (w_addr = "0100")) else '0';
	--w_en_5 <= '1' when ((w_en = '1') and (w_addr = "0101")) else '0';
	--w_en_6 <= '1' when ((w_en = '1') and (w_addr = "0110")) else '0';
	--w_en_7 <= '1' when ((w_en = '1') and (w_addr = "0111")) else '0';
	--w_en_8 <= '1' when ((w_en = '1') and (w_addr = "1000")) else '0';
	--w_en_9 <= '1' when ((w_en = '1') and (w_addr = "1001")) else '0';
	--w_en_10 <= '1' when ((w_en = '1') and (w_addr = "1010")) else '0';
	--w_en_11 <= '1' when ((w_en = '1') and (w_addr = "1011")) else '0';
	--w_en_12 <= '1' when ((w_en = '1') and (w_addr = "1100")) else '0';
	--w_en_13 <= '1' when ((w_en = '1') and (w_addr = "1101")) else '0';
	--w_en_14 <= '1' when ((w_en = '1') and (w_addr = "1110")) else '0';
	--w_en_15 <= '1' when ((w_en = '1') and (w_addr = "1111")) else '0';

	--r_data <=
	--	Qout_0 when (w_addr = "0000") else
	--	Qout_1 when (w_addr = "0001") else
	--	Qout_2 when (w_addr = "0010") else
	--	Qout_3 when (w_addr = "0011") else
	--	Qout_4 when (w_addr = "0100") else
	--	Qout_5 when (w_addr = "0101") else
	--	Qout_6 when (w_addr = "0110") else
	--	Qout_7 when (w_addr = "0111") else
	--	Qout_8 when (w_addr = "1000") else
	--	Qout_9 when (w_addr = "1001") else
	--	Qout_10 when (w_addr = "1010") else
	--	Qout_11 when (w_addr = "1011") else
	--	Qout_12 when (w_addr = "1100") else
	--	Qout_13 when (w_addr = "1101") else
	--	Qout_14 when (w_addr = "1110") else
	--	Qout_15 when (w_addr = "1111") else
	--	std_logic_vector(to_unsigned(0, MEM_DATA_WIDTH-1)) ;
	
	mem_4_0_inst: mem_4
	generic map (
		MEM_DATA_WIDTH	=> MEM_DATA_WIDTH
	) port map (
		clock	=> clock,
		areset_n	=> areset_n,

		w_en	=> w_en_0,

		w_addr	=> w_addr(3 downto 0),
		w_data	=> w_data,

		r_data	=> r_data_0
	);

end architecture ; -- mem_arch