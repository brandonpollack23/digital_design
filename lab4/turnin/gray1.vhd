library ieee;
use ieee.std_logic_1164.all;

entity gray1 is
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;
    output : out std_logic_vector(3 downto 0));
end gray1;

architecture bhv of gray1 is

signal STATE : std_logic_vector(3 downto 0);

begin

	process(clk,rst)	
	begin
		if(rst = '1') then
			STATE <= (others => '0');
			output <= (others => '0');
		
		elsif(rising_edge(clk)) then
			case STATE is
				when "0000" =>
					STATE <= "0001";
				
				when "0001" =>
					STATE <= "0011";
					
				when "0010" =>
					STATE <= "0110";
				
				when "0011" =>
					STATE <= "0010";
					
				when "0100" =>
					STATE <= "1100";
				
				when "0101" =>
					STATE <= "0100";
					
				when "0110" =>
					STATE <= "0111";
				
				when "0111" =>
					STATE <= "0101";
					
				when "1000" =>
					STATE <= "0000";
				
				when "1001" =>
					STATE <= "1000";
					
				when "1010" =>
					STATE <= "1011";
				
				when "1011" =>
					STATE <= "1001";
					
				when "1100" =>
					STATE <= "1101";
				
				when "1101" =>
					STATE <= "1111";
					
				when "1110" =>
					STATE <= "1010";
				
				when "1111" =>
					STATE <= "1110";
					
				when others =>
					null;
			end case;
			
			output <= state;
		end if;
	end process;
end bhv;