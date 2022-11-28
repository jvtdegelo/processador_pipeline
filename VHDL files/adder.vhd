library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity adder is
  port(
    a, b: in STD_LOGIC_VECTOR(31 downto 0);
    y: out STD_LOGIC_VECTOR(31 downto 0)
  );
end;

architecture behave of adder is
begin
  y <=  std_logic_vector(unsigned(a) + unsigned(b));
end;