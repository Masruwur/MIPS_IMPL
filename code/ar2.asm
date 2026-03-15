// Initialize
addi $t0, $zero, 1      // t0 = 1
addi $t1, $zero, 2      // t1 = 2
addi $t2, $zero, 3      // t2 = 3
addi $t3, $zero, 4      // t3 = 4
addi $t4, $zero, 5      // t4 = 5

// -------------------------
// EX→EX forwarding
// -------------------------
add  $t0, $t1, $t2      // t0 = t1 + t2
sub  $t3, $t0, $t2      // t3 = t0 - t2  (needs t0 from previous EX, EX→EX)

// -------------------------
// MEM→EX forwarding
// -------------------------
add  $t1, $t0, $t3      // t1 = t0 + t3  (t0 just wrote, now forwarding from MEM→EX)
or   $t2, $t1, $t0      // t2 = t1 | t0  (t1 forwarded from MEM→EX)

// -------------------------
// EX→MEM forwarding chain
// -------------------------
sll  $t4, $t2, 2      // t4 = (t2 < t3) ? 1 : 0  (t2 needs value forwarded from EX stage)
add  $t0, $t4, $t1      // t0 = t4 + t1 (t4 just computed, forwarding EX→EX again)

// -------------------------
// Another dependency chain
// -------------------------
and  $t1, $t0, $t3      // t1 = t0 & t3 (t0 just updated, EX→EX)
or   $t2, $t1, $t4      // t2 = t1 | t4 (t1 just updated, EX→EX)
