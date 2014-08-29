library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clk_div is
  generic(clk_in_freq : natural;
          clk_out_freq : natural);
  port (
    clk_in : in  std_logic;
    clk_out : out std_logic; 
    rst      : in  std_logic);
end clk_div;

architecture BHV of clk_div is

constant MAX_COUNT : natural := clk_in_freq/clk_out_freq;
constant COUNTER_WIDTH : integer := integer(ceil(log2(real(MAX_COUNT))));
signal counter : unsigned(COUNTER_WIDTH-1 downto 0);


begin
	process(clk_in,rst)
	
	variable clk_out_temp : std_logic;
	
	begin
		OUTER: if(rst = '1') then
			clk_out_temp := '0';
			counter <= (others => '0');
			
		elsif(rising_edge(clk_in)) then
			counter <= counter + 1;
			
			INNER: if(counter = MAX_COUNT/2-1) then
				clk_out_temp := not clk_out_temp;
				counter <= (others => '0');
			end if INNER;
			
		end if OUTER;
		
		clk_out <= clk_out_temp;
	end process;
end BHV;
		