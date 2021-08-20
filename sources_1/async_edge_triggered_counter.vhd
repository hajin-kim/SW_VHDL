library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

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

begin

	counter : process( clock, reset )
	begin
		if( reset'event ) then
			cnt_out <= std_logic_vector(to_signed(0, DATA_WIDTH));
		elsif( rising_edge(clock) ) then
			cnt_out <= cnt_out + 1;
		end if ;
	end process ; -- counter

end architecture ; -- async_edge_triggered_counter_arch