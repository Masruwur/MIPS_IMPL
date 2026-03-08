subi $sp, $sp, 1
addi $t0, $zero, 3
addi $t1, $zero, 2
sw $t1, 1($sp)
add  $t2, $t0, $t1
sub  $t3, $t2, $t1 
lw $t3, 1($sp)
addi $sp, $sp, 1
