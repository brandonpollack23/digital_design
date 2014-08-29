library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

entity alu_sla is 
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
end alu_sla;

architecture BHV of alu_sla is
	--signals here (none needed) constants here
begin
	process(input1,input2,sel)
		--variables go here
		variable temp : std_logic_vector(WIDTH downto 0);
		variable mul_temp : std_logic_vector(WIDTH*2-1 downto 0);
		variable u_input1 : unsigned(WIDTH downto 0);
		variable u_input2 : unsigned(WIDTH downto 0);
	begin
		--define all status flags (in this case only overflow) after case with ifs
		--also output from temp
		
		--need to initialized my "inputs"
		u_input1 := unsigned('0'&input1);
		u_input2 := unsigned('0'&input2);
		
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
				if(mul_temp(WIDTH*2-1 downto WIDTH) > 0) then
					overflow <= '1';
				end if;
				
				
			when "0011" => --bitwise and
				temp := '0'&(input1 and input2);
				
			when "0100" => --bitwise or
				temp := '0'&(input1 or input2);
				
			when "0101" => --bitwise xor
				temp := '0'&(input1 xor input2);
				
			when "0110" => --bitwise nor
				temp := '0'&(input1 nor input2);
				
			when "0111" => --not input1
				temp := '0'&(not input1);
				--temp(WIDTH) := '0';
				
			when "1000" => --left shift input 1 by one bit and overflow if overshift
				temp(WIDTH downto 1) := input1(WIDTH-1 downto 0);
				temp(0) := '0';
				--another method
				--temp(WIDTH-1 downto 1) := u_input1(WIDTH-2 downto 0);
				--temp(0) := 0;
				overflow <= temp(WIDTH);
				
			when "1001" => --right shift input1 by one bit
				--temp := SHIFT_RIGHT(input1,1);
				temp(WIDTH-2 downto 0) := temp(WIDTH-1 downto 1);
				temp(WIDTH downto WIDTH-1) := "00";
				
			when "1010" => --swap upper and lower nibbles of input1
				temp(WIDTH/2-1 downto 0) := input1(WIDTH-1 downto WIDTH/2);
				temp(WIDTH-1 downto WIDTH/2) := input1(WIDTH/2-1 downto 0);
				
			when "1011" => --reverse the bits in input 1
				for i in 1 to WIDTH loop
					temp(WIDTH - i) := input1(i-1);
				end loop;					
				
			when others =>
				temp := conv_std_logic_vector(0,WIDTH+1);
				
		end case;		
			
		output <= std_logic_vector(temp(WIDTH-1 downto 0));
		
	end process;
	
end BHV;