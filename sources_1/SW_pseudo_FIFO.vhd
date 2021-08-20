library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity SW_pseudo_FIFO is
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
end entity ; -- SW_pseudo_FIFO

architecture SW_pseudo_FIFO_arch of SW_pseudo_FIFO is

	signal init_in:	std_logic ;

	component async_edge_triggered_counter is
		generic (
			DATA_WIDTH:	integer := 8
		) ;
		port (
			clock:	in std_logic ;
			reset:	in std_logic ;
			
			cnt_out:	out std_logic_vector(DATA_WIDTH-1 downto 0)
		) ;
	end component ; -- async_edge_triggered_counter

	component mem is
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
	end component ; -- mem

	signal sig_cnt_out:	std_logic_vector(MEM_ADDR_WIDTH-1 downto 0) ;

begin

	init_in	<= w_data_in(MEM_DATA_WIDTH-1);

	FIFO_counter: async_edge_triggered_counter
	generic map (
		DATA_WIDTH	=> MEM_ADDR_WIDTH
	)
	port map (
		clock	=> clock,
		reset	=> init_in,
		cnt_out	=> sig_cnt_out
	);

	RF:	mem
	generic map (
		MEM_DATA_WIDTH	=> MEM_DATA_WIDTH,
		MEM_ADDR_WIDTH	=> MEM_ADDR_WIDTH
	)
	port map (
		clock	=> clock,
		areset_n	=> areset_n,
		w_en	=> init_in,
		w_addr	=> sig_cnt_out,
		w_data	=> w_data_in,
		r_data	=> r_data_out
	);

end architecture ; -- SW_pseudo_FIFO_arch