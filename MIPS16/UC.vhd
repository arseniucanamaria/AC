library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity UC is
  Port (instr: in std_logic_vector(2 downto 0);
        RegDst: out std_logic;  
        ExtOp: out std_logic; 
        ALUSrc: out std_logic; 
        Branch: out std_logic; 
        Jump: out std_logic;
        AluOp: out std_logic_vector(2 downto 0);
        MemWrite: out std_logic; 
        MemtoReg: out std_logic; 
        RegWrite: out std_logic          
  );
end UC;

architecture Behavioral of UC is
begin

process(instr)
  begin
     RegDst<='0';
     ExtOp<='0';
     ALUSrc<='0';
     Branch<='0';
     Jump<='0';
     ALUOp<="000";
     MemWrite<='0';
     MemtoReg<='0';
     RegWrite<='0';
 
   case(instr) is
      when "000"=> --instructiune de tip R (add,sub,sll,srl,and,or,xor,slt)
         RegDst<='1';
         RegWrite<='1';
         AluOp<="000";
      
      when "001"=>  --instructiune de tip I (addi)
	     RegWrite<='1';
	     AluSrc<='1';
         ExtOp<='1';
         AluOp<="001";
      
      when "010"=>  --instructiune de tip I (lw) 
         RegWrite<='1';
	     AluSrc<='1';
	     ExtOp<='1';
	     MemtoReg<='1';
	     AluOp<="010";
          
      when "011"=> --instructiune de tip I (sw)
	     AluSrc<='1';
	     ExtOp<='1';
	     MemWrite<='1';
         AluOp<="011";
      
      when "100"=> --instructiune de tip I (beq)
	     ExtOp<='1';
	     Branch<='1';
         AluOp<="100";
      
       when "101"=>  --instructiune de tip I (andi)
	     RegWrite<='1';
	     AluSrc<='1';
         AluOp<="101";
      
      when "110"=>  --instructiune de tip I (ori)
	     RegWrite<='1';
	     AluSrc<='1';
         AluOp<="110";
      
      when others =>   --instructiune de tip J (jump)
	     Jump<='1';
         AluOp<="111"; 
        
	end case;
end process;

end Behavioral;
