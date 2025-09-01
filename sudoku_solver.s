.data
grid: .word 1, 0, 3, 0, 5, 0, 0, 0, 0, 0, 4, 0, 2, 0, 3,0, 0, 0, 0, 0,5, 0, 1, 0, 4
space: .string " "
newline: .string "\n"
no_sol_msg: .string "No solution exists\n"
.text
.globl main
# Register conventions:
# s0: base address of grid
# s1: N (size of grid = 5)
main:
# Setup stack frame
addi sp, sp, -16
sw x1, 12(sp)
sw x8, 8(sp)
sw x9, 4(sp)
# Initialize grid base address and N
la x8, grid
li x9, 5
# Call solveSudoku(grid, 0, 0)
mv x10, x8
li x11, 0
li x12, 0
jal solveSudoku
# Check return value
beqz x10, print_no_solution
# Print solution
jal print_grid
j exit
print_no_solution:
la x10, no_sol_msg
li x17, 4
ecall
exit:
# Restore stack
lw x1, 12(sp)
lw x8, 8(sp)
lw x9, 4(sp)
addi sp, sp, 16
# Exit program
li x17, 10
ecall
# Function: solveSudoku(grid, row, col)
solveSudoku:
addi sp, sp, -32
sw x1, 28(sp)
sw x8, 24(sp)
sw x9, 20(sp)
sw x18, 16(sp)
sw x19, 12(sp)
sw x20, 8(sp)
mv x8, x10 # grid address
mv x9, x11 # row
mv x18, x12 # col
# Check if we've reached the end
li x5, 4
li x6, 5
bne x9, x5, not_end
bne x18, x6, not_end
li x10, 1
j solve_return
not_end:
# Check if col == N
li x5, 5
bne x18, x5, check_current
addi x9, x9, 1
li x18, 0
check_current:
# Calculate current position
li x5, 5
mul x6, x9, x5
add x6, x6, x18
slli x6, x6, 2
add x6, x8, x6
lw x7, 0(x6)
bnez x7, skip_current
# Try numbers 1-5
li x19, 1 # num = 1
try_numbers:
mv x10, x8
mv x11, x9
mv x12, x18
mv x13, x19
jal isSafe
beqz x10, next_number
# Place number
li x5, 5
mul x6, x9, x5
add x6, x6, x18
slli x6, x6, 2
add x6, x8, x6
sw x19, 0(x6)
# Recursive call
mv x10, x8
mv x11, x9
addi x12, x18, 1
jal solveSudoku
bnez x10, solve_return
# Remove number if solution not found
li x5, 5
mul x6, x9, x5
add x6, x6, x18
slli x6, x6, 2
add x6, x8, x6
sw zero, 0(x6)
next_number:
addi x19, x19, 1
li x5, 5
ble x19, x5, try_numbers
li x10, 0
j solve_return
skip_current:
mv x10, x8
mv x11, x9
addi x12, x18, 1
jal solveSudoku
solve_return:
lw x1, 28(sp)
lw x8, 24(sp)
lw x9, 20(sp)
lw x18, 16(sp)
lw x19, 12(sp)
lw x20, 8(sp)
addi sp, sp, 32
ret
# Function: isSafe(grid, row, col, num)
isSafe:
addi sp, sp, -24
sw x1, 20(sp)
sw x8, 16(sp)
sw x9, 12(sp)
sw x18, 8(sp)
sw x19, 4(sp)
mv x8, x10 # grid
mv x9, x11 # row
mv x18, x12 # col
mv x19, x13 # num
# Check row
li x5, 0 # i = 0
check_row:
li x6, 5
mul x7, x9, x6
add x7, x7, x5
slli x7, x7, 2
add x7, x8, x7
lw x28, 0(x7)
beq x28, x19, not_safe
addi x5, x5, 1
li x6, 5
blt x5, x6, check_row
# Check column
li x5, 0
check_col:
li x6, 5
mul x7, x5, x6
add x7, x7, x18
slli x7, x7, 2
add x7, x8, x7
lw x28, 0(x7)
beq x28, x19, not_safe
addi x5, x5, 1
li x6, 5
blt x5, x6, check_col
# Check 2x2 box
li x5, 2
div x6, x9, x5
mul x6, x6, x5
div x7, x18, x5
mul x7, x7, x5
mv x28, zero # i = 0
box_i:
mv x29, zero # j = 0
box_j:
add x30, x6, x28
li x31, 5
mul x30, x30, x31
add x31, x7, x29
add x30, x30, x31
slli x30, x30, 2
add x30, x8, x30
lw x31, 0(x30)
beq x31, x19, not_safe
addi x29, x29, 1
li x30, 2
blt x29, x30, box_j
addi x28, x28, 1
li x30, 2
blt x28, x30, box_i
li x10, 1
j safe_return
not_safe:
li x10, 0
safe_return:
lw x1, 20(sp)
lw x8, 16(sp)
lw x9, 12(sp)
lw x18, 8(sp)
lw x19, 4(sp)
addi sp, sp, 24
ret
# Function: print_grid
print_grid:
addi sp, sp, -16
sw x1, 12(sp)
sw x8, 8(sp)
sw x9, 4(sp)
la x8, grid
li x9, 0 # row counter
print_row:
li x6, 0 # column counter
print_col:
# Calculate position and load value
li x7, 5
mul x28, x9, x7
add x28, x28, x6
slli x28, x28, 2
add x28, x8, x28
lw x10, 0(x28)
# Print number
li x17, 1
ecall
# Print space
la x10, space
li x17, 4
ecall
# Increment column
addi x6, x6, 1
li x7, 5
blt x6, x7, print_col
# Print newline
la x10, newline
li x17, 4
ecall
# Increment row
addi x9, x9, 1
li x7, 5
blt x9, x7, print_row
print_grid_return:
lw x1, 12(sp)
lw x8, 8(sp)
lw x9, 4(sp)
addi sp, sp, 16
ret
