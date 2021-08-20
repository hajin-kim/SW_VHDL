library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity SW_mid_comb is
	generic (
		SEQ_DATA_WIDTH: integer := 2;
		VAL_DATA_WIDTH:	integer := 20;

		MEM_DATA_WIDTH:	integer := 43
	) ;
	port (
		clock:	in std_logic ;
		areset_n: in std_logic ;

		ctrl_use_PE_T_in:	in std_logic ;

		init_in:	in std_logic ;
		T_in:	in std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;
		V_in:	in std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;
		F_in:	in std_logic_vector(VAL_DATA_WIDTH-1 downto 0) ;

		initial_init_in:	in std_logic ;
		initial_T_in:	in std_logic_vector(SEQ_DATA_WIDTH-1 downto 0) ;

		data_out:	out std_logic_vector(MEM_DATA_WIDTH-1 downto 0)
	) ;
end entity ; -- SW_mid_comb

architecture SW_mid_comb_arch of SW_mid_comb is

	signal data:	std_logic_vector(MEM_DATA_WIDTH-1 downto 0) ;

begin

	data	<= init_in & T_in & V_in & F_in	when ( ctrl_use_PE_T_in = '1');
			else initial_init_in & initial_T_in & to_unsigned(0, VAL_DATA_WIDTH * 2);

	-- State logic
	proc_data : process( clock )
	begin
		if( rising_edge(clock) ) then
			if ( areset_n = '0' ) then
				data_out <= to_unsigned(0, MEM_DATA_WIDTH);
			else
				data_out <= data;
			end if ;
		end if ;
	end process ; -- proc_state

end architecture ; -- SW_mid_comb_arch