library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity riscvsingle is
  port(
    clk, reset:  in STD_LOGIC;
    PC: out STD_LOGIC_VECTOR(31 downto 0);
    Instr: in STD_LOGIC_VECTOR(31 downto 0);
    MemWrite: buffer STD_LOGIC;
    ALUResult, WriteData: out STD_LOGIC_VECTOR(31 downto 0);
    ReadData: in STD_LOGIC_VECTOR(31 downto 0)
  );
end entity;

architecture struct of riscvsingle is
  component controller is
    port(
      op:in STD_LOGIC_VECTOR(6 downto 0);
      funct3: in STD_LOGIC_VECTOR(2 downto 0);
      funct7b5: in STD_LOGIC;
      RegWriteD: out STD_LOGIC;
      ResultSrcD: out STD_LOGIC_VECTOR(1 downto 0);
      MemWriteD: out STD_LOGIC; 
      JumpD: out STD_LOGIC;
      BranchD: out std_logic;
      ALUControlD:out STD_LOGIC_VECTOR(2 downto 0);
      ALUSrcD: out STD_LOGIC;    
      ImmSrcD: out STD_LOGIC_VECTOR(1 downto 0)
    );
  end component;
  component datapath
    port( 
      clk, reset  :  in STD_LOGIC;
      Instr       :  in STD_LOGIC_VECTOR(31 downto 0);
      ReadDataM   :  in STD_LOGIC_VECTOR(31 downto 0);
      RegWriteD   :  in STD_LOGIC;
      ResultSrcD  :  in STD_LOGIC_VECTOR(1 downto 0);
      MemWriteD   :  in STD_LOGIC;
      ALUSrcD     :  in STD_LOGIC;
      JumpD       :  in STD_LOGIC;
      BranchD     :  in STD_LOGIC;
      ALUControlD :  in STD_LOGIC_VECTOR(2 downto 0);
      ImmSrcD     :  in STD_LOGIC_VECTOR(1 downto 0);

      ALUResultM  : buffer STD_LOGIC_VECTOR(31 downto 0); 
      WriteDataM  : out STD_LOGIC_VECTOR(31 downto 0);
      MemWriteM   : buffer STD_LOGIC;
      InstrD      : buffer STD_LOGIC_VECTOR(31 downto 0);
      PC          : buffer STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;
  signal RegWriteD, MemWriteD, ALUSrcD, JumpD, BranchD: STD_LOGIC;
  signal ResultSrcD, ImmSrcD: STD_LOGIC_VECTOR(1 downto 0);
  signal ALUControlD: STD_LOGIC_VECTOR(2 downto 0);
  signal InstrD: STD_LOGIC_VECTOR(31 downto 0);
begin
  c: controller port map(
    InstrD(6 downto 0), InstrD(14 downto 12),
    InstrD(30), RegWriteD, ResultSrcD, MemWriteD,
    JumpD, BranchD, ALUControlD, ALUSrcD, ImmSrcD
  );
  dp: datapath port map(
    clk, reset, Instr, ReadData, 
    RegWriteD, ResultSrcD, MemWriteD, 
    ALUSrcD, JumpD, BranchD, ALUControlD, 
    ImmSrcD, ALUResult, WriteData,
    MemWrite, InstrD, PC
  );
end;