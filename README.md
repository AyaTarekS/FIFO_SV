#  Synchronous FIFO Verification Project

## Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [SetUP](#setup)
3. [Repository Structure](#repository-structure)
4. [CMD Commands](#cmd-commands)
5. [License](#license)

---

## Overview
This project verifies a parameterized Synchronous FIFO design using SystemVerilog. The FIFO supports configurable data width and depth with default values of 16 and 8 respectively.

Verification focuses on ensuring correct behavior of all data flow and control signals under various scenarios, including normal operation, corner cases (full/empty), and assertion of error conditions (overflow/underflow)..

---
## Objective
- Validate the correctness of FIFO functionality.
- Ensure accurate signal behavior under all possible control signal combinations.
- Handle corner cases like overflow, underflow, reset, and boundary transitions (full/empty).
- Track signal combinations and collect coverage data to ensure completeness.

---

## Design Under Test (DUT)

### Parameters:
- `FIFO_WIDTH`: Width of data bus (Default = 16 bits)
- `FIFO_DEPTH`: Depth of FIFO (Default = 8 entries)

### Ports:

| Port         | Direction | Description |
|--------------|-----------|-------------|
| `data_in`    | Input     | Data input bus |
| `wr_en`      | Input     | Write enable |
| `rd_en`      | Input     | Read enable |
| `clk`        | Input     | Clock |
| `rst_n`      | Input     | Active-low reset |
| `data_out`   | Output    | Data output bus |
| `full`       | Output    | FIFO full flag |
| `almostfull` | Output    | One entry before full |
| `empty`      | Output    | FIFO empty flag |
| `almostempty`| Output    | One entry before empty |
| `overflow`   | Output    | Write error when full |
| `underflow`  | Output    | Read error when empty |
| `wr_ack`     | Output    | Write success acknowledgment |

---
## Verification Enviornment

## Structure

### **1. Packages**

#### **1.1. Transaction Package**

- Defines a class that includes data and control signals as class variables (e.g., `data_in`, `wr_en`, `rd_en`).
- Adds constraints to guide the randomization behavior:
  - Prioritize frequent reset.
  - Bias write and read enable signals using configurable distributions.

#### **1.2. Functional Coverage Package**

- Defines a coverage group that crosses:
  - Write enable (`wr_en`)
  - Read enable (`rd_en`)
  - Output control signals (excluding `data_out`)
- Expected number of bins: **7** (covering combinations between 3 inputs and 7 output flags).
- Provides a `sample()` method to:
  - Accept a transaction object.
  - Sample the coverage group based on current signal values.

#### **1.3. Scoreboard Package**

- Contains a method `check_data()` which:
  - Uses a `reference_model()` to generate the expected output.
  - Compares the DUT output with the reference model output.
  - Logs pass/fail results and discrepancies.
- Tracks test statistics, such as total transactions, correct, and incorrect results.

#### **1.4. Shared Package**

- Contains shared parameters and type definitions used across the environment (e.g., `FIFO_WIDTH`, `FIFO_DEPTH`, distributions).

---

### **2. Testbench Integration**

- Integrates the following components:
  - Transaction generator (creates randomized input scenarios)
  - Scoreboard (validates DUT output)
  - Coverage hooks (triggers functional coverage sampling)
- Drives signals like `wr_en`, `rd_en`, and `data_in` using constrained randomization.

---

### **3. Assertions**

- Implements assertions to cover:
  - All meaningful combinations of output flags.
  - Illegal scenarios like:
    - Write when FIFO is full.
    - Read when FIFO is empty.
- Controlled via `+define+ASSERT_ON` for compilation and simulation flexibility.

---

### **4. Interface**

- Defines a SystemVerilog interface to:
  - Group and encapsulate all DUT and testbench signals.
  - Simplify module connections.
  - Improve code modularity and reuse.

---

### **5. Monitor**

- Observes DUT inputs/outputs.
- Connects sampled signals to the transaction object.
- Invokes functional coverage and scoreboard checking on each clock cycle.

---

### **6. Top Module**

- Top-level module to:
  - Generate the clock and reset.
  - Instantiate the DUT, interface, and testbench.
  - Bind the assertion module to the DUT using SystemVerilog `bind` construct.

---

## Directory Structure

```
/fifo_sv
├── FIFO.sv                #DUT
├── FIFO_SV.sv             #Assertions
├── TB.sv                  #Testbench
├── coverage_pkg.sv        #fuctional coverage
├── score_board.sv
├── transaction_pkg.sv
├── shared_pkg.sv
├── interface.sv
├── monitor.sv
├── top.sv                  #top module to simulate
├── run.do                  #Simulation script
└── README.md               # Documentation
```

---

## Tools Required

- **Simulator**: ModelSim, QuestaSim, or any SystemVerilog-compatible tool
- **Language**: SystemVerilog (IEEE 1800)
- **Optional**: Coverage tools for functional metrics

---

## SetUP

Follow these steps to set up and run the project:

1. **Ensure Tool Installation**
   - Make sure you have installed the required tools.

2. **Clone the Repository**
   ```bash
   git clone https://github.com/AyaTarekS/FIFO_SV/
   ```

3. **Running the Simulation**
   ```sh
    vsim -do run.do
   ```

## License

This project is licensed under the [MIt license](LICENSE).
