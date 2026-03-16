addi $t0, $zero, 5
addi $t1, $zero, 5
addi $t2, $zero, 3
addi $t3, $zero, 8

add  $t4, $t0, $zero
beq  $t4, $t1, equal1
addi $t2, $t2, 1

equal1:
add  $t4, $t2, $t0
bneq $t4, $t3, notequal1
addi $t2, $t2, 2

notequal1:
sw   $t0, 0($t3)
lw   $t4, 0($t3)
beq  $t4, $t0, equal2
addi $t2, $t2, 3

equal2:
add  $t4, $t1, $t2
bneq $t4, $t1, notequal2
addi $t2, $t2, 4

notequal2:
j end
addi $t2, $t2, 5

end:
addi $t2, $t2, 6  // 5 5 b 8 A 