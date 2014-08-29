library ieee;
use IEEE.std_logic_1164.all;

entity TRAFFIC is port(
	clk,reset:	in std_logic;
	R,Y,G:	out std_logic;
	CW,EV:	in std_logic);
	end TRAFFIC;
	
architecture behav of TRAFFIC is
	type state_type is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10);
	signal current_s,next_s: state_type;
	
	begin
	process(clk,reset)
		begin
			if (reset='1') then current_s<=s0;
			elsif (rising_edge(clk)) then current_s<=next_s;
			end if;
		end process;
	
	process (current_s, CW,EV)
		begin
			case current_s is
				when s0 =>
					if (EV='1') then
						R<='0';
						G<='0';
						Y<='1'; 
						next_s<=s6;
					else
						R<='0';
						G<='1';
						Y<='0';
						next_s<=s1;
					end if;
					
				when s1 =>
					if (EV='1') then
						R<='0';
						G<='0';
						Y<='1'; 
						next_s<=s6;
					else
						R<='0';
						G<='1';
						Y<='0';
						next_s<=s2;
					end if;
					
				when s2 =>
					if (EV='1') then
						R<='0';
						G<='0';
						Y<='1'; 
						next_s<=s6;
					else
						R<='0';
						G<='1';
						Y<='0';
						next_s<=s3;
					end if;
					
				when s3 =>
					if (EV='1') then
						R<='0';
						G<='0';
						Y<='1'; 
						next_s<=s6;
					else
						R<='0';
						G<='1';
						Y<='0';
						next_s<=s4;
					end if;
					
				when s4 =>
					if (EV='1') then
						R<='0';
						G<='0';
						Y<='1'; 
						next_s<=s6;
					elsif (EV='0'and CW='0') then
						R<='0';
						G<='1';
						Y<='0';
						next_s<=s0;
					elsif (EV='0'and CW='1') then
						R<='0';
						G<='1';
						Y<='0';
						next_s<=s5;					
					end if;
					
				when s5 =>
					R<='0';
					G<='0';
					Y<='1';
					next_s<=s6;
					
				when s6 =>
					R<='0';
					G<='0';
					Y<='1';
					next_s<=s7;
					
				when s7 =>
					R<='1';
					G<='0';
					Y<='0';
					next_s<=s8;
				
				when s8 =>
					R<='1';
					G<='0';
					Y<='0';
					next_s<=s9;
					
				when s9 =>
					R<='1';
					G<='0';
					Y<='0';
					next_s<=s10;
					
				when s10 =>
					R<='1';
					G<='0';
					Y<='0';
					if (EV='1') then
						next_s<=s10;
					else
						next_s<=s0;
					end if;
			end case;
		end process;
		
	end behav;
					
				
	