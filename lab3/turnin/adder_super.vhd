library ieee;
use ieee.std_logic_1164.all;

entity adder_super is 
	generic
	(
		WIDTH : positive := 4
	);
	port
	(
		 x, y  : in  std_logic_vector(WIDTH-1 downto 0);
		 cin   : in  std_logic;
		 s     : out std_logic_vector(WIDTH-1 downto 0);
		 cout  : out std_logic;
		 bg : out std_logic;
		 bp : out std_logic
	);
end adder_super;

architecture arch of adder_super is --recursive magic
	
signal bg0,bp0,bg1,bp1,cout_in_between : std_logic;
constant HALFWIDTH : positive := WIDTH/2;

begin	
	end_condition: if(WIDTH = 2) generate
		end_adder : entity work.cla2 port
		map
		(
			x(1 downto 0) => x(1 downto 0),
			y(1 downto 0) => y(1 downto 0),
			cin => cin,
			s(1 downto 0) => s(1 downto 0),
			cout => cout,
			bp => bp,
			bg => bg
		);
	end generate end_condition;
		
	adderx: if(WIDTH /= 2) generate
		ADDER_LOW : entity work.adder_super
		generic map
		(
			WIDTH => HALFWIDTH
		)
		port map
		(
			x(HALFWIDTH-1 downto 0) => x(HALFWIDTH-1 downto 0),
			y(HALFWIDTH-1 downto 0) => y(HALFWIDTH-1 downto 0),
			s(HALFWIDTH-1 downto 0) => s(HALFWIDTH-1 downto 0),
			cin => cin,			
			bp => bp0,
			bg => bg0
		);
		
		CGEN : entity work.cgen2
		port map
		(
			ci => cin,
			pi => bp0,
			gi => bg0,
			pi_n => bp1,
			gi_n => bg1,
			cout => cout,
			cout_in_between => cout_in_between,
			bp => bp,
			bg => bg
		);
	
		ADDER_HIGH : entity work.adder_super
		generic map
		(
			WIDTH => WIDTH/2
		)
		port map
		(
			x(HALFWIDTH-1 downto 0) => x(WIDTH-1 downto HALFWIDTH),
			y(HALFWIDTH-1 downto 0) => y(WIDTH-1 downto HALFWIDTH),
			cin => cout_in_between,
			s(HALFWIDTH-1 downto 0) => s(WIDTH-1 downto HALFWIDTH),
			bp => bp1,
			bg => bg1
		);
	end generate adderx;
end arch;
		
