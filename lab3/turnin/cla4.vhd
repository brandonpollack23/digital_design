library ieee;
use ieee.std_logic_1164.all;

entity cla4 is 
	port
	(
		x : in std_logic_vector(3 downto 0);
		y : in std_logic_vector(3 downto 0);
		cin : in std_logic;
		cout : out std_logic;
		sum : out std_logic_vector(3 downto 0);
		bp : out std_logic;
		bg : out std_logic
	);
end cla4;

architecture arch of cla4 is

signal bp0,bp1,bg0,bg1,cout_in_between : std_logic;

begin

	U0 : entity work.cla2 port
	map
	(
		x(1 downto 0) => x(1 downto 0),
		y(1 downto 0) => y(1 downto 0),
		cin => cin,
		s(1 downto 0) => sum(1 downto 0),
		bp => bp0,
		bg => bg0
	);
	
	cgen : entity work.cgen2 port
	map
	(
		ci => cin,
		pi => bp0,
		gi => bg0,
		pi_n => bp1,
		gi_n => bg1,
		cout_in_between => cout_in_between,
		bp => bp,
		bg => bg,
		cout => cout
	);
	
	U1 : entity work.cla2 port
	map
	(
		x(1 downto 0) => x(3 downto 2),
		y(1 downto 0) => y(3 downto 2),
		cin => cout_in_between,
		s(1 downto 0) => sum(3 downto 2),
		bp => bp1,
		bg => bg1
	);
end arch;	