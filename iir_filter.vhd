library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity iir_filter is
    generic (
        N      : integer := 16;  -- Bit width of the input/output signals
        A1     : real := -0.5;
        A2     : real := 0.25;
        B0     : real := 0.25;
        B1     : real := 0.5;
        B2     : real := 0.25
    );
    Port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        input_sig : in  signed(N-1 downto 0);
        output_sig: out signed(N-1 downto 0)
    );
end iir_filter;

architecture Behavioral of iir_filter is
    -- Convert real coefficients to fixed-point representation
    constant A1_fixed : signed(N-1 downto 0) := to_signed(integer(A1 * (2.0**(N-1))), N);
    constant A2_fixed : signed(N-1 downto 0) := to_signed(integer(A2 * (2.0**(N-1))), N);
    constant B0_fixed : signed(N-1 downto 0) := to_signed(integer(B0 * (2.0**(N-1))), N);
    constant B1_fixed : signed(N-1 downto 0) := to_signed(integer(B1 * (2.0**(N-1))), N);
    constant B2_fixed : signed(N-1 downto 0) := to_signed(integer(B2 * (2.0**(N-1))), N);

    -- Filter states
    signal x1, x2 : signed(N-1 downto 0) := (others => '0');
    signal y1, y2 : signed(N-1 downto 0) := (others => '0');
    signal acc    : signed(2*N-1 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            x1 <= (others => '0');
            x2 <= (others => '0');
            y1 <= (others => '0');
            y2 <= (others => '0');
            output_sig <= (others => '0');
            acc <= (others => '0');
            
        elsif rising_edge(clk) then
            -- Compute the accumulator
            acc <= (B0_fixed * input_sig) + (B1_fixed * x1) + (B2_fixed * x2) - (A1_fixed * y1) - (A2_fixed * y2);

            -- Shift the input and output samples
            x2 <= x1;
            x1 <= input_sig;
            y2 <= y1;
            y1 <= shift_right(acc, N-1)(N-1 downto 0);

            -- Update the output
            output_sig <= y1;
        end if;
    end process;
end Behavioral;
