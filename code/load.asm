subi $sp, $sp, 1
addi $t0, $t0, 5
sw $t0, 1($sp)
addi $t0, $t0, 5
lw $t0, 1($sp)
add $t2, $t1, $t0
addi $sp, $sp, 1