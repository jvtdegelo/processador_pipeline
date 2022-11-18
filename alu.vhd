library ieee;
use ieee.numeric_bit.all;

entity alu is
    generic (
        size: natural := 64
    );
    port (
        A, B: in bit_vector(size-1 downto 0);
        F: out bit_vector(size-1 downto 0);
        S: in bit_vector(3 downto 0);
        Z: out bit;
        Ov: out bit;
        Co: out bit
    );
end entity alu;
architecture arch of alu is
    component alu1bit is
        port(
            a, b, less, cin: in bit;
            result, cout, set, overflow: out bit;
            ainvert, binvert: in bit;
            operation: in bit_vector(1 downto 0)
        );
    end component;

    signal r, s_z: bit_vector(size-1 downto 0);
    signal c: bit_vector(size downto 0);
    signal l:bit;
begin
    c(0) <= s(2);
    ula: alu1bit port map(a(0), b(0), l, c(0), r(0) , c(1), open, open, s(3), s(2), s(1 downto 0));
    ula_1_bit: for i in size-2 downto 1 generate
        ulaaa: alu1bit port map(a(i), b(i), '0', c(i), r(i), c(i+1), open, open, s(3), s(2), s(1 downto 0));
    end generate;
    ulaa: alu1bit port map(a(size-1), b(size-1), '0', c(size-1), r(size-1), c(size), l, ov, s(3), s(2), s(1 downto 0));
    co <= c(size);
    F <= r;
    s_z(0) <= r(0);
    compute_z: for i in size-1 downto 1 generate
        s_z(i)<=s_z(i-1) or r(i);
    end generate;
    z<= not(s_z(size-1));
end arch;
