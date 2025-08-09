# SPI Slave with single port RAM – Verilog Implementation

## 📖 Overview
This project implements a **Serial Peripheral Interface (SPI) Slave** in **Verilog HDL**, designed for FPGA platforms.  
The SPI slave module can receive and transmit data in synchronization with an SPI master, supporting configurable word lengths and protocol parameters.

---

## ✨ Features
- 📡 **SPI Slave logic** compatible with standard SPI Mode 0–3
- 📥 Data reception from MOSI with synchronized sampling
- 📤 Data transmission via MISO with controlled timing
- 🛡 **Chip Select (SS\_n)** handling for transaction control
- 📊 Configurable data width (default: 8-bit)
- 🧪 **Testbench** for functional simulation and verification
- 🧹 Lint-checked using **Questa Lint**

---

## 📂 Project contents
- **Documents** showing the full discrebtion of the specs and the results of the simulation of the Vavido, QuestaSim and QuestaLint
- **Verilog files** showing the design
- **Do files** to run the design easier 
