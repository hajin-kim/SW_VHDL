library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity DFF is
	generic (
		DATA_WIDTH:	integer := 20
	) ;
	port (
		clock: in std_logic;
		areset_n: in std_logic;
		D_in:	in std_logic_vector(DATA_WIDTH-1 downto 0) ;
		Q_out:	out std_logic_vector(DATA_WIDTH-1 downto 0)
	) ;
end entity ; -- DFF

architecture DFF_arch of DFF is

	--Q:	std_logic_vector(DATA_WIDTH-1 downto 0);

begin

	DFF_proc : process( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n == '0' ) then
				Q_out <= std_logic_vector(to_unsigned(0, DATA_WIDTH));
			else
				Q_out <= D_in;
			end if ;
		end if ;
	end process ; -- DFF_proc

	--Q_out <= Q;

end architecture ; -- DFF_arch