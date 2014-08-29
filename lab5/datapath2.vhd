library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath2 is
generic
(
	WIDTH : positive := 16
);
port
(
	x,y : in std_logic_vector(WIDTH-1 downto 0);
	x_sel,y_sel,x_en,y_en,output_en,clk,rst,x_y_sub_sel : in std_logic;
	x_lt_y,x_ne_y : out std_logic;
	output : out std_logic_vector(WIDTH-1 downto 0)
);
end datapath2;

architecture bhv of datapath2 is

signal x_mux,subtractor_sig,y_mux,tmpX,tmpY,x_y_mux_0,x_y_mux_1 : std_logic_vector(WIDTH-1 downto 0);

begin
	x_in_mux: entity work.Twoto1Mux
	generic map(WIDTH)
	port map
	(
		sel => x_sel,
		input0 => subtractor_sig,
		input1 => x,
		output => x_mux
	);
	
	y_in_mux: entity work.Twoto1Mux
	generic map(WIDTH)
	port map
	(
		sel => y_sel,
		input0 => subtractor_sig,
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
	
	x_y_mux0: entity work.Twoto1Mux
	generic map(WIDTH)
	port map
	(
		input0 => tmpX,
		input1 => tmpY,
		sel => x_y_sub_sel,
		output => x_y_mux_0
	);
	
	x_y_mux1: entity work.Twoto1Mux
	generic map(WIDTH)
	port map
	(
		input0 => tmpY,
		input1 => tmpX,
		sel => x_y_sub_sel,
		output => x_y_mux_1
	);
	
	sub: entity work.subtractor
	generic map(WIDTH)
	port map
	(
		x => x_y_mux_0,
		y => x_y_mux_1,
		output => subtractor_sig
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