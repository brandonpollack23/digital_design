library ieee;
use ieee.std_logic_1164.all;

-- DO NOT CHANGE ANYTHING IN THE ENTITY

entity adder is
  port (
    input1    : in  std_logic_vector(3 downto 0);
    input2    : in  std_logic_vector(3 downto 0);
    carry_in  : in  std_logic;
    sum       : out std_logic_vector(3 downto 0);
    carry_out : out std_logic);
end adder;

-- DEFINE A RIPPLE-CARRY ADDER USING A STRUCTURE DESCRIPTION THAT CONSISTS OF 4
-- FULL ADDERS

architecture STR of adder is  

signal ZeroToOne, OneToTwo, TwoToThree : std_logic;

begin  -- STR

	fa_0 : entity work.fa port map (
		carry_in => carry_in,
		input1 => input1(0),
		input2 => input2(0),
		sum => sum(0),
		carry_out => ZeroToOne
	);
	
	fa_1 : entity work.fa port map (
		carry_in => ZeroToOne,
		input1 => input1(1),
		input2 => input2(1),
		sum => sum(1),
		carry_out => OneToTwo
	);
	
	fa_2 : entity work.fa port map (
		carry_in => OneToTwo,
		input1 => input1(2),
		input2 => input2(2),
		sum => sum(2),
		carry_out => TwoToThree
	);
	
	fa_3 : entity work.fa port map (
		carry_in => TwoToThree,
		input1 => input1(3),
		input2 => input2(3),
		sum => sum(3),
		carry_out => carry_out
	);		

end STR;
