library ieee;
use ieee.math_real.all;
use ieee.numeric_bit.all;
entity polilegsc is
    port(
        clock, reset: in bit;
        --Data Memory
        dmem_addr: out bit_vector(63 downto 0);
        dmem_dati: out bit_vector(63 downto 0);
        dmem_dato: in bit_vector(63 downto 0);
        dmem_we: out bit;

        --Instruction memory
        imem_addr: out bit_vector(63 downto 0);
        imem_data: in bit_vector(31 downto 0)
    );
end entity;

architecture arch of polilegsc is
    component datapath is
        port(
            --Common
            clock: in bit;
            reset: in bit;
            -- From Control Unit
            reg2loc: in bit;
            pcsrc: in bit;
            memToReg: in bit;
            aluCtrl: in bit_vector(3 downto 0);
            aluSrc: in bit;
            regWrite: in bit;
            -- To Control Unit
            opcode: out bit_vector(10 downto 0);
            zero: out bit;
            --IM interface
            imAddr : out bit_vector(63 downto 0);
            imOut : in bit_vector(31 downto 0);
            --DM interface
            dmAddr : out bit_vector(63 downto 0);
            dmIn : out bit_vector(63 downto 0);
            dmOut : in bit_vector(63 downto 0)
        );
    end component;

    component controlunit is
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
    end component;

    component alucontrol is
        port(
            aluop: in bit_vector(1 downto 0);
            opcode: in bit_vector(10 downto 0);
            aluCtrl: out bit_vector(3 downto 0)
        );
    end component;
    
    signal  zero, reg2loc, pcsrc, memToReg, uncondBranch, branch, memRead, memwrite, alusrc, regwrite: bit;
    signal aluop : bit_vector(1 downto 0);
    signal aluctrl : bit_vector(3 downto 0);
    signal opcode: bit_vector(10 downto 0);
begin
    pcsrc <= (uncondBranch) or (branch and zero);
    datapath_polilegsc: datapath port map(clock, reset, reg2loc, pcsrc, memToReg, aluCtrl, alusrc, regwrite, opcode, zero, imem_addr, imem_data, dmem_addr, dmem_dati, dmem_dato);
    alucontrol_polilegsc: alucontrol port map(aluop, opcode, aluCtrl);
    controlunit_polilegsc: controlunit port map(reg2loc, uncondBranch, branch, memRead, memToReg, aluop, memwrite, alusrc, regwrite, opcode);
    dmem_we <= memWrite;
end arch;