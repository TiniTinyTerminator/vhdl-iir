library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity iir_filter is
    generic (
        N      : integer := 16;  -- Bit width of the input/output signals
        A1_INIT     : real := -0.5;
        A2_INIT     : real := 0.25;
        B0_INIT     : real := 0.25;
        B1_INIT     : real := 0.5;
        B2_INIT     : real := 0.25
    );
    Port (
        clk        : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        input_sig  : in  signed(N-1 downto 0);
        output_sig : out signed(N-1 downto 0);
        a1         : in  signed(N-1 downto 0) := to_signed(integer(A1_INIT * (2.0**(N-1))), N);
        a2         : in  signed(N-1 downto 0) := to_signed(integer(A2_INIT * (2.0**(N-1))), N);
        b0         : in  signed(N-1 downto 0) := to_signed(integer(B0_INIT * (2.0**(N-1))), N);
        b1         : in  signed(N-1 downto 0) := to_signed(integer(B1_INIT * (2.0**(N-1))), N);
        b2         : in  signed(N-1 downto 0) := to_signed(integer(B2_INIT * (2.0**(N-1))), N)
    );
end iir_filter;

architecture Behavioral of iir_filter is
    -- Convert real coefficients to fixed-point representation

    signal a1_internal : signed(N-1 downto 0) := to_signed(integer(A1_INIT * (2.0**(N-1))), N);
    signal a2_internal : signed(N-1 downto 0) := to_signed(integer(A2_INIT * (2.0**(N-1))), N);
    signal b0_internal : signed(N-1 downto 0) := to_signed(integer(B0_INIT * (2.0**(N-1))), N);
    signal b1_internal : signed(N-1 downto 0) := to_signed(integer(B1_INIT * (2.0**(N-1))), N);
    signal b2_internal : signed(N-1 downto 0) := to_signed(integer(B2_INIT * (2.0**(N-1))), N);

    -- Filter states
    signal x1, x2 : signed(N-1 downto 0) := (others => '0');
    signal y1, y2 : signed(N-1 downto 0) := (others => '0');
    signal acc    : signed(2*N-1 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            a1_internal <= a1;
            a2_internal <= a2;
            b0_internal <= b0;
            b1_internal <= b1;
            b2_internal <= b2;

            x1 <= (others => '0');
            x2 <= (others => '0');
            y1 <= (others => '0');
            y2 <= (others => '0');
            output_sig <= (others => '0');
            acc <= (others => '0');
        elsif rising_edge(clk) then

            -- Compute the accumulator
            acc <= (b0_internal * input_sig) + (b1_internal * x1) + (b2_internal * x2) - (a1_internal * y1) - (a2_internal * y2);

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
