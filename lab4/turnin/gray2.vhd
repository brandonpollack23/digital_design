library ieee;
use ieee.std_logic_1164.all;

entity gray2 is
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;
    output : out std_logic_vector(3 downto 0));
end gray2;

architecture bhv of gray2 is

signal state,next_state : std_logic_vector(3 downto 0);

begin
	process(clk,rst)
	begin
		if(rst = '1') then
			state <= (others => '0');
		
		elsif(rising_edge(clk)) then
			state <= next_state;
		end if;
	end process;			

	process(clk)
	begin
		case STATE is
			when "0000" =>
				next_STATE <= "0001";
			
			when "0001" =>
				next_STATE <= "0011";
				
			when "0010" =>
				next_STATE <= "0110";
			
			when "0011" =>
				next_STATE <= "0010";
				
			when "0100" =>
				next_STATE <= "1100";
			
			when "0101" =>
				next_STATE <= "0100";
				
			when "0110" =>
				next_STATE <= "0111";
			
			when "0111" =>
				next_STATE <= "0101";
				
			when "1000" =>
				next_STATE <= "0000";
			
			when "1001" =>
				next_STATE <= "1000";
				
			when "1010" =>
				next_STATE <= "1011";
			
			when "1011" =>
				next_STATE <= "1001";
				
			when "1100" =>
				next_STATE <= "1101";
			
			when "1101" =>
				next_STATE <= "1111";
				
			when "1110" =>
				next_STATE <= "1010";
			
			when "1111" =>
				next_STATE <= "1110";
				
			when others =>
					null;
		end case;
	end process;
	
	output <= state;
end bhv;