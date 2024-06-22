# IIR Filter VHDL Project

This project implements an Infinite Impulse Response (IIR) filter in VHDL and includes a testbench to verify its functionality. The filter is parameterized for different bit-widths and coefficients.

## File Structure

- `iir_filter.vhdl`: VHDL source file for the IIR filter module.
- `tb_iir_filter.vhdl`: VHDL source file for the traditional testbench of the IIR filter.
- `README.md`: This README file.
- `Makefile`: Makefile for running the simulation using Cocotb.
- `test_iir_filter.py`: Python test script for Cocotb.

## Prerequisites

- GHDL: An open-source VHDL simulator.
- GTKWave: A waveform viewer to visualize simulation results.
- Cocotb: A coroutine-based cosimulation library for writing VHDL testbenches in Python.

## Compilation and Simulation Instructions (Traditional Method)

Follow these steps to compile and run the simulation using GHDL:

1. **Save the VHDL files**:
   - Save the IIR filter module into a file named `iir_filter.vhdl`.
   - Save the testbench code into a file named `tb_iir_filter.vhdl`.

2. **Analyze (compile) the VHDL files**:
   Open a terminal and navigate to the directory containing your VHDL files. Then run:

   ```sh
   ghdl -a iir_filter.vhdl
   ghdl -a tb_iir_filter.vhdl
   ```

3. **Elaborate the testbench**:
   Once the analysis is successful, elaborate the testbench entity:

   ```sh
   ghdl -e tb_iir_filter
   ```

4. **Run the simulation**:
   Finally, run the simulation and generate a VCD (Value Change Dump) file:

   ```sh
   ghdl -r tb_iir_filter --vcd=tb_iir_filter.vcd
   ```

5. **View the waveforms (optional)**:
   If you want to visualize the simulation results, open the VCD file with GTKWave:

   ```sh
   gtkwave tb_iir_filter.vcd
   ```

## Simulation Instructions (Cocotb Method)

Follow these steps to compile and run the simulation using Cocotb:

1. **Install Cocotb**:
   Make sure you have Cocotb installed. You can install it using pip:

   ```sh
   pip install cocotb
   ```

2. **Makefile and Python Test Script**:
   Ensure you have the `Makefile` and `test_iir_filter.py` in your project directory. These files are used to run the simulation with Cocotb.

3. **Run the Cocotb Simulation**:
   Use the Makefile to run the simulation. Open a terminal and navigate to the directory containing your VHDL files and run:

   ```sh
   make SIM=ghdl TOPLEVEL_LANG=vhdl TOPLEVEL=iir_filter MODULE=test_iir_filter
   ```

4. **View the waveforms (optional)**:
   If the simulation generates a VCD file, you can view it using GTKWave:

   ```sh
   gtkwave sim_build/your_vcd_file.vcd
   ```

## IIR Filter Details

### Generic Parameters

- `N`: Bit width of the input and output signals (default is 16).
- `A1`, `A2`, `B0`, `B1`, `B2`: Filter coefficients in real format.

### Ports

- `clk`: Clock signal.
- `reset`: Reset signal (active high).
- `input_sig`: Input signal of type `signed(N-1 downto 0)`.
- `output_sig`: Output signal of type `signed(N-1 downto 0)`.

## Testbench Details

The traditional testbench (`tb_iir_filter.vhdl`) initializes the IIR filter and applies a series of test vectors to verify the filter's behavior. The following steps are performed:

1. **Reset the filter** at the beginning of the simulation.
2. **Apply test vectors** to the input signal and wait for several clock cycles to observe the output.

The Cocotb test script (`test_iir_filter.py`) can be used for more advanced and flexible testing in Python.

Feel free to modify the testbenches to include additional test cases and assertions as needed.
