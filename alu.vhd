library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.ALL;

entity alu is 
    port(
      a, b: in STD_LOGIC_VECTOR(31 downto 0);
      ALUControl: in STD_LOGIC_VECTOR(2 downto 0);
      ALUResult: buffer STD_LOGIC_VECTOR(31 downto 0);
      Zero: out STD_LOGIC
    );
end;

architecture arch of alu is
    signal a_int, b_int, c_int, sum_int, sub_int, result_int: integer;
    signal ans_sum, ans_sub, ans_and, ans_or, ans_slt: STD_LOGIC_VECTOR(31 downto 0);
begin
    a_int <= to_integer(signed(a));
    b_int <= to_integer(signed(b));
    sum_int <= a_int+b_int;
    sub_int <= a_int-b_int;

    ans_sum <= std_logic_vector(to_signed(sum_int, 32));
    ans_sub <= std_logic_vector(to_signed(sub_int, 32));
    ans_and <= a and b;
    ans_or  <= a or b;
    ans_slt <=  std_logic_vector(to_unsigned(1, 32)) when a_int<b_int else
                std_logic_vector(to_unsigned(0, 32)); 

    ALUResult <=    ans_sum when ALUControl="000" else
                    ans_sub when ALUControl="001" else
                    ans_or  when ALUControl="011" else
                    ans_and when ALUControl="010" else
                    ans_slt when ALUControl="101" else
                    (others=> '0'); 

    result_int <= to_integer(signed(ALUResult));
    Zero <= '1' when result_int = 0 else
            '0';
end arch ; 