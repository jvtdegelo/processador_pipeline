library ieee;
use ieee.math_real.all;
use ieee.numeric_bit.all;
entity datapath is
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
    ) ;
end entity datapath;

architecture arch of datapath is
    component alu is
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
    end component;

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

    component regfile is
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
    end component;

    component signExtend is
        port(
            i: in bit_vector(31 downto 0);
            o: out bit_vector(63 downto 0)
        );
    end component; 


    signal out_pc_p_add, out_se, out_pc_p4, out_pc, in_pc, s_out_se: bit_vector(63 downto 0);
    signal rr2: bit_vector(4 downto 0);
    signal s1, s2, f_s2, write_data, out_alu: bit_vector(63 downto 0);
begin
    imAddr <= out_pc;
    program_counter: registrador_universal  generic map (64)
                                            port map(clock, reset , '0', '1', "11", '0', in_pc, out_pc);
    
    sum_4_to_pc: alu    generic map(64)
                        port map(out_pc, x"0000000000000004", out_pc_p4, "0010", open, open, open);

    sign_extend: signExtend port map(imOut, out_se);
    
    s_out_se <= out_se(61 downto 0)&"00";
    
    sum_add_to_pc: alu  generic map(64)
                        port map(out_pc, s_out_se, out_pc_p_add, "0010", open, open, open);

    in_pc <=    out_pc_p4 when pcsrc = '0' else
                out_pc_p_add;

    rr2 <=  imOut(20 downto 16) when reg2loc = '0' else
            imOut(4 downto 0); 
    
    reg_file: regfile   generic map(32, 64)
                        port map(clock, reset, regWrite, imOut(9 downto 5), rr2, imOut(4 downto 0), write_data, s1, s2);

    f_s2 <= s2 when aluSrc = '0' else
            out_se;

    alu_reg: alu    generic map(64)
                    port map(s1, f_s2, out_alu, aluCtrl, zero, open, open);

    dmAddr <= out_alu;
    dmIn <= s2;
    write_data <=   out_alu when memToReg = '0' else
                    dmOut;
    opcode <= imOut(31 downto 21);
end arch;
