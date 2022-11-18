entity signExtend is
    port(
        i: in bit_vector(31 downto 0);
        o: out bit_vector(63 downto 0)
    );
end signExtend;

architecture arch of signExtend is
    signal ldur_addr: bit_vector(8 downto 0);
    signal ldur_left: bit_vector(54 downto 0);
    
    signal cbz_addr: bit_vector(18 downto 0);
    signal cbz_left: bit_vector(44 downto 0);
    
    signal b_addr: bit_vector(25 downto 0);
    signal b_left: bit_vector(37 downto 0);
    
    signal stur_addr: bit_vector(8 downto 0);
    signal stur_left: bit_vector(54 downto 0);
begin
    ldur_addr <= i(20 downto 12);
    ldur_left <= (others => i(20));

    stur_addr <= i(20 downto 12);
    stur_left <= (others => i(20));

    b_addr <= i(25 downto 0);
    b_left <= (others => i(25));

    cbz_addr <= i(23 downto 5);
    cbz_left <= (others => i(23));

    o <=    cbz_left & cbz_addr when i(31 downto 24) = "10110100" else
            b_left & b_addr when i(31 downto 26) = "000101" else
            ldur_left & ldur_addr when i(31 downto 21) = "11111000010" else
            stur_left & stur_addr when i(31 downto 21) = "11111000000" else
            (others => '0');
end arch;
