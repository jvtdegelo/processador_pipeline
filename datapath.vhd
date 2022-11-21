library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity datapath is
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
end;

architecture struct of datapath is
  component flopenr is
    generic(
      width: integer
    );
    port(
      clk, reset, en: in STD_LOGIC;
      d: in STD_LOGIC_VECTOR(width-1 downto 0);
      q: out STD_LOGIC_VECTOR(width-1 downto 0)
    );
  end component; 
  
  component hazardunit is
    port(
      Rs1D        : in std_logic_vector(4 downto 0);
      Rs2D        : in std_logic_vector(4 downto 0);
      RdE         : in std_logic_vector(4 downto 0);
      Rs1E        : in std_logic_vector(4 downto 0);
      Rs2E        : in std_logic_vector(4 downto 0);
      PCSrcE      : in std_logic;
      ResultSrc0E : in std_logic;
      RdM         : in std_logic_vector(4 downto 0);
      RegWriteM   : in std_logic;
      RdW         : in std_logic_vector(4 downto 0);
      RegWriteW   : in std_logic;

      StallF      : out std_logic;
      StallD      : out std_logic;
      FlushD      : out std_logic;
      FlushE      : out std_logic;
      ForwardAE   : out std_logic_vector(1 downto 0);
      ForwardBE   : out std_logic_vector(1 downto 0)
    );
  end component;

  component regfd is
    port(
      clk, reset, en, clr: in STD_LOGIC;
  
      instrF      : in STD_LOGIC_VECTOR(31 downto 0);
      instrD      : out STD_LOGIC_VECTOR(31 downto 0);
      
      PCF         : in STD_LOGIC_VECTOR(31 downto 0);
      PCD         : out STD_LOGIC_VECTOR(31 downto 0);
  
      PCPlus4F     : in STD_LOGIC_VECTOR(31 downto 0);
      PCPlus4D     : out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;

  component regde is
    port(
      clk, reset, clr: in STD_LOGIC;
  
      RegWriteD       : in std_logic;
      RegWriteE       : out std_logic;
  
      ResultSrcD      : in std_logic_vector(1 downto 0);
      ResultSrcE      : out std_logic_vector(1 downto 0);
      
      MemWriteD       : in std_logic;
      MemWriteE       : out std_logic;
  
      JumpD           : in std_logic;
      JumpE           : out std_logic;
  
      BranchD         : in std_logic;
      BranchE         : out std_logic;
  
      ALUControlD     : in std_logic_vector(2 downto 0);
      ALUControlE     : out std_logic_vector(2 downto 0);
  
      ALUSrcD         : in std_logic;
      ALUSrcE         : out std_logic;
  
      RD1D            : in STD_LOGIC_VECTOR(31 downto 0);
      RD1E            : out STD_LOGIC_VECTOR(31 downto 0);
      
      RD2D            : in STD_LOGIC_VECTOR(31 downto 0);
      RD2E            : out STD_LOGIC_VECTOR(31 downto 0);
      
      PCD             : in STD_LOGIC_VECTOR(31 downto 0);
      PCE             : out STD_LOGIC_VECTOR(31 downto 0);
  
      Rs1D            : in STD_LOGIC_VECTOR(4 downto 0);
      Rs1E            : out STD_LOGIC_VECTOR(4 downto 0);
      
      Rs2D            : in STD_LOGIC_VECTOR(4 downto 0);
      Rs2E            : out STD_LOGIC_VECTOR(4 downto 0);
      
      RdD             : in STD_LOGIC_VECTOR(4 downto 0);
      RdE             : out STD_LOGIC_VECTOR(4 downto 0);
  
      ImmExtD         : in STD_LOGIC_VECTOR(31 downto 0);
      ImmExtE         : out STD_LOGIC_VECTOR(31 downto 0);
      
      PCPlus4D     : in STD_LOGIC_VECTOR(31 downto 0);
      PCPlus4E     : out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;

  component regem is
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
  end component;

  component regmw is
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
  end component;

  component flopr 
    generic(
      width: integer
    );
    port(
      clk, reset: in STD_LOGIC;
      d: in STD_LOGIC_VECTOR(width-1 downto 0);
      q: out STD_LOGIC_VECTOR(width-1 downto 0)
    );
  end component;
  component adder
    port(
      a, b: in STD_LOGIC_VECTOR(31 downto 0);
      y: out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;
  component mux2 
    generic(
      width: integer
    );
    port(
      d0, d1: in STD_LOGIC_VECTOR(width-1 downto 0);
      s: in STD_LOGIC;
      y: out STD_LOGIC_VECTOR(width-1 downto 0)
    );
  end component;
  component mux3 
    generic(
      width: integer
    );
    port(
      d0, d1, d2: in STD_LOGIC_VECTOR(width-1 downto 0);
      s: in STD_LOGIC_VECTOR(1 downto 0);
      y: out STD_LOGIC_VECTOR(width-1 downto 0)
    );
  end component;
  component regfile
    port(
      clk: in STD_LOGIC;
      we3: in STD_LOGIC;
      a1, a2, a3: in STD_LOGIC_VECTOR(4 downto 0);
      wd3: in STD_LOGIC_VECTOR(31 downto 0);
      rd1, rd2: out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;
  component extend
    port(
      instr: in STD_LOGIC_VECTOR(31 downto 7);
      immsrc: in STD_LOGIC_VECTOR(1 downto 0);
      immext: out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;
  component alu
    port(
      a, b: in STD_LOGIC_VECTOR(31 downto 0);
      ALUControl: in STD_LOGIC_VECTOR(2 downto 0);
      ALUResult: buffer STD_LOGIC_VECTOR(31 downto 0);
      Zero: out STD_LOGIC
    );
  end component;

  signal StallF : std_logic;
  signal PCNext, PCPlus4: STD_LOGIC_VECTOR(31 downto 0);
  
  signal PCD, PCPlus4D: STD_LOGIC_VECTOR(31 downto 0);
  signal Rs1D, Rs2D, RdD: STD_LOGIC_VECTOR(4 downto 0);
  signal ImmExtD: STD_LOGIC_VECTOR(31 downto 0);
  signal RD1D         : STD_LOGIC_VECTOR(31 downto 0);
  signal RD2D         : STD_LOGIC_VECTOR(31 downto 0);
  signal StallD, FlushD: std_logic;

  signal RegWriteE    : std_logic;
  signal ResultSrcE   : std_logic_vector(1 downto 0);
  signal MemWriteE    : std_logic;
  signal JumpE        : std_logic;
  signal BranchE      : std_logic;
  signal ALUControlE  : std_logic_vector(2 downto 0);
  signal ALUSrcE      : std_logic;
  signal RD1E         : STD_LOGIC_VECTOR(31 downto 0);
  signal RD2E         : STD_LOGIC_VECTOR(31 downto 0);
  signal PCE          : STD_LOGIC_VECTOR(31 downto 0);
  signal Rs1E         : STD_LOGIC_VECTOR(4 downto 0);
  signal Rs2E         : STD_LOGIC_VECTOR(4 downto 0);
  signal RdE          : STD_LOGIC_VECTOR(4 downto 0);
  signal ImmExtE      : STD_LOGIC_VECTOR(31 downto 0);
  signal PCPlus4E     : STD_LOGIC_VECTOR(31 downto 0);
  signal PCTargetE    : STD_LOGIC_VECTOR(31 downto 0);
  signal WriteDataE   : STD_LOGIC_VECTOR(31 downto 0);
  signal SrcAE, SrcBE : STD_LOGIC_VECTOR(31 downto 0);
  signal ALUResultE   : STD_LOGIC_VECTOR(31 downto 0);
  signal ZeroE        : STD_LOGIC;
  signal PCSrcE       : STD_LOGIC;
  signal FlushE       : STD_LOGIC;
  signal ForwardAE    : std_logic_vector(1 downto 0);
  signal ForwardBE    : std_logic_vector(1 downto 0);

  signal RegWriteM    : std_logic;
  signal ResultSrcM   : std_logic_vector(1 downto 0);
  -- signal MemWriteM    : std_logic;
  signal RdM          : STD_LOGIC_VECTOR(4 downto 0);
  signal PCPlus4M     : STD_LOGIC_VECTOR(31 downto 0);
  
  signal RegWriteW    : std_logic;
  signal ResultSrcW   : std_logic_vector(1 downto 0);
  signal ALUResultW   : STD_LOGIC_VECTOR(31 downto 0);
  signal ReadDataW    : STD_LOGIC_VECTOR(31 downto 0);
  signal RdW          : STD_LOGIC_VECTOR(4 downto 0);
  signal PCPlus4W     : STD_LOGIC_VECTOR(31 downto 0);
  signal ResultW      : STD_LOGIC_VECTOR(31 downto 0);

  signal notclk, notstallf : std_logic;
begin
  -- start F
  notstallf <= not stallF;
  pcreg: flopenr 
    generic map(
      32
    ) 
    port map(
      clk, reset, notstallf, PCNext, PC
    );
  
  pcadd4: adder port map(
    PC, X"00000004", PCPlus4
  );

  pcmux: mux2 
    generic map(
      32
    ) 
    port map(
      PCPlus4, PCTargetE, PCSrcE, PCNext
    );

  registerFD: regfd
    port map(
      clk, reset, StallD, FlushD, 
      Instr, InstrD,
      PC, PCD,
      PCPlus4, PCPlus4D 
    );

  -- End F

  -- Start D
  notclk <= not clk;
  rf: regfile port map(
    notclk, RegWriteW, InstrD(19 downto 15),
    InstrD(24 downto 20), RdW,
    ResultW, RD1D, RD2D
  );
  
  ext: extend port map(
    InstrD(31 downto 7), ImmSrcD, ImmExtD
  );

  Rs1D <= InstrD(19 downto 15);
  Rs2D <= InstrD(24 downto 20);
  RdD <= InstrD(11 downto 7);

  -- End D
  registerDE: regde port map(
    clk, reset, FlushE,
    RegWriteD, RegWriteE,
    ResultSrcD, ResultSrcE, 
    MemWriteD, MemWriteE,
    JumpD, JumpE,
    BranchD, BranchE,
    ALUControlD, ALUControlE,
    ALUSrcD, ALUSrcE,
    RD1D, RD1E, 
    RD2D, RD2E,
    PCD, PCE,
    Rs1D, Rs1E,
    Rs2D, Rs2E,
    RdD, RdE,
    ImmExtD, ImmExtE,
    PCPlus4D, PCPlus4E
  );

  -- Start E
  -- ALU logic
  srcaemux: mux3 
    generic map(
      32
    )
    port map(
      RD1E, ResultW, ALUResultM,
      ForwardAE,
      SrcAE
    );

  writedatamux: mux3 
    generic map(
      32
    )
    port map(
      RD2E, ResultW, ALUResultM,
      ForwardBE,
      WriteDataE
    );
  
  srcbemux: mux2 
    generic map(
      32
    ) 
    port map(
      WriteDataE, ImmExtE,
      ALUSrcE, SrcBE
    );
  
  pcaddbranch: adder port map(
    PCE, ImmExtE, PCTargetE
  );

  mainalu: alu port map(
    SrcAE, SrcBE, ALUControlE, ALUResultE, ZeroE
  );

  PCSrcE <= JumpE or (ZeroE and BranchE);
  
  -- End E

  RegisterEM: regem port map(
    clk, reset,
    RegWriteE, RegWriteM,
    ResultSrcE, ResultSrcM,
    MemWriteE, MemWriteM,
    ALUResultE, ALUResultM,
    WriteDataE, WriteDataM,
    RdE, RdM, 
    PCPlus4E, PCPlus4M 
  );

  -- Start M
  

  -- End M

  registerMW: regmw port map(
    clk, reset, 
    RegWriteM, RegWriteW, 
    ResultSrcM, ResultSrcW,
    ALUResultM, ALUResultW,
    ReadDataM, ReadDataW,
    RdM, RdW,
    PCPlus4M, PCPlus4W
  );

  -- Start W
  resultmux: mux3 
    generic map(
      32
    ) 
    port map(
      ALUResultW, ReadDataW,
      PCPlus4W, ResultSrcW,
      ResultW
    );

  -- End W

  hazard: hazardunit port map(
    Rs1D, Rs2D, RdE, Rs1E, Rs2E, PCSrcE,
    ResultSrcE(0), RdM, RegWriteM, RdW,
    RegWriteW, StallF, StallD, FlushD, 
    FlushE, ForwardAE, ForwardBE
  );

end struct;