addi $t1, $t0, 5    
beq  $t1, $t1, target 
addi $t2, $t0, 1    //SHOULD BE FLUSHED (Delay Slot)
addi $t2, $t0, 2    //Should be skipped
target:
addi $t4, $t0, 9    //The actual destination
addi $t3, $t0, 9    //The actual destination




