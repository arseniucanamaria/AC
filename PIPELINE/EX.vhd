library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity EX is
  Port (RD1: in std_logic_vector(15 downto 0);
        RD2: in std_logic_vector(15 downto 0);
        ALUSrc: in std_logic;
        Ext_Imm: in std_logic_vector(15 downto 0);
        sa: in std_logic;
        func: in std_logic_vector(2 downto 0);
        nextAddress: in std_logic_vector(15 downto 0);
        branchAddress: out std_logic_vector(15 downto 0);
        ALUOp: in std_logic_vector(2 downto 0);
        Zero: out std_logic;
        ALURes: out std_logic_vector(15 downto 0));
end EX;

architecture Behavioral of EX is

    signal outmux, rez, aux: std_logic_vector(15 downto 0):=x"0000";
    signal ALUCtrl: std_logic_vector(2 downto 0):="000";
    signal auxZero: std_logic:='0';


begin
    outmux <= RD2 when ALUSrc = '0' else Ext_Imm;
    branchAddress <= nextAddress + Ext_Imm;
    
    --ALU operatii
   process(ALUCtrl, func)
    begin
      case ALUCtrl is
        when "000" =>  rez<=RD1 + outmux;  --add
        when "001" =>  if func = "001" then 
                            rez<=RD1 - outmux;  --sub
                       elsif func = "111" then --PT SLT
                            aux<=RD1 - outmux; 
                            if aux(15) = '1' then
                               rez<=x"0001";
                            else
                               rez<=x"0000";
                            end if;
                       end if;          
        when "010" =>  if sa='1' then      --sll
                       rez<=RD1(14 downto 0) & '0'; 
                   else
                      rez<=RD1;  
                    end if;
                      
        when "011" =>  if sa='1' then      --srl
                       rez<='0' & RD1(15 downto 1); 
                   else
                      rez<=RD1;
                    end if;
                    
         when "100" =>  rez<=RD1 and outmux;  --AND
         when "101" =>  rez<=RD1 or outmux;  --OR
         when others =>  rez<=RD1 xor outmux;  --XOR
    
     end case; 
    
        if rez=x"0000" then
           auxZero<='1';
        else
           auxZero<='0';
        end if;
        
      ALURes<=rez;
      Zero<=auxZero;     
    end process;
    
    
    
       --- determinare ALUCtrl din opcode-ul sau function-ul instructiunii
    process(ALUOp, func)
    begin
       case ALUOp is
          when "000" =>  --Instructiune TIP R
               case func is
                  when "000"=> AluCtrl<="000"; --add
                  when "001"=> AluCtrl<="001"; --sub
                  when "010"=> AluCtrl<="010"; --sll
                  when "011"=> AluCtrl<="011"; --srl
                  when "100"=> AluCtrl<="100"; --and
                  when "101"=> AluCtrl<="101"; --or
                  when "110"=> AluCtrl<="110"; --xor
                  when "111"=> AluCtrl<="001"; --slt(sub)
               
                end case;
                
              --Instructiune TIP I  
           when "001" =>  AluCtrl<="000"; --addi   
           when "010" =>  AluCtrl<="000"; --lw
           when "011" =>  AluCtrl<="000"; --sw
           when "100" =>  AluCtrl<="001"; --beq
           when "101" =>  AluCtrl<="100"; --andi
           when "110" =>  AluCtrl<="101"; --ori
           
              --Instructiune TIP J
           when "111" =>  AluCtrl<="000"; --nu conteaza care cod, Jump nu foloseste de ALU
                
        end case;        
    end process;

end Behavioral;
