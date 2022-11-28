library IEEE;
use IEEE.STD_LOGIC_1164.all;
library std;
use STD.TEXTIO.all;
use IEEE.numeric_std.all;
use ieee.std_logic_textio.all;

entity imem is
  port(
    a: in STD_LOGIC_VECTOR(31 downto 0);
    rd: out STD_LOGIC_VECTOR(31 downto 0)
  );
end;

architecture behave of imem is
  type ramtype is array(22 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
  -- initialize memory from file
  
  -- a memória abaixo está invertida, com a primeira instrução sendo o último item
  signal mem : ramtype := (
    x"00000000",
    x"00000000",
    x"00210063",
    x"0221A023",
    x"00910133",
    x"00100113",
    x"008001EF",
    x"005104B3",
    x"06002103",
    x"0471AA23",
    x"402383B3",
    x"005203B3",
    x"0023A233",
    x"00000293",
    x"00020463",
    x"0041A233",
    x"02728863",
    x"004282B3",
    x"0041F2B3",
    x"0023E233",
    x"FF718393",
    x"00C00193",
    x"00500113"
  );

begin
  -- read memory
  process(a, mem) 
  begin
    rd <= mem(to_integer(unsigned(a(31 downto 2))));
  end process;
end;