library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity top is
  port(
    clk, reset: in STD_LOGIC;
    WriteData, DataAdr: buffer STD_LOGIC_VECTOR(31 downto 0);
    MemWrite: buffer STD_LOGIC
  );
end;

architecture test of top is
  component riscvsingle
    port(
      clk, reset: in STD_LOGIC;
      PC: out STD_LOGIC_VECTOR(31 downto 0);
      Instr: in STD_LOGIC_VECTOR(31 downto 0);
      MemWrite: buffer STD_LOGIC;
      ALUResult, WriteData: out STD_LOGIC_VECTOR(31 downto 0);
      ReadData: in STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;
  
  component imem
    port(
      a: in STD_LOGIC_VECTOR(31 downto 0);
      rd: out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;
  
  component dmem
    port(
      clk, we: in STD_LOGIC;
      a, wd: in STD_LOGIC_VECTOR(31 downto 0);
      rd: out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;
 
  signal PC, Instr, ReadData: STD_LOGIC_VECTOR(31 downto 0);
begin
  --instantiate processor and memories
  rvsingle: riscvsingle port map(
    clk, reset, PC, Instr,
    MemWrite, DataAdr,
    WriteData, ReadData
  );
  imem1: imem port map(
    PC, Instr
  );
  dmem1: dmem port map(
    clk, MemWrite, DataAdr, WriteData, ReadData
  );
end;