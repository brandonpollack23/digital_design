library ieee;
use ieee.std_logic_1164.all;

entity ctrl2 is
port
(
	x_lt_y,x_ne_y,go : in std_logic;
	x_sel,y_sel,x_en,y_en,output_en,done,x_y_sub_sel : out std_logic;
	clk,rst: in std_logic
);
end ctrl2;

architecture bhv of ctrl2 is

type state_t is (START,INPUT_LOAD,SUBTRACT,FINAL);
signal state,next_state : state_t;

begin
	process(clk,rst)
	begin
		if(rst = '1') then
			state <= START;
		elsif(rising_edge(clk)) then
			state <= next_state;
		end if;
	end process;
	
	process(state,go,x_lt_y,x_ne_y)
	begin
		x_sel <= '0';
		y_sel <= '0'; --default load from subtractor
		x_en <= '0';
		y_en <= '0';
		output_en <= '0';
		done <= '0';
		
		case state is
			when START =>
				if(go = '1') then
					next_state <= INPUT_LOAD;
				else
					next_state <= START;
				end if;
				
			when INPUT_LOAD =>
				next_state <= SUBTRACT;
				x_sel <= '1';
				y_sel <= '1';
				x_en <= '1';
				y_en <= '1';
				
			when SUBTRACT =>
				if(x_ne_y = '0') then --x is equal to y so we are done
					output_en <= '1';
					next_state <= FINAL;
				elsif(x_lt_y = '1') then --x less than y
					y_en <= '1'; --load y with y-x, default mux value
					x_y_sub_sel <= '1';
					next_state <= SUBTRACT;
				else --load x with x-y
					x_en <= '1'; 
					x_y_sub_sel <= '0';
					next_state <= SUBTRACT;
				end if;
					
			when FINAL =>
				done <= '1';
				if(go = '1') then
					next_state <= FINAL;
				else
					next_state <= START;
				end if;
		end case;
	end process;
end bhv;