library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity regfd is
  port(
    clk, reset, en, clr: in STD_LOGIC;

    instrF      : in STD_LOGIC_VECTOR(31 downto 0);
    instrD      : out STD_LOGIC_VECTOR(31 downto 0);
    
    PCF         : in STD_LOGIC_VECTOR(31 downto 0);
    PCD         : out STD_LOGIC_VECTOR(31 downto 0);

    PCPlus4F     : in STD_LOGIC_VECTOR(31 downto 0);
    PCPlus4D     : out STD_LOGIC_VECTOR(31 downto 0)
  );
end;

architecture asynchronous of regfd is
begin
  process(clk, reset, en, clr) 
  begin
    if reset = '1' then
        instrD <= (others => '0');
        PCD <= (others => '0');
        PCPlus4D <= (others => '0');
      
    elsif rising_edge(clk) then
        if clr = '1' then
            instrD <= (others => '0');
            PCD <= (others => '0');
            PCPlus4D <= (others => '0');
        elsif en = '1' then
            instrD <= instrF;
            PCD <= PCF;
            PCPlus4D <= PCPlus4F;
        end if;
    end if;
  end process;
end;