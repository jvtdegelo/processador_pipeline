library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity regem is
  port(
    clk, reset: in STD_LOGIC;

    RegWriteE       : in std_logic;
    RegWriteM       : out std_logic;

    ResultSrcE      : in std_logic_vector(1 downto 0);
    ResultSrcM      : out std_logic_vector(1 downto 0);
    
    MemWriteE       : in std_logic;
    MemWriteM       : out std_logic;

    ALUResultE      : in STD_LOGIC_VECTOR(31 downto 0);
    ALUResultM      : out STD_LOGIC_VECTOR(31 downto 0);
    
    WriteDataE      : in STD_LOGIC_VECTOR(31 downto 0);
    WriteDataM      : out STD_LOGIC_VECTOR(31 downto 0);
    
    RdE             : in STD_LOGIC_VECTOR(4 downto 0);
    RdM             : out STD_LOGIC_VECTOR(4 downto 0);
    
    PCPlus4E     : in STD_LOGIC_VECTOR(31 downto 0);
    PCPlus4M     : out STD_LOGIC_VECTOR(31 downto 0)
  );
end;

architecture asynchronous of regem is
begin
  process(clk, reset) 
  begin
    if reset = '1' then
        RegWriteM <= '0';
        ResultSrcM <= (others => '0');
        MemWriteM <= '0';
        ALUResultM <= (others => '0');
        WriteDataM <= (others => '0');
        RdM <= (others => '0');
        PCPlus4M <= (others => '0');
    
    elsif rising_edge(clk) then
        RegWriteM <= RegWriteE;
        ResultSrcM <= ResultSrcE;
        MemWriteM <= MemWriteE;
        ALUResultM <= ALUResultE;
        WriteDataM <= WriteDataE;
        RdM <= RdE;
        PCPlus4M <= PCPlus4E;
    end if;
  end process;
end;