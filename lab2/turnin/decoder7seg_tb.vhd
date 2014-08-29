library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder7seg_tb is
end decoder7seg_tb;

architecture TB of decoder7seg_tb is
  --define needed signals here
	signal input : std_logic_vector(3 downto 0);
	signal output : std_logic_vector(6 downto 0);

begin
  --instantiate test entity here
	t_Decoder : entity work.decoder7seg port map
	(
		input => input,
		output => output
	);
	
	process
	  --define needed variables here, then begin function declaration
	  
	  
		function decoder7seg_test(signal input : std_logic_vector(3 downto 0))
		return std_logic_vector is
		begin
			case input is
			when "0000" =>
				return "0000001";
				
			when "0001" =>
				return "1001111";
				
			when "0010" =>
				return "0010010";
				
			when "0011" =>
				return "0000110";
				
			when "0100" =>
				return "1001100";
				
			when "0101" =>
				return "0100100";
				
			when "0110" =>
				return "0100000";
				
			when "0111" =>
				return "0001111";
				
			when "1000" =>
				return "0000000";
				
			when "1001" =>
				return "0001100";
				
			when "1010" =>
				return "0001000";
				
			when "1011" =>
				return "1100000";
				
			when "1100" =>
				return "0110001";
				
			when "1101" =>
				return "1000010";
				
			when "1110" =>
				return "0110000";
				
			when "1111" =>
				return "0111000";	
				
			when others =>
			  return "1111111";
			
		end case;
	end decoder7seg_test;
	
begin
	
		for i in 0 to 15 loop
		
		--input value to input 
		input <= std_logic_vector(to_unsigned(i,4)); --i in binary
		--wait to get outputs
		wait for 40 ns;
		--assert statement that checks output is equal to function return value
		assert(output = decoder7seg_test(input))
			report "Error : output is not equal to test for input value " & integer'image(to_integer(output)) & "instead of " integer'image(to_integer(decoder7seg_test(input))) severity warning;
		end loop;
		
	report "SIMULATION FINISHED!";
	wait;
	end process;
end TB;
		