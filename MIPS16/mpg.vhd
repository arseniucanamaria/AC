library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mpg is
 Port ( btn:in std_logic;
        clk:in std_logic;
        en:out std_logic
 );

end mpg;

architecture Behavioral of mpg is 

signal count_int1: std_logic_vector(31 downto 0) :=x"00000000";
signal Q1 : std_logic;
signal Q2 : std_logic;
signal Q3 : std_logic;

begin
en <= Q2 AND (not Q3);

process (clk)
begin
if clk='1' and clk'event then
    count_int1 <= count_int1 + 1;
end if;
end process;

process (clk)
begin
if clk'event and clk='1' then
    if count_int1(15 downto 0) = "1111111111111111" then
            Q1 <= btn;
    end if;
end if;
end process;  

process (clk)
begin
if clk'event and clk='1' then
    Q2 <= Q1;
    Q3 <= Q2;
end if;
end process;

end Behavioral;
