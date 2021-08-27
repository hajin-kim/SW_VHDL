library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity mem_cell is
  generic (
  	MEM_DATA_WIDTH: integer := 8
  ) ;
  port (
	clock: in std_logic;
	areset_n: in std_logic;

	w_en: in std_logic;
	w_data: in std_logic_vector(MEM_DATA_WIDTH-1 downto 0) ;

	Qout: out std_logic_vector(MEM_DATA_WIDTH-1 downto 0)
  ) ;
end entity ; -- mem_cell

architecture mem_cell_async of mem_cell is
	signal data: std_logic_vector(MEM_DATA_WIDTH-1 downto 0) ;
begin

	cell : process( areset_n, w_en, w_data )
	begin
		if ( areset_n = '0' ) then
			data <= std_logic_vector(to_unsigned(0, MEM_DATA_WIDTH));
		else
			if ( w_en = '1' ) then
				data <= w_data;
			end if ;
		end if ;
	end process ; -- cell

	Qout <= data;

end architecture ; -- mem_cell_async
