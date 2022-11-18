library ieee;
use ieee.numeric_bit.rising_edge;

entity registrador_universal is
    generic (
        word_size: positive := 4
    );
    port (
        clock, clear, set, enable: in bit;
        control: in bit_vector(1 downto 0);
        serial_input: in bit;
        parallel_input: in bit_vector(word_size-1 downto 0);
        parallel_output: out bit_vector(word_size-1 downto 0)
    );
end entity;

architecture arch of registrador_universal is
    signal saida, prox_saida: bit_vector(word_size-1 downto 0);
begin
    process(clock, clear, set, enable)
    begin
        if clear = '1' then 
            saida <= (others => '0');
        elsif set = '1' then
            saida <= (others => '1');
        elsif rising_edge(clock) then
            if enable = '1' then
                saida <= prox_saida;
            end if;
        end if;
    end process;
    parallel_output <= saida;
    prox_saida <= 
        saida when control = "00" else
        serial_input & saida (word_size-1 downto 1) when control = "01" else
        saida (word_size-2 downto 0) & serial_input when control = "10" else 
        parallel_input when control = "11" else
        saida;
end arch;
