library ieee;
use ieee.std_logic_1164.all;

entity CONTROLLER is port(
	Q1, Q0, IR2, IR1, IR0: in std_logic;
	Q1n, Q0n: buffer std_logic;
	MSA, MSB: out std_logic_vector(1 downto 0);
	MSC: out std_logic_vector(2 downto 0);
	PC_INC, PC_LD_L, IR_LD: out std_logic);
	end CONTROLLER;
	
architecture behav of CONTROLLER is
signal PC_LD: std_logic;
begin
	PC_LD_L<=not PC_LD;
	
	Q1n<=   (not Q1 and    Q0 and not IR2 and not IR1 and not IR0) or
		    (not Q1 and    Q0 and     IR2 and not IR1 and     IR0);
	
	Q0n<=   (not Q1 and not Q0) or (not Q1 and    Q0 and     IR2 and not IR1 and     IR0);
	
	MSA(1)<=(not Q1 and    Q0 and not IR2 and     IR1 and not IR0) or
			(not Q1 and    Q0 and not IR2 and     IR1 and     IR0) or
			(not Q1 and    Q0 and     IR2 and not IR1 and not IR0);
			
	MSA(0)<= not Q1 or Q0;
	
	MSB(1)<=Q1 or not Q0 or IR2 or IR1 or not IR0;
	
	MSB(0)<=not Q1 and  Q0 and not IR2 and not IR1 and  IR0;
	
	MSC(2)<=(not Q1 and    Q0 and not IR2 and     IR1 and not IR0) or
			(not Q1 and    Q0 and not IR2 and     IR1 and     IR0) or
			(not Q1 and    Q0 and     IR2 and not IR1 and not IR0);
	
	MSC(1)<=(not Q1 and    Q0 and not IR2 and     IR1 and     IR0) or
			(not Q1 and    Q0 and     IR2 and not IR1 and not IR0);
			
	MSC(0)<=(not Q1 and    Q0 and not IR2 and     IR1 and not IR0) or
			(not Q1 and    Q0 and not IR2 and     IR1 and     IR0);
			
	PC_INC<=(Q1 or Q0) and (not Q1 or not Q0);
	PC_LD<=Q1 and Q0;
	IR_LD<=not Q1 and not Q0;
	
	end behav;
			