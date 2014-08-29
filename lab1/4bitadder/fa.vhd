library ieee;
use ieee.std_logic_1164.all;

-- DO NOT CHANGE ANYTHING IN THE ENTITY

entity fa is
  port (
    input1    : in  std_logic;
    input2    : in  std_logic;
    carry_in  : in  std_logic;
    sum       : out std_logic;
    carry_out : out std_logic);
end fa;

-- DEFINE THE FULL ADDER HERE

architecture BHV of fa is

signal case1,case2,case3 : std_logic;

begin 
	sum <= input1 xor input2 xor carry_in;
	
	case1 <= input1 and input2;
	case2 <= input1 and carry_in;
	case3 <= input2 and carry_in;
	
	carry_out <= case1 or case2 or case3;  
end BHV;
