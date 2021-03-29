library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity test_env is
 Port (clk: in std_logic;
       btn: in std_logic_vector(4 downto 0);
       sw: in std_logic_vector(15 downto 0);
       led: out std_logic_vector(15 downto 0);
       an: out std_logic_vector(3 downto 0);
       cat: out std_logic_vector(6 downto 0));
end test_env;

architecture Behavioral of test_env is

component SSD is
  Port (
  signal digit0: in std_logic_vector(3 downto 0);
  signal digit1: in std_logic_vector(3 downto 0);  
  signal digit2: in std_logic_vector(3 downto 0);
  signal digit3: in std_logic_vector(3 downto 0);
  signal clk:in std_logic;
  signal cat:out std_logic_vector(6 downto 0);
  signal an:out std_logic_vector(3 downto 0)
  
  );
end component;

component mpg is
Port(btn: in std_logic;
     clk:in std_logic;
     en: out std_logic);
end component;

component IFetch is
 Port (clk: in std_logic;
       jumpAddress: in std_logic_vector(15 downto 0);
       branchAddress: in std_logic_vector(15 downto 0);
       jump: in std_logic;
       PCSrc: in std_logic;
       enable: in std_logic;
       reset: in std_logic;
       instruction: out std_logic_vector(15 downto 0);
       nextPC: inout std_logic_vector(15 downto 0));   
end component;

component ID is
  Port(clk: in std_logic;
       RegWrite: in std_logic;
       RegDst: in std_logic;
       ExtOp: in std_logic;
       buton: in std_logic;
       WD: in std_logic_vector(15 downto 0);
       Instr: in std_logic_vector(15 downto 0);
       RD1: out std_logic_vector(15 downto 0);
       RD2: out std_logic_vector(15 downto 0);
       Ext_Imm: out std_logic_vector(15 downto 0);
       func: out std_logic_vector(2 downto 0);
       sa: out std_logic
   );
end component;

component UC is
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
end component;

component MEM is
  Port (clk: in std_logic;
        MemWrite: in std_logic;
        buton: in std_logic;
        ALURes: inout std_logic_vector(5 downto 0);
        RD2: in std_logic_vector(15 downto 0);
        MemData: out std_logic_vector(15 downto 0)
   );
end component;

component EX is
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
end component;

signal enable, reset, Zero, PCSrc: std_logic:='0';
signal digits, nextAd, instr, jumpAd, RD1, RD2, Ext_Imm,ALURes, branchAd,MemData, outmuxMem: std_logic_vector(15 downto 0):=x"0000";
signal ALUSrc,Branch,Jump,MemWrite,MemtoReg,RegWrite,RegDst,ExtOp,sa: std_logic:='0';  
signal AluOp: std_logic_vector(2 downto 0):="000";
signal func: std_logic_vector(2 downto 0):="000";

begin
mpp1:mpg port map(btn=>btn(0),clk=>clk,en=>enable);
mpp2:mpg port map(btn=>btn(1),clk=>clk,en=>reset);
ssd1: SSD port map(digit0=>digits(3 downto 0),digit1=>digits(7 downto 4),digit2=>digits(11 downto 8),digit3=>digits(15 downto 12),clk=>clk,cat=>cat,an=>an);
if1: IFetch port map(clk=>clk,jumpAddress=>jumpAd,branchAddress=>branchAd,jump=>Jump,PCSrc=>PCSrc,enable=>enable,reset=>reset,instruction=>instr,nextPC=>nextAd);
id1: ID port map(clk=>clk,RegWrite=>RegWrite,Instr=>instr,RegDst=>RegDst ,ExtOp=>ExtOp, buton=>enable,WD=>outmuxMem, RD1=>RD1,RD2=>RD2,Ext_Imm=>Ext_Imm,func=>func,sa=>sa);
uc1: UC port map(instr=>instr(15 downto 13),RegDst=>RegDst,ExtOp=>ExtOp,ALUSrc=>ALUSrc,Branch=>Branch,Jump=>Jump,ALUOp=>ALUOp,MemWrite=>MemWrite,MemtoReg=>MemtoReg,RegWrite=>RegWrite );  
ex1: EX port map(RD1=>RD1,RD2=>RD2,ALUSrc=>ALUSrc,Ext_Imm=>Ext_Imm,sa=>sa,func=>func,nextAddress=>nextAd,branchAddress=>branchAd,ALUOp=>ALUOp,Zero=>Zero,ALURes=>ALURes);
mem1: MEM port map(clk=>clk,MemWrite=>MemWrite,buton=>enable,ALURes=>ALURes(5 downto 0),RD2=>RD2,MemData=>MemData);

PCSrc <= Branch and Zero;
outmuxMem <= MemData when MemtoReg='1' else ALURes;
jumpAd <= nextAd(15 downto 13) & instr(12 downto 0);


process(sw(7 downto 5))
begin
    case (sw(7 downto 5)) is
        when "000" =>digits<=instr;
        when "001" =>digits<=NextAd;
        when "010" =>digits<=RD1;
        when "011" =>digits<=RD2;
        when "100" =>digits<=Ext_Imm;
        when "101" =>digits<=ALURes;
        when "110" =>digits<=MemData;
        when others =>digits<=outmuxMem;
    end case;
end process;

  --afisare pe leduri a semnalelor de control
led(7) <= RegDst;
led(6) <= ExtOp;
led(5) <= ALUSrc;
led(4) <= Branch;
led(3) <= Jump;
led(2) <= MemWrite;
led(1) <= MemtoReg;
led(0) <= RegWrite;

led(15 downto 13) <= ALUOp;

end Behavioral;
