library ieee;
use ieee.math_real.all;
use ieee.numeric_bit.all;

entity regfile is
    generic(
        regn: natural := 32;
        wordSize: natural := 64 
    );
    port(
        clock: in bit;
        reset: in bit;
        regWrite: in bit;
        rr1, rr2, wr: in bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);
        d: in bit_vector(wordSize-1 downto 0);
        q1, q2: out bit_vector(wordSize-1 downto 0)
    );
end regfile;

architecture arch of regfile is
    component registrador_universal is
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
    end component;
    type ct is array (regn-1 downto 0) of bit_vector(1 downto 0);
    type mem_type is array (regn-1 downto 0) of bit_vector(wordSize-1 downto 0);
    signal irr1, irr2, iwr : integer := 0; 
    signal control: ct;
    signal banco: mem_type;
begin
    irr1 <= to_integer(unsigned(rr1));
    irr2 <= to_integer(unsigned(rr2));
    iwr <= to_integer(unsigned(wr));
    compute_control: for i in regn-1 downto 0 generate
        control(i) <=   "00" when i = 31 else
                        "11" when regWrite = '1' and iwr = i else
                        "00";
    end generate compute_control;
    generate_banco: for i in regn-1 downto 0 generate
        reg: registrador_universal  generic map(wordSize) 
                                    port map(clock, reset, '0', '1', control(i), '0', d, banco(i));
    end generate generate_banco;
    q1 <= banco(irr1);
    q2 <= banco(irr2);
end arch;
