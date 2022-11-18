entity alu1bit is
    port(
        a, b, less, cin: in bit;
        result, cout, set, overflow: out bit;
        ainvert, binvert: in bit;
        operation: in bit_vector(1 downto 0)
    );
end alu1bit;
architecture arch1 of alu1bit is
    signal a_f, b_f: bit;
    signal r_and, r_or, r_sum: bit;
    signal s_cout, s_ov: bit;
begin
    a_f <= a when ainvert = '0' else not(a);
    b_f <= b when binvert = '0' else not(b);
    r_and <= a_f and b_f;
    r_or  <= a_f or b_f;
    r_sum <= a_f xor b_f xor cin;
    s_cout <= (a_f and b_f) or (a_f and cin) or (b_f and cin);
    cout<= s_cout;
    result <=   r_and when operation = "00" else
                r_or when operation = "01" else
                r_sum when operation = "10" else
                b;
    s_ov <= s_cout xor cin;
    overflow <= s_ov;
    set <=  '1' when s_ov = '1' and a_f = '1' else
            '0' when s_ov = '1' and a_f = '0' else
            r_sum;
end arch1;
