entity controlunit is
    port(
        reg2loc: out bit;
        uncondBranch: out bit;
        branch: out bit;
        memRead: out bit;
        memToReg: out bit;
        aluOp: out bit_vector(1 downto 0);
        memWrite: out bit;
        aluSrc: out bit;
        regWrite: out bit;
        opcode: in bit_vector(10 downto 0)
    );
end entity;

architecture arch of controlunit is
    signal soutput: bit_vector(9 downto 0);
begin
    reg2loc <= soutput(9);
    uncondBranch <= soutput(8);
    branch <= soutput(7);
    memRead <= soutput(6);
    memToReg <= soutput(5);
    aluOp <= soutput(4 downto 3);
    memWrite <= soutput(2);
    aluSrc <= soutput(1);
    regWrite <= soutput(0);

    soutput<=   "0001100011" when opcode = "11111000010" else--ldur
                "1000000110" when opcode = "11111000000" else--stur
                "1010101000" when opcode(10 downto 3) = "10110100" else--cbz
                "0100000000" when opcode(10 downto 5) = "000101" else--b
                "0000010001" when opcode = "10001011000" or opcode = "11001011000" or opcode = "10001010000" or opcode = "10101010000" else--r
                "0000000000";
end arch;
