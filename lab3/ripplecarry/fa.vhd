library ieee;
use ieee.std_logic_1164.all;

entity fa is
	port
	(
		a : in std_logic;
		b : in std_logic;
		cin : in std_logic;
		sum : out std_logic;
		cout : out std_logic
	);
end fa;

architecture BHV of fa is

signal case1,case2,case3 : std_logic;

begin 
	sum <= a xor b xor cin;
	
	case1 <= a and b;
	case2 <= a and cin;
	case3 <= b and cin;
	
	cout <= case1 or case2 or case3;  
end BHV;