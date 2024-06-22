import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
import numpy as np
import matplotlib.pyplot as plt

@cocotb.test()
async def test_iir_filter(dut):
    """Test the IIR filter with a series of inputs and visualize the results."""

    # Parameters
    clk_period = 10  # Clock period in ns
    num_samples = 100  # Number of samples to test
    reset_time = 10 * clk_period  # Reset time in ns

    # Create and start the clock
    clock = Clock(dut.clk, clk_period, units="ns")
    cocotb.start_soon(clock.start())

    # Reset the DUT
    dut.reset.value = 1
    await Timer(reset_time, units="ns")
    dut.reset.value = 0

    # Generate a test input signal (e.g., a step function)
    input_signal = np.ones(num_samples, dtype=np.int16) * 1000

    # Apply input signal and capture output
    output_signal = []

    for sample in input_signal:
        # Apply the input sample
        dut.input_sig.value = int(sample)

        # Wait for the rising edge of the clock
        await RisingEdge(dut.clk)

        print(dut.output_sig.value)

        # # Read the output
        output_sample = float(int(dut.output_sig.value))
        output_signal.append(output_sample)

        # Print the input and output for debugging
        print(f"Input: {sample}, Output: {output_sample}")

    # Convert output_signal to numpy array for easy plotting
    output_signal = np.array(output_signal)

    # Plot input and output signals
    plt.figure(figsize=(10, 6))
    plt.plot(input_signal, label="Input Signal")
    plt.plot(output_signal, label="Output Signal", linestyle='--')
    plt.title("IIR Filter Input and Output Signals")
    plt.xlabel("Sample Index")
    plt.ylabel("Amplitude")
    plt.legend()
    plt.grid(True)
    plt.show()

    # Optionally: compare the output_signal with an expected output
    # (Here we are just printing the results)
    for i, (inp, out) in enumerate(zip(input_signal, output_signal)):
        print(f"Sample {i}: Input = {inp}, Output = {out}")
