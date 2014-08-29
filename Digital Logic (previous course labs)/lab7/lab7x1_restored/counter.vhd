library ieee;
use ieee.std_logic_1164.all;

entity COUNTER is port(
	Qn:	buffer std_logic_vector(3 downto 0);
	Q:			in std_logic_vector(3 downto 0);
	EV_L, CW:		in std_logic;
	R,G,Y:		out std_logic);
	
	end COUNTER;

architecture behav of COUNTER is
signal EV:	 std_logic;
begin
	EV <= not(EV_L);
	Qn(3) <=(not Q(3) and     Q(2) and     Q(1) and     Q(0)) or
	        (    Q(3) and not Q(2) and not Q(1) and not Q(0)) or
	        (    Q(3) and not Q(2) and not Q(1) and     Q(0)) or
	        (    Q(3) and not Q(2) and     Q(1) and not Q(0) and EV);
	              
	Qn(2) <=(not Q(3) and not Q(2) and not Q(1) and     Q(0) and     EV) or
	        (not Q(3) and not Q(2) and not Q(1) and not Q(0) and     EV) or
	        (not Q(3) and not Q(2) and     Q(1) and not Q(0) and     EV) or
	        (not Q(3) and not Q(2) and     Q(1) and     Q(0)              ) or
	        (not Q(3) and     Q(2) and not Q(1) and not Q(0)              ) or
	        (not Q(3) and     Q(2) and not Q(1) and     Q(0)              ) or
	        (not Q(3) and     Q(2) and     Q(1) and not Q(0)              ) ;
	        
	Qn(1) <= (    Q(3) or     Q(2) or     Q(1) or     Q(0) or EV) and
			(    Q(3) or     Q(2) or not Q(1) or not Q(0) or EV) and
			(    Q(3) or not Q(2) or     Q(1) or     Q(0) or EV) and
			(    Q(3) or not Q(2) or not Q(1) or not Q(0)         ) and
			(not Q(3) or     Q(2) or     Q(1) or     Q(0)         ) and
			(not Q(3) or     Q(2) or not Q(1) or     Q(0) or EV);
			
			
			
			
	Qn(0) <= (not Q(3) and not Q(2) and not Q(1) and not Q(0) and not EV) or
			(not Q(3) and not Q(2) and     Q(1) and not Q(0) and not EV) or
			(not Q(3) and     Q(2) and not Q(1) and not Q(0) and not EV and CW) or
			(not Q(3) and     Q(2) and     Q(1) and not Q(0)                        ) or
			(    Q(3) and not Q(2) and not Q(1) and not Q(0)                        );
			
	R    <= (Q(3)) or
			((not Q(3) and   Q(2) and  Q(1) and  Q(0)));
			
	Y    <= (not Q(3) and not Q(2) and not Q(1) and not Q(0) and     EV) or
			(not Q(3) and not Q(2) and not Q(1) and     Q(0) and     EV) or
			(not Q(3) and not Q(2) and     Q(1) and     Q(0) and     EV) or
			(not Q(3) and not Q(2) and     Q(1) and not Q(0) and     EV) or
			(not Q(3) and     Q(2) and not Q(1) and     Q(0)) or
			(not Q(3) and     Q(2) and     Q(1) and not Q(0));
			
	G    <= (not Q(3) and not Q(2) and not Q(1) and not Q(0) and not EV) or
			(not Q(3) and not Q(2) and not Q(1) and     Q(0) and not EV) or
			(not Q(3) and not Q(2) and     Q(1) and not Q(0) and not EV) or
			(not Q(3) and not Q(2) and     Q(1) and     Q(0) and not EV) or
			(not Q(3) and     Q(2) and not Q(1) and not Q(0) and not EV);
			
			end behav;
	