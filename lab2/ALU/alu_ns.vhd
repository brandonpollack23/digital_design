library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity alu_ns is 
	generic 
	( 
		WIDTH : positive := 8
	); 
	port 
	( 
		input1 : in std_logic_vector(WIDTH-1 downto 0); 
		input2 : in std_logic_vector(WIDTH-1 downto 0); 
		sel : in std_logic_vector(3 downto 0); 
		output : out std_logic_vector(WIDTH-1 downto 0); 
		overflow : out std_logic 
	); 
end alu_ns;

architecture BHV of alu_ns is
	--signals here (none needed) constants here
begin
	process(input1,input2,sel)
		--variables go here
		variable temp : unsigned(WIDTH downto 0);
		variable mul_temp : unsigned(WIDTH*2-1 downto 0);
		variable u_input1 : unsigned(WIDTH downto 0);
		variable u_input2 : unsigned(WIDTH downto 0);
		variable mul_or : unsigned(WIDTH-1 downto 0);
		variable quiz_temp : unsigned(WIDTH-1 downto 0);
	begin
		--define all status flags (in this case only overflow) after case with ifs
		--also output from temp
		
		--need to initialized my "inputs"
		temp := (others => '0');
		u_input1 := unsigned('0'&input1);
		u_input2 := unsigned('0'&input2);
		mul_or := (others => '0');
		quiz_temp := (others => '0');
		
		--default values of outputs
		overflow <= '0';
		
		case sel is
		
			when "0000" => --add (overflow instead of carry) OVERFLOW AFFECTED
				temp := (u_input1 + u_input2);
				overflow <= temp(WIDTH); 
			
			when "0001" => --subtract
				temp := (u_input1 - u_input2);
				
			when "0010" => --multiply, output lower byte of result OVERFLOW AFFECTED
				mul_temp := u_input1(WIDTH-1 downto 0) * u_input2(WIDTH-1 downto 0);
				temp := mul_temp(WIDTH downto 0);
				if(mul_temp(WIDTH*2-1 downto WIDTH) = 0) then
					overflow <= '0';
				else
					overflow <= '1';
				end if;
--				for i in WIDTH to 2*WIDTH-1 loop
--					mul_or(i - WIDTH) := mul_or(i - WIDTH) or mul_temp(i);
--				end loop;
--				
--				overflow <= mul_or(WIDTH-1);
				
				
				
			when "0011" => --bitwise and
				temp := (u_input1 and u_input2);
				
			when "0100" => --bitwise or
				temp := (u_input1 or u_input2);
				
			when "0101" => --bitwise xor
				temp := (u_input1 xor u_input2);
				
			when "0110" => --bitwise nor
				temp := (u_input1 nor u_input2);
				
			when "0111" => --not input1
				temp := not u_input1;
				temp(WIDTH) := '0';
				
			when "1000" => --left shift input 1 by one bit and overflow if overshift
				temp := SHIFT_LEFT(u_input1,1);
				--another method
				--temp(WIDTH-1 downto 1) := u_input1(WIDTH-2 downto 0);
				--temp(0) := 0;
				overflow <= temp(WIDTH);
				
			when "1001" => --right shift input1 by one bit
				temp := SHIFT_RIGHT(u_input1,1);
				
			when "1010" => --swap upper and lower nibbles of input1
				temp(WIDTH/2-1 downto 0) := u_input1(WIDTH-1 downto WIDTH/2);
				temp(WIDTH-1 downto WIDTH/2) := u_input1(WIDTH/2-1 downto 0);
				
			when "1011" => --reverse the bits in input 1
				for i in 1 to WIDTH loop
					temp(WIDTH - i) := u_input1(i-1);
				end loop;

			when "1100" => --quiz
				quiz_temp(WIDTH/2-2 downto 0) := u_input1(WIDTH/2-1 downto 1);
				quiz_temp(WIDTH/2-1) := u_input1(0);
				temp(WIDTH-1 downto WIDTH/2) := SHIFT_LEFT(u_input1(WIDTH-1 downto WIDTH/2),1);
				temp(WIDTH/2-1 downto 0) := quiz_temp(WIDTH/2-1 downto 0);
				if(u_input1(WIDTH-1 downto WIDTH/2) + u_input1(WIDTH/2-1 downto 0) > 3) then
					overflow <= '1';
				end if;
				
				
				
			when others =>
				temp := to_unsigned(0,WIDTH+1);
				
		end case;		
			
		output <= std_logic_vector(temp(WIDTH-1 downto 0));
		
	end process;
	
end BHV;	
				