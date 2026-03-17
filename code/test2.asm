// -------------------------
// Init (all within [-8,7])
// -------------------------
addi $t0, $zero, 3
addi $t1, $zero, -2
addi $t2, $zero, 4
addi $t3, $zero, 1
addi $t4, $zero, -1

// -------------------------
// ALU → ALU forwarding chain
// -------------------------
add  $t0, $t0, $t1      // 3 + (-2) = 1
add  $t1, $t0, $t2      // 1 + 4 = 5  (needs EX→EX forward)
sub  $t2, $t1, $t3      // 5 - 1 = 4  (chain continues)
and  $t3, $t2, $t0      // 4 & 1 = 0
or   $t4, $t3, $t1      // 0 | 5 = 5

// -------------------------
// Store + Load
// -------------------------
sw   $t1, 2($t0)        // MEM[t0+2] = 5
lw   $t2, 2($t0)        // load 5

// -------------------------
// Load-use hazard (STALL)
// -------------------------
add  $t3, $t2, $t4      // needs stall (lw result not ready)

// -------------------------
// Branch NOT taken
// -------------------------
beq  $t3, $t0, skip1    // unlikely equal → not taken
addi $t4, $t4, 1        // executes normally

// -------------------------
// Branch TAKEN (tests flush)
// -------------------------
beq  $t1, $t2, label1   // 5 == 5 → taken
addi $t0, $t0, 7        // SHOULD BE FLUSHED
addi $t0, $t0, -3       // SHOULD BE FLUSHED

// -------------------------
skip1:
add  $t1, $t1, $t1      // 5 + 5 = 10 → overflow risk, fix below
addi $t1, $zero, -6     // clamp to safe range

// -------------------------
// Label1 (branch target)
// -------------------------
label1:
sub  $t2, $t2, $t1      // depends on forwarded $t1
and  $t3, $t2, $t0

// -------------------------
// Jump test (flush)
// -------------------------
j    label2
addi $t4, $t4, 3        // SHOULD BE FLUSHED

// -------------------------
// Another path (should only run if branch later)
// -------------------------
label3:
ori  $t0, $t0, 1
andi $t1, $t1, 7
nor  $t2, $t2, $t2
j    end

// -------------------------
// Jump target
// -------------------------
label2:
bneq $t0, $t3, label3   // likely taken → tests branch after jump

// -------------------------
end:

//1 5 F 0 6