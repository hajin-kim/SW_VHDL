library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;
	use ieee.std_logic_unsigned.all ;

entity counter is
	generic (
		DATA_LENGTH:	integer := 16
	) ;
	port (
		clock:	in std_logic;
		areset_n:	in std_logic;
		enable:	in std_logic;
		Q_out:	out std_logic_vector(DATA_LENGTH-1 downto 0)
	) ;
end entity ; -- counter

architecture counter_arch of counter is

	--Q:	std_logic_vector(DATA_WIDTH-1 downto 0);

begin

	counter_proc : process( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				Q_out <= std_logic_vector(to_unsigned(0, DATA_LENGTH));
			elsif ( enable = '1' ) then
				Q_out <= Q_out + std_logic_vector(to_unsigned(1, DATA_LENGTH));
			end if ;
		end if ;
	end process ; -- counter_proc

	--Q_out <= Q;

end architecture ; -- counter_arch