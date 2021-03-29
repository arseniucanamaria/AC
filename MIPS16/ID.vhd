
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ID is
  Port(clk: in std_logic;
       RegWrite: in std_logic;
       RegDst: in std_logic;
       ExtOp: in std_logic;
       buton:in std_logic;
       WD: in std_logic_vector(15 downto 0);
       Instr: in std_logic_vector(15 downto 0);
       RD1: out std_logic_vector(15 downto 0);
       RD2: out std_logic_vector(15 downto 0);
       Ext_Imm: out std_logic_vector(15 downto 0);
       func: out std_logic_vector(2 downto 0);
       sa: out std_logic
   );
end ID;

architecture Behavioral of ID is

component register_file is
  Port (clk:in std_logic;
        ra1:in std_logic_vector(2 downto 0);
        ra2:in std_logic_vector(2 downto 0);
        wa:in std_logic_vector(2 downto 0);
        wd:in std_logic_vector(15 downto 0);
        regwr:in std_logic;
        enable:in std_logic;
        rd1:out std_logic_vector(15 downto 0);
        rd2:out std_logic_vector(15 downto 0)
   );
end component;

signal outmux: std_logic_vector(2 downto 0):="000";

begin
rg_file: register_file port map(clk=>clk,ra1=>Instr(12 downto 10), ra2=>Instr(9 downto 7),wa=>outmux,wd=>WD,regwr=>RegWrite,enable=>buton,rd1=>RD1,rd2=>RD2);

outmux <= Instr(9 downto 7) when RegDst = '0' else Instr(6 downto 4);
Ext_Imm <= "000000000" & Instr(6 downto 0) when ExtOp = '0' or Instr(6) = '0' else "111111111" & Instr(6 downto 0);

func <= Instr(2 downto 0);
sa <= Instr(3);

end Behavioral;
