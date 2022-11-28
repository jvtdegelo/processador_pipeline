library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity regde is
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
end;

architecture asynchronous of regde is
begin
  process(clk, reset, clr) 
  begin
    if reset = '1' then
        RegWriteE <= '0';
        ResultSrcE <= (others => '0');
        MemWriteE <= '0';
        JumpE <= '0';
        BranchE <= '0';
        ALUControlE <= (others => '0');
        ALUSrcE <= '0';
        RD1E <= (others => '0');
        RD2E <= (others => '0');
        PCE <= (others => '0');
        Rs1E <= (others => '0');
        Rs2E <= (others => '0');
        RdE <= (others => '0');
        ImmExtE <= (others => '0');
        PCPlus4E <= (others => '0');
    
    elsif rising_edge(clk) then
        if clr = '1' then
            RegWriteE <= '0';
            ResultSrcE <= (others => '0');
            MemWriteE <= '0';
            JumpE <= '0';
            BranchE <= '0';
            ALUControlE <= (others => '0');
            ALUSrcE <= '0';
            RD1E <= (others => '0');
            RD2E <= (others => '0');
            PCE <= (others => '0');
            Rs1E <= (others => '0');
            Rs2E <= (others => '0');
            RdE <= (others => '0');
            ImmExtE <= (others => '0');
            PCPlus4E <= (others => '0');
        else 
            RegWriteE <= RegWriteD;
            ResultSrcE <= ResultSrcD;
            MemWriteE <= MemWriteD;
            JumpE <= JumpD;
            BranchE <= BranchD;
            ALUControlE <= ALUControlD;
            ALUSrcE <= ALUSrcD;
            RD1E <= RD1D;
            RD2E <= RD2D;
            PCE <= PCD;
            Rs1E <= Rs1D;
            Rs2E <= Rs2D;
            RdE <= RdD;
            ImmExtE <= ImmExtD;
            PCPlus4E <= PCPlus4D;
        end if;
    end if;
  end process;
end;