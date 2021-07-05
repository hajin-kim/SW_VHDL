library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity SW_PE_LUT is
	generic (
		SEQ_DATA_WIDTH: integer := 2;
		VAL_DATA_WIDTH:	integer := 20
	) ;
	port (
		clock: in std_logic;
		areset_n: in std_logic;

		S_in:	in std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
		T_in:	in std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
		
		Sigma_out:	out std_logic_vector(VAL_DATA_WIDTH-1 downto 0)
	) ;
end entity ; -- SW_PE_LUT

architecture SW_PE_LUT_arch of SW_PE_LUT is

begin

--		T:	00	01	10	11
--	S:		A	C	G	T
--	00	A	2	-7	-5	-7
--	01	C	-7	2	-7	-5
--	10	G	-5	-7	2	-7
--	11	T	-7	-5	-7	2

	max_DFF_proc : process( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				Sigma_out <= std_logic_vector(to_signed(0, VAL_DATA_WIDTH));
			else
				case( S_in ) is
					when "00" =>
						case( T_in ) is
							when "00" =>
								Sigma_out <= std_logic_vector(to_signed(2, VAL_DATA_WIDTH));
							when "01" =>
								Sigma_out <= std_logic_vector(to_signed(-7, VAL_DATA_WIDTH));
							when "10" =>
								Sigma_out <= std_logic_vector(to_signed(-5, VAL_DATA_WIDTH));
							when "11" =>
								Sigma_out <= std_logic_vector(to_signed(-7, VAL_DATA_WIDTH));
							when others =>
								Sigma_out <= std_logic_vector(to_signed(0, VAL_DATA_WIDTH));
						end case ;
					when "01" =>
						case( T_in ) is
							when "00" =>
								Sigma_out <= std_logic_vector(to_signed(-7, VAL_DATA_WIDTH));
							when "01" =>
								Sigma_out <= std_logic_vector(to_signed(2, VAL_DATA_WIDTH));
							when "10" =>
								Sigma_out <= std_logic_vector(to_signed(-7, VAL_DATA_WIDTH));
							when "11" =>
								Sigma_out <= std_logic_vector(to_signed(-5, VAL_DATA_WIDTH));
							when others =>
								Sigma_out <= std_logic_vector(to_signed(0, VAL_DATA_WIDTH));
						end case ;
					when "10" =>
						case( T_in ) is
							when "00" =>
								Sigma_out <= std_logic_vector(to_signed(-5, VAL_DATA_WIDTH));
							when "01" =>
								Sigma_out <= std_logic_vector(to_signed(-7, VAL_DATA_WIDTH));
							when "10" =>
								Sigma_out <= std_logic_vector(to_signed(2, VAL_DATA_WIDTH));
							when "11" =>
								Sigma_out <= std_logic_vector(to_signed(-7, VAL_DATA_WIDTH));
							when others =>
								Sigma_out <= std_logic_vector(to_signed(0, VAL_DATA_WIDTH));
						end case ;
					when "11" =>
						case( T_in ) is
							when "00" =>
								Sigma_out <= std_logic_vector(to_signed(-7, VAL_DATA_WIDTH));
							when "01" =>
								Sigma_out <= std_logic_vector(to_signed(-5, VAL_DATA_WIDTH));
							when "10" =>
								Sigma_out <= std_logic_vector(to_signed(-7, VAL_DATA_WIDTH));
							when "11" =>
								Sigma_out <= std_logic_vector(to_signed(2, VAL_DATA_WIDTH));
							when others =>
								Sigma_out <= std_logic_vector(to_signed(0, VAL_DATA_WIDTH));
						end case ;
					when others =>
						Sigma_out <= std_logic_vector(to_signed(0, VAL_DATA_WIDTH));
				end case ;
			end if ;
		end if ;
	end process ; -- max_DFF_proc


end architecture ; -- SW_PE_LUT_arch