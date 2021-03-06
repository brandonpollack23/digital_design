library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu_sla_tb is
end alu_sla_tb;

architecture TB of alu_sla_tb is

  component alu_sla

    generic (
      WIDTH    :     positive := 16
      );
    port (
      input1   : in  std_logic_vector(WIDTH-1 downto 0);
      input2   : in  std_logic_vector(WIDTH-1 downto 0);
      sel      : in  std_logic_vector(3 downto 0);
      output   : out std_logic_vector(WIDTH-1 downto 0);
      overflow : out std_logic
      );

  end component;

  constant WIDTH    : positive                           :=  8;
  signal   input1   : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
  signal   input2   : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
  signal   sel      : std_logic_vector(3 downto 0)       := (others => '0');
  signal   output   : std_logic_vector(WIDTH-1 downto 0);
  signal   overflow : std_logic;

begin  -- TB

  UUT : alu_sla
    generic map (WIDTH => WIDTH)
    port map (
      input1           => input1,
      input2           => input2,
      sel              => sel,
      output           => output,
      overflow         => overflow);

  process
  begin

    -- test 2+6 (no overflow)
    sel    <= "0000";
    input1 <= conv_std_logic_vector(2, input1'length);
    input2 <= conv_std_logic_vector(6, input2'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(8, output'length)) report "Error : 2+6 = " & integer'image(conv_integer(output)) & " instead of 8" severity failure;
    assert(overflow = '0') report "Error                                   : overflow incorrect for 2+8" severity failure;

    -- test 250+50 (with overflow)
    sel    <= "0000";
    input1 <= conv_std_logic_vector(250, input1'length);
    input2 <= conv_std_logic_vector(50, input2'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(300, output'length)) report "Error : 250+50 = " & integer'image(conv_integer(output)) & " instead of 44" severity failure;
    assert(overflow = '1') report "Error                                     : overflow incorrect for 250+50" severity failure;

    -- test 5*6
    sel    <= "0010";
    input1 <= conv_std_logic_vector(5, input1'length);
    input2 <= conv_std_logic_vector(6, input2'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(30, output'length)) report "Error : 5*6 = " & integer'image(conv_integer(output)) & " instead of 30" severity failure;
    assert(overflow = '0') report "Error                                    : overflow incorrect for 5*6" severity failure;

    -- test 50*60
    sel    <= "0010";
    input1 <= conv_std_logic_vector(64, input1'length);
    input2 <= conv_std_logic_vector(64, input2'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(4096, output'length)) report "Error : 64*64 = " & integer'image(conv_integer(output)) & " instead of 0" severity failure;
    assert(overflow = '1') report "Error                                      : overflow incorrect for 64*64" severity failure;

    -- test and
	sel    <= "0011";
    input1 <= conv_std_logic_vector(170, input1'length); --10101010
    input2 <= conv_std_logic_vector(85, input2'length); --01010101
    wait for 40 ns;
    assert(output = conv_std_logic_vector(0, output'length)) report "Error : 10101010 and 01010101 = " & integer'image(conv_integer(output)) & " instead of 0" severity failure;
    assert(overflow = '0') report "Error                                      : overflow incorrect 1" severity failure;
    
	sel    <= "0011";
    input1 <= conv_std_logic_vector(7, input1'length); --10101010
    input2 <= conv_std_logic_vector(15, input2'length); --01010101
    wait for 40 ns;
    assert(output = conv_std_logic_vector(7, output'length)) report "Error : 7 and 15 = " & integer'image(conv_integer(output)) & " instead of 7" severity failure;
    assert(overflow = '0') report "Error                                      : overflow incorrect 2" severity failure;
	
    --test or
	sel    <= "0100";
    input1 <= conv_std_logic_vector(170, input1'length); --10101010
    input2 <= conv_std_logic_vector(85, input2'length); --01010101
    wait for 40 ns;
    assert(output = conv_std_logic_vector(255, output'length)) report "Error : 10101010 or 01010101 = " & integer'image(conv_integer(output)) & " instead of 11111111" severity failure;
    assert(overflow = '0') report "Error                                      : overflow incorrect 3" severity failure;
	
	sel    <= "0100";
    input1 <= conv_std_logic_vector(128, input1'length); --10101010
    input2 <= conv_std_logic_vector(1, input2'length); --01010101
    wait for 40 ns;
    assert(output = conv_std_logic_vector(129, output'length)) report "Error : 10000000 or 00000001 = " & integer'image(conv_integer(output)) & " instead of 10000001" severity failure;
    assert(overflow = '0') report "Error                                      : overflow incorrect 4" severity failure;	
   
    --test xor
	sel    <= "0101";
    input1 <= conv_std_logic_vector(240, input1'length); --10101010
    input2 <= conv_std_logic_vector(60, input2'length); --01010101
    wait for 40 ns;
    assert(output = conv_std_logic_vector(204, output'length)) report "Error : 11110000 xor 00111100 = " & integer'image(conv_integer(output)) & " instead of 11001100" severity failure;
    assert(overflow = '0') report "Error                                      : overflow incorrect 5" severity failure;
	
	sel    <= "0101";
    input1 <= conv_std_logic_vector(129, input1'length); --10101010
    input2 <= conv_std_logic_vector(1, input2'length); --01010101
    wait for 40 ns;
    assert(output = conv_std_logic_vector(128, output'length)) report "Error : 10000001 and 00000001 = " & integer'image(conv_integer(output)) & " instead of 10000000" severity failure;
    assert(overflow = '0') report "Error                                      : overflow incorrect 6" severity failure;
    
    --test nor
    sel    <= "0110";
    input1 <= conv_std_logic_vector(240, input1'length); --10101010
    input2 <= conv_std_logic_vector(60, input2'length); --01010101
    wait for 40 ns;
    assert(output = conv_std_logic_vector(3, output'length)) report "Error : 11110000 nor 00111100 = " & integer'image(conv_integer(output)) & " instead of 00000011" severity failure;
    assert(overflow = '0') report "Error                                      : overflow incorrect 7" severity failure;
	
	sel    <= "0110";
    input1 <= conv_std_logic_vector(129, input1'length); --10101010
    input2 <= conv_std_logic_vector(1, input2'length); --01010101
    wait for 40 ns;
    assert(output = conv_std_logic_vector(126, output'length)) report "Error : 10000001 and 00000001 = " & integer'image(conv_integer(output)) & " instead of 01111110" severity failure;
    assert(overflow = '0') report "Error                                      : overflow incorrect 9" severity failure;
    
    --test not
    sel    <= "0111";
    input1 <= conv_std_logic_vector(128, input1'length); --10101010
    input2 <= conv_std_logic_vector(1, input2'length); --01010101
    wait for 40 ns;
    assert(output = conv_std_logic_vector(127, output'length)) report "Error :  not 10000000  = " & integer'image(conv_integer(output)) & " instead of 01111111" severity failure;
    assert(overflow = '0') report "Error                                      : overflow incorrect 10" severity failure;
	
	sel    <= "0111";
    input1 <= conv_std_logic_vector(170, input1'length); --10101010
    input2 <= conv_std_logic_vector(1, input2'length); --01010101
    wait for 40 ns;
    assert(output = conv_std_logic_vector(85, output'length)) report "Error :  not 10101010  = " & integer'image(conv_integer(output)) & " instead of 01010101" severity failure;
    assert(overflow = '0') report "Error                                      : overflow incorrect 11" severity failure;
	
    --test sl and ov
	sel    <= "1000";
    input1 <= conv_std_logic_vector(25, input1'length); --10101010
    input2 <= conv_std_logic_vector(1, input2'length); --01010101
    wait for 40 ns;
    assert(output = conv_std_logic_vector(50, output'length)) report "Error :  lsl 25 = " & integer'image(conv_integer(output)) & " instead of 50" severity failure;
    assert(overflow = '0') report "Error                                      : overflow incorrect 12" severity failure;
	
	sel    <= "1000";
    input1 <= conv_std_logic_vector(128, input1'length); --10101010
    input2 <= conv_std_logic_vector(1, input2'length); --01010101
    wait for 40 ns;
    assert(output = conv_std_logic_vector(0, output'length)) report "Error :  lsl 128 = " & integer'image(conv_integer(output)) & " instead of 0" severity failure;
    assert(overflow = '1') report "Error                                      : overflow incorrect 13" severity failure;
    
    --test sr
    sel    <= "1001";
    input1 <= conv_std_logic_vector(42, input1'length); --10101010
    input2 <= conv_std_logic_vector(1, input2'length); --01010101
    wait for 40 ns;
    assert(output = conv_std_logic_vector(21, output'length)) report "Error :  lrl 42= " & integer'image(conv_integer(output)) & " instead of 21" severity failure;
    assert(overflow = '0') report "Error                                      : overflow incorrect 14" severity failure;
	
    --test swap
    sel <= "1010";
	input1 <= conv_std_logic_vector(165, input1'length);
	input2 <= conv_std_logic_vector(0, input2'length);
	wait for 40 ns;
	assert(output = conv_std_logic_vector(90, output'length)) report "Error : swap of 165 = " & integer'image(conv_integer(output)) & " instead of 90" severity failure;
	assert(overflow = '0') report "Error                                      : overflow incorrect 15" severity failure;	
	
    --test reverse
	sel <= "1011";
	input1 <= conv_std_logic_vector(148, input1'length);
	input2 <= conv_std_logic_vector(0, input2'length);
	wait for 40 ns;
	assert(output = conv_std_logic_vector(41, output'length)) report "Error : reverse of 148 = " & integer'image(conv_integer(output)) & "instead of 41" severity failure;
	assert(overflow = '0') report "Error                                      : overflow incorrect 16" severity failure;

	
	report "SIMULATION COMPLETE";
    wait;

  end process;



end TB;
