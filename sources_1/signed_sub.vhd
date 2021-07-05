library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

	use ieee.std_logic_signed.all ;

entity signed_sub is
	generic (
		DATA_WIDTH:	integer := 20
	) ;
	port (
		A_in:	in std_logic_vector(DATA_WIDTH-1 downto 0) ;
		B_in:	in std_logic_vector(DATA_WIDTH-1 downto 0) ;
		
		Sub_out:	out std_logic_vector(DATA_WIDTH-1 downto 0)
	) ;
end entity ; -- signed_sub

architecture signed_sub_arch of signed_sub is

begin
	
	Sub_out <= A_in - B_in;

end architecture ; -- signed_sub_arch