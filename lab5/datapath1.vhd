library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath1 is
generic
(
	WIDTH : positive := 16
);
port
(
	x,y : in std_logic_vector(WIDTH-1 downto 0);
	x_sel,y_sel,x_en,y_en,output_en,clk,rst : in std_logic;
	x_lt_y,x_ne_y : out std_logic;
	output : out std_logic_vector(WIDTH-1 downto 0)
);
end datapath1;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Twoto1Mux is
generic
(
	WIDTH : positive := 16
);
port
(
	sel : in std_logic;
	input0 : in std_logic_vector(WIDTH-1 downto 0);
	input1 : in std_logic_vector(WIDTH-1 downto 0);
	output : out std_logic_vector(WIDTH-1 downto 0)
);
end Twoto1Mux;

architecture bhv of Twoto1Mux is
begin
	process(sel, input0, input1)
	begin
		if(sel = '1') then
			output <= input1;
		else
			output <= input0;
		end if;
	end process;
end bhv;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity enable_reg is
generic
(
	WIDTH : positive := 16
);
port
(
	D : in std_logic_vector(WIDTH-1 downto 0);
	enable,clk, rst : in std_logic;
	output : buffer std_logic_vector(WIDTH-1 downto 0)
);
end enable_reg;

architecture bhv of enable_reg is
begin
	process(clk,rst)
	begin
		if(rst = '1') then
			output <= (others => '0');
		elsif(rising_edge(clk)) then
			if(enable = '1') then
				output <= D;
			else
				output <= output;
			end if;
		end if;
	end process;
end bhv;
		
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity subtractor is
generic
(
	WIDTH : positive := 16
);
port
(
	x,y : in std_logic_vector(WIDTH-1 downto 0);
	output : out std_logic_vector(WIDTH-1 downto 0)
);
end subtractor;

architecture bhv of subtractor is
begin
	output <= std_logic_vector(signed(x) - signed(y));
end bhv;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity comparator is
generic
(
	WIDTH : positive := 16
);
port
(
	x,y : in std_logic_vector(WIDTH-1 downto 0);
	x_lt_y : out std_logic; --less than y
	x_ne_y : out std_logic	--not equal to y
);
end comparator;

architecture bhv of comparator is
begin
	process(x,y)
	begin
		x_ne_y <= '1';
		x_lt_y <= '1';
		if(x = y) then
			x_ne_y <= '0';
			x_lt_y <= '0';
		elsif(x > y) then
			x_lt_y <= '0';
		end if;
	end process;
end bhv;

architecture bhv of datapath1 is

signal x_mux,x_sub,y_sub,y_mux,tmpX,tmpY : std_logic_vector(WIDTH-1 downto 0);

begin
	x_in_mux: entity work.Twoto1Mux
	generic map(WIDTH)
	port map
	(
		sel => x_sel,
		input0 => x_sub,
		input1 => x,
		output => x_mux
	);
	
	y_in_mux: entity work.Twoto1Mux
	generic map(WIDTH)
	port map
	(
		sel => y_sel,
		input0 => y_sub,
		input1 => y,
		output => y_mux
	);
	
	x_reg: entity work.enable_reg
	generic map(WIDTH)
	port map
	(
		D => x_mux,
		output => tmpX,
		enable => x_en,
		clk => clk,
		rst => rst
	);
	
	y_reg: entity work.enable_reg
	generic map(WIDTH)
	port map
	(
		D => y_mux,
		output => tmpY,
		enable => y_en,
		clk => clk,
		rst => rst
	);
	
	x_minus_y_sub: entity work.subtractor
	generic map(WIDTH)
	port map
	(
		x => tmpX,
		y => tmpY,
		output => x_sub
	);
	
	y_minus_x_sub: entity work.subtractor
	generic map(WIDTH)
	port map
	(
		x => tmpY,
		y => tmpX,
		output => y_sub
	);
	
	compare: entity work.comparator
	generic map(WIDTH)
	port map
	(
		x => tmpX,
		y => tmpY,
		x_lt_y => x_lt_y,
		x_ne_y => x_ne_y
	);
	
	output_reg: entity work.enable_reg
	generic map(WIDTH)
	port map
	(
		D => tmpX,
		enable => output_en,
		output => output,
		clk => clk,
		rst => rst
	);
end bhv;