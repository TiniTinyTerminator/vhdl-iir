library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity tb_iir_filter is
-- Testbench doesn't have any ports
end tb_iir_filter;

architecture Behavioral of tb_iir_filter is

    -- Constants to match the IIR filter generic parameters
    constant N : integer := 16;
    constant CLK_PERIOD : time := 10 ns;

    -- Testbench signals
    signal clk       : STD_LOGIC := '0';
    signal reset     : STD_LOGIC := '0';
    signal input_sig : signed(N-1 downto 0) := (others => '0');
    signal output_sig: signed(N-1 downto 0);

    -- Instantiate the IIR filter component
    component iir_filter
        generic (
            N      : integer := 16;
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
    end component;

begin
    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- DUT instantiation
    uut: iir_filter
        port map (
            clk       => clk,
            reset     => reset,
            input_sig => input_sig,
            output_sig=> output_sig
        );

    -- Test process
    stim_proc: process
    begin
        -- Reset the system
        reset <= '1';
        wait for 2 * CLK_PERIOD;
        reset <= '0';

        -- Test vector 1
        input_sig <= to_signed(100, N);  -- Example input
        wait for 10 * CLK_PERIOD;

        -- Test vector 2
        input_sig <= to_signed(-50, N);  -- Another example input
        wait for 10 * CLK_PERIOD;

        -- Test vector 3
        input_sig <= to_signed(75, N);  -- Another example input
        wait for 10 * CLK_PERIOD;

        -- Hold the final state
        wait;

    end process stim_proc;

end Behavioral;
