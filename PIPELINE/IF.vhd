library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IFetch is
 Port (clk: in std_logic;
       jumpAddress: in std_logic_vector(15 downto 0);
       branchAddress: in std_logic_vector(15 downto 0);
       jump: in std_logic;
       PCSrc: in std_logic;
       enable: in std_logic;
       reset: in std_logic;
       instruction: out std_logic_vector(15 downto 0);
       nextPC: inout std_logic_vector(15 downto 0));   
end IFetch;

architecture Behavioral of IFetch is

signal outmux1, outmux2, pc: std_logic_vector(15 downto 0):=x"0000";
type mem is array (0 to 61) of std_logic_vector(15 downto 0);
signal adrese:mem:=(x"2081",--B"001_000_001_0000001" / addi $1,$0,1
                    x"C10A",--B"110_000_010_0001010" / ori $2,$0,10
                    x"2280",--B"001_000_101_0000000" / addi $5,$0,0
                    x"C200",--B"110_000_100_0000000" / ori $4,$0,0
                    x"A781",--B"101_001_111_0000001" / andi $7,$1,1
                    x"0002", --NoOp
                    x"0002", --NoOp
                    x"9C07",--B"100_111_000_0000111" / beq $7,$0,7
                    x"0002", --NoOp
                    x"0002", --NoOp
                    x"0002", --NoOp
                    x"27FF",--B"001_001_111_1111111" / addi $7,$1,-1
                    x"0002", --NoOp    
                    x"E013",--B"111_0000000010011" / j 19
                    x"7780",--B"011_101_111_0000000" / sw $7,0($5)
                    x"046A",--B"000_001_000_110_1_010" / sll $6,$1,1
                    x"0002", --NoOp
                    x"0002", --NoOp
                    x"7700",--B"011_101_110_0000000" / sw $6,0($5)
                    x"5580",--B"010_101_011_0000000" / lw $3,0($5)
                    x"0002", --NoOp
                    x"0002", --NoOp
                    x"11C0",--B"000_100_011_100_0_000" / add $4,$4,$3
                    x"2481",--B"001_001_001_0000001" / addi $1,$1,1
                    x"0002", --NoOp
                    x"3681",--B"001_101_101_0000001" / addi $5,$5,1
                    x"8505",--B"100_001_010_0000101" / beq $1,$2,5
                    x"0002", --NoOp
                    x"0002", --NoOp
                    x"0002", --NoOp
                    x"E004",--B"111_0000000000100" / j 4
                    x"0002", --NoOp
                   others=> x"7600" --B"011_101_100_0000000" sw $4,0($5)
                    );

    begin

process(clk, reset)
begin
  if rising_edge(clk) then
    if enable = '1' then
       pc<=outmux2;
    end if;
  end if; 
    if reset = '1' then
      pc<= x"0000";
   end if;     
 end process;  

instruction<=adrese(conv_integer(pc(5 downto 0)));
nextPC<=pc+1;

outmux1 <= nextPC  when PCSrc = '0' else branchAddress;
outmux2 <= outmux1 when jump = '0' else jumpAddress; 

end Behavioral;
