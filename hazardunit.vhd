library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity hazardunit is
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
end entity;

architecture arch of hazardunit is
  signal lwStall: std_logic;
  signal Rs1DEqRdE, Rs2DEqRdE: std_logic;
begin
  ForwardAE <=  "10" when (Rs1E=RdM and RegWriteM='1') and Rs1E /= "00000" else
                "01" when (Rs1E=RdW and RegWriteW='1') and Rs1E /= "00000" else
                "00";

  ForwardBE <=  "10" when (Rs2E=RdM and RegWriteM='1') and Rs2E /= "00000" else
                "01" when (Rs2E=RdW and RegWriteW='1') and Rs2E /= "00000" else
                "00";

  Rs1DEqRdE <=  '1' when Rs1D = RdE else
                '0';
  Rs2DEqRdE <=  '1' when Rs2D = RdE else
                '0'; 
  lwStall <= ResultSrc0E and (Rs1DEqRdE or Rs2DEqRdE);
  StallF <= lwStall;
  StallD <= lwStall;
  
  FlushD <= PCSrcE;
  FlushE <= lwStall or PCSrcE;

end arch;