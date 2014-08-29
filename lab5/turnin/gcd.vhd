library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gcd is
  generic (
    WIDTH : positive := 8);
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;
    go     : in  std_logic;
    done   : out std_logic;
    x      : in  std_logic_vector(WIDTH-1 downto 0);
    y      : in  std_logic_vector(WIDTH-1 downto 0);
    output : out std_logic_vector(WIDTH-1 downto 0));
end gcd;

architecture FSMD of gcd is

type state_t is (START,INPUT_LOAD,SUBTRACT,FINAL);
signal state : state_t;
signal tmpX,tmpY : std_logic_vector(WIDTH-1 downto 0);

begin  -- FSMD
	process(clk,rst)
	
	variable temp_output : std_logic;
	
	begin
		if(rst = '1') then
			state <= START;
			output <= (others => '0');
			tmpX <= (others => '0');
			tmpY <= (others => '0');
			done <= '0';
		
		elsif(rising_edge(clk)) then
			case state is
				when START =>
					done <= '0';
					if(go = '1') then
						state <= INPUT_LOAD;
					else
						state <= START;
					end if;
				when INPUT_LOAD =>
					tmpX <= x;
					tmpY <= y;
					state <= SUBTRACT;
				when SUBTRACT =>
					if(tmpX = tmpY) then
						state <= FINAL;
						done <= '1';
						output <= tmpX;
					elsif(tmpX < tmpY) then
						tmpY <= std_logic_vector(unsigned(tmpY) - unsigned(tmpX));
						state <= SUBTRACT;
					elsif(tmpX > tmpY) then
						tmpX <= std_logic_vector(unsigned(tmpX) - unsigned(tmpY));
						state <= SUBTRACT;
					end if;
				when FINAL =>
					if(go = '1') then
						done <= '1';
						state <= FINAL;
					else
						state <= START;
						done <= '0';
					end if;
			end case;
		end if;
	end process;
end FSMD;
--
architecture FSM_D1 of gcd is

signal x_lt_y,x_ne_y,x_sel,y_sel,x_en,y_en,output_en : std_logic;

begin  -- FSM_D1
	CONTROL : entity work.ctrl1
	port map
	(
		x_lt_y => x_lt_y,
		x_ne_y => x_ne_y,
		go => go,
		done => done,
		x_sel => x_sel,
		y_sel => y_sel,
		x_en => x_en,
		y_en => y_en,
		output_en => output_en,
		clk => clk,
		rst => rst
	);
	
	DATAPATH : entity work.datapath1
	generic map(WIDTH)
	port map
	(
		x => x,
		y => y,
		x_lt_y => x_lt_y,
		x_ne_y => x_ne_y,
		x_sel => x_sel,
		x_en => x_en,
		y_sel => y_sel,
		y_en => y_en,
		output_en => output_en,
		clk => clk,
		rst => rst,
		output => output
	);
end FSM_D1;
--
architecture FSM_D2 of gcd is

signal x_lt_y,x_ne_y,x_sel,y_sel,x_en,y_en,output_en,x_y_sub_sel : std_logic;

begin  -- FSM_D2
	CONTROL : entity work.ctrl2
	port map
	(
		x_lt_y => x_lt_y,
		x_ne_y => x_ne_y,
		go => go,
		done => done,
		x_sel => x_sel,
		y_sel => y_sel,
		x_en => x_en,
		y_en => y_en,
		output_en => output_en,
		clk => clk,
		rst => rst,
		x_y_sub_sel => x_y_sub_sel
	);
	
	DATAPATH : entity work.datapath2
	generic map(WIDTH)
	port map
	(
		x => x,
		y => y,
		x_lt_y => x_lt_y,
		x_ne_y => x_ne_y,
		x_sel => x_sel,
		x_en => x_en,
		y_sel => y_sel,
		y_en => y_en,
		output_en => output_en,
		clk => clk,
		rst => rst,
		output => output,
		x_y_sub_sel => x_y_sub_sel
	);
end FSM_D2;
--
--
---- EXTRA CREDIT
architecture FSMD2 of gcd is

type state_t is (START,INPUT_LOAD,SUBTRACT,FINAL);
signal state, next_state : state_t;
signal tmpX,tmpY : std_logic_vector(WIDTH-1 downto 0);
signal next_tmpX,next_tmpY : std_logic_vector(WIDTH-1 downto 0);

begin  -- FSMD2
	process(clk,rst)
	begin
		if(rst = '1') then
			state <= START;
			tmpX <= (others => '0');
			tmpY <= (others => '0');
		elsif(rising_edge(clk)) then
			state <= next_state;
			tmpx <= next_tmpX;
			tmpy <= next_tmpY;
		end if;
	end process;
	
	process(go,clk)
	begin
		done <= '0';
		output <= (others => '0'); --default value for output, should only be read when done is true anyway
		next_tmpX <= tmpX;
		next_tmpY <= tmpY;
		next_state <= state;
		
		case state is
			when START =>
				if(go = '1') then
					next_state <= INPUT_LOAD;
				else
					next_state <= START;
				end if;
			
			when INPUT_LOAD =>
				next_tmpX <= x;
				next_tmpY <= y;
				next_state <= SUBTRACT;
			
			when SUBTRACT =>
				if(tmpX = tmpY) then
					next_state <= FINAL;
				elsif(tmpX < tmpY) then
					next_tmpY <= std_logic_vector(unsigned(tmpY) - unsigned(tmpX));
					next_state <= SUBTRACT;
				elsif(tmpX > tmpY) then
					next_tmpX <= std_logic_vector(unsigned(tmpX) - unsigned(tmpY));
					next_state <= SUBTRACT;
				end if;
					
			when FINAL =>
				output <= tmpX;
				done <= '1';
				if(go = '0') then
					next_state <= START;
				else
					next_state <= FINAL;
				end if;
		end case;
	end process;
end FSMD2;