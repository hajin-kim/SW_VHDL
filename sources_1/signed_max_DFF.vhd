library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

	use ieee.std_logic_signed.all ;

entity signed_max_DFF is
	generic (
		DATA_WIDTH:	integer := 20
	) ;
	port (
		clock: in std_logic;
		areset_n: in std_logic;
		avail:	in std_logic;

		A_in:	in std_logic_vector(DATA_WIDTH-1 downto 0) ;
		B_in:	in std_logic_vector(DATA_WIDTH-1 downto 0) ;
		
		Max_out:	out std_logic_vector(DATA_WIDTH-1 downto 0)
	) ;
end entity ; -- signed_max_DFF

architecture signed_max_DFF_arch of signed_max_DFF is

	--max: std_logic_vector(MEM_CELL_DATA_WIDTH-1 downto 0) ;

begin

	--max_out <= 
	--	A_in when (A_in > B_in) else
	--	B_in;

	max_DFF_proc : process( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				Max_out <= std_logic_vector(to_signed(0, DATA_WIDTH));
			elsif ( avail = '1' ) then
				if ( A_in > B_in ) then
					Max_out <= A_in;
				else
					Max_out <= B_in;
				end if ;
			end if ;
		end if ;
	end process ; -- max_DFF_proc

	--max_selector : process( A_in, B_in )
	--begin
	--	if ( A_in > B_in ) then
	--		max_out <= A_in;
	--	else
	--		max_out <= B_in;
	--	end if ;
	--end process ; -- max_selector

	--max_out <= max;

end architecture ; -- signed_max_DFF_arch