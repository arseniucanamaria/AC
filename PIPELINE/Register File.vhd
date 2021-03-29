library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity register_file is
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
end register_file;

architecture Behavioral of register_file is
   type reg_array is array(0 to 7) of std_logic_vector(15 downto 0);
   signal reg: reg_array;
   
begin

process(clk)
begin
  if falling_edge(clk) then
     if regwr = '1' then
        if enable = '1' then
            reg(conv_integer(wa))<=wd;
        end if;
      end if;
  end if;       
end process;

rd1<=reg(conv_integer(ra1));
rd2<=reg(conv_integer(ra2));

end Behavioral;
