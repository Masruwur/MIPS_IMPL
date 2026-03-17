addi $sp, $sp, -1
addi $t0, $zero, -2
addi $t1, $zero, 1
sw $t1, 1($sp)
addi $t1, $zero, 2
sw $t1, 1($t0)
lw $t2, 1($sp)
lw $t3, 1($t0)
addi $sp, $sp, -1



