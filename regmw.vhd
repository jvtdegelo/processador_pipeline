library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity regmw is
  port(
    clk, reset: in STD_LOGIC;

    RegWriteM       : in std_logic;
    RegWriteW       : out std_logic;

    ResultSrcM      : in std_logic_vector(1 downto 0);
    ResultSrcW      : out std_logic_vector(1 downto 0);
    
    ALUResultM      : in STD_LOGIC_VECTOR(31 downto 0);
    ALUResultW      : out STD_LOGIC_VECTOR(31 downto 0);

    ReadDataM       : in STD_LOGIC_VECTOR(31 downto 0);
    ReadDataW       : out STD_LOGIC_VECTOR(31 downto 0);
    
    RdM             : in STD_LOGIC_VECTOR(4 downto 0);
    RdW             : out STD_LOGIC_VECTOR(4 downto 0);
    
    PCPlus4M     : in STD_LOGIC_VECTOR(31 downto 0);
    PCPlus4W     : out STD_LOGIC_VECTOR(31 downto 0)
  );
end;

architecture asynchronous of regmw is
begin
  process(clk, reset) 
  begin
    if reset = '1' then
        RegWriteW <= '0';
        ResultSrcW<= (others => '0');
        ALUResultW <= (others => '0');
        ReadDataW <= (others => '0');
        RdW <= (others => '0');
        PCPlus4W <= (others => '0');
    
    elsif rising_edge(clk) then
      RegWriteW <= RegWriteM;
      ResultSrcW<= ResultSrcM;
      ALUResultW <= ALUResultM;
      ReadDataW <= ReadDataM;
      RdW <= RdM;
      PCPlus4W <= PCPlus4M;
    end if;
  end process;
end;