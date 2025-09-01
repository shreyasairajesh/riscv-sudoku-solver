# RISC-V Sudoku Solver (5x5)

This project implements a **5x5 Sudoku Solver** using **RISC-V Assembly**, executed on the **Ripes Simulator**.  
It demonstrates how a recursive backtracking algorithm can be mapped to low-level assembly programming.

---

## Features
- Backtracking-based Sudoku solver for a 5x5 grid.
- Grid stored in memory as a 1D array.
- Recursive approach with safety checks for row, column, and box constraints.
- Efficient stack frame usage for recursive calls.
- Solution output displayed in the Ripes console.

---

## Tech Stack
- Language: RISC-V Assembly  
- Simulator: [Ripes](https://github.com/mortbopet/Ripes)

---

## Methodology
1. Grid Initialization:  
   - Represented as a 1D array in memory.  
   - `0` denotes empty cells; numbers `1–5` are pre-filled.  

2. Backtracking Algorithm:  
   - Attempts to place numbers 1–5 in empty cells.  
   - Performs safety checks for row, column, and 2x2 sub-box.  
   - If a placement is invalid, the program backtracks.  

3. Termination:  
   - If the grid is completely filled → prints the solution.  
   - If no valid solution exists → prints a failure message.  

---

## Sample Input/Output

**Input Grid**
1 0 3 0 5
0 0 0 0 0
4 0 2 0 3
0 0 0 0 0
5 0 1 0 4

**Solved Grid**
1 2 3 4 5
3 4 5 1 2
4 5 2 3 1
2 1 4 5 3
5 3 1 2 4
