library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;
	
	use ieee.std_logic_unsigned.all ;

entity async_edge_triggered_counter is
	generic (
		DATA_WIDTH:	integer := 8
	) ;
	port (
		clock:	in std_logic ;
		reset:	in std_logic ;
		
		cnt_out:	out std_logic_vector(DATA_WIDTH-1 downto 0)
	) ;
end entity ; -- async_edge_triggered_counter

architecture async_edge_triggered_counter_arch of async_edge_triggered_counter is

	signal sig_cnt_out:	std_logic_vector(DATA_WIDTH-1 downto 0);

begin

	cnt_out <= sig_cnt_out;

	counter : process( clock, reset )
	begin
		if( reset'event ) then
			sig_cnt_out <= std_logic_vector(to_unsigned(0, DATA_WIDTH));
		elsif( rising_edge(clock) ) then
			sig_cnt_out <= sig_cnt_out + std_logic_vector(to_unsigned(1, DATA_WIDTH));
		end if ;
	end process ; -- counter

end architecture ; -- async_edge_triggered_counter_arch