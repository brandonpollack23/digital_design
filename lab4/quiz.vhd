library ieee;
use ieee.std_logic_1164.all;

entity quiz is
port
(
	x,y,clk,rst : in std_logic;
	output : out std_logic_vector(3 downto 0)
);
end quiz;

architecture bhv of quiz is

signal next_count, count: std_logic_vector(3 downto 0);

begin
	process(clk,rst)
	begin
		if(rst = '1') then
			count <= "0001";
		
		elsif(rising_edge(clk)) then
			count <= next_count;
		end if;
	end process;
	
	process(clk)
	begin
		case count is
			when "0001" =>
				if(x = '0') then
					next_count <= "0010";
				else
					next_count <= "1100";
				end if;
			when "0010" =>
				if(x = '0') then
					next_count <= x"A";
				else
					next_count <= x"1";
				end if;
			when x"A" =>
				if(x = '0') then
					next_count <= x"B";
				else
					next_count <= x"2";
				end if;
			when x"B" =>
				if(x = '1') then
					next_count <= x"A";
				else
					if(y = '0') then
						next_count <= x"1";
					else
						next_count <= x"c";
					end if;
				end if;
				
			when x"C" =>
				if(x = '1') then
					next_count <= x"B";
				else
					next_count <= x"1";
				end if;
			
			when others => null;
		end case;
	end process;
	
	output <= count;
end bhv;
	
					