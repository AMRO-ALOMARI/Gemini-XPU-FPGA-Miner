# Gemini-XPU-FPGA-Miner
An ultra-efficient crypto core on Intel MAX 10 FPGA. By pivoting to an Iterative Radix-16 architecture, we slashed logic usage from 99% to just 6% and reduced compilation time from 5 hours to 1 minute, solving critical routing congestion.
<img width="2560" height="1528" alt="Compilation_Success" src="https://github.com/user-attachments/assets/7a023305-918b-4cfd-9a28-b2483c404ad0" />
# Gemini XPU: High-Efficiency Crypto Core on FPGA

**Hardware Implementation of Secp256k1 Modular Squaring using Iterative Radix-16 Architecture.**

![Project Status](https://img.shields.io/badge/Status-Completed-green)
![Platform](https://img.shields.io/badge/Platform-Intel_MAX10-blue)
![Language](https://img.shields.io/badge/Language-SystemVerilog-orange)

## 🚀 Overview
This project demonstrates the design of a custom cryptographic processor (XPU) capable of performing 256-bit Modular Squaring, a critical operation in Bitcoin mining (Secp256k1). The design is optimized for low-cost FPGAs (Intel MAX 10), proving that smart architecture beats raw power.

## 🎯 The Challenge
Implementing wide 256-bit arithmetic on entry-level FPGAs initially led to catastrophic failure:
* **Routing Congestion:** Hit **108%** (The chip was physically choked).
* **Compilation Time:** Took **5+ hours** and eventually failed.
* **Resource Exhaustion:** A fully pipelined design consumed ~99% of logic cells.

## 💡 The Solution: Iterative Architecture
We pivoted from a "Brute Force" approach to a smart **Multi-Cycle Radix-16 Core**:
1.  **Iterative Processing:** The core processes 4-bits of the operand per clock cycle (64 cycles total).
2.  **Compact Footprint:** Drastically reduces DSP and Logic usage by >90%.
3.  **Solinas Reduction:** Mathematical optimization to handle Modulo operations without heavy division gates.

## 📊 Results & Benchmarks

| Metric | Initial Design (Pipelined) | **Final Design (Gemini XPU)** | Improvement |
| :--- | :--- | :--- | :--- |
| **Logic Utilization** | ~37,400 LEs (99%) | **~3,109 LEs (6%)** | **94% Saving** 📉 |
| **Compilation Time** | 5+ Hours (Failed) | **1 Minute** | **300x Faster** ⚡ |
| **Routing Congestion** | 108% (Critical) | **< 40% (Clean)** | **Solved** ✅ |

### ✅ Proof of Success
The Quartus report below confirms successful compilation in just 1 minute with minimal resource usage:

![Compilation Success](Compilation_Success.png)

## 🛠️ Hardware & Tools
* **FPGA:** Intel MAX 10 (10M50DAF484C6GES)
* **EDA Tool:** Quartus Prime Lite 23.1
* **Language:** SystemVerilog

## 📂 Project Structure
* `mod_square_secp256k1.sv`: The optimized SystemVerilog source code.
* `Gemini_XPU_Core.sdc`: Timing constraints.
* `Gemini_XPU_Core.qpf`: Quartus project file.

---
*Built for the Hackathon 2026. Powered by Engineering Persistence.*
