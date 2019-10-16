
    .globl matrix_prod
matrix_prod:            # void matrix_prod(void *A, void *B, void *C, int n);

    # rdi - *A - caller saved
    # rsi - *B -  same
    # rdx - *C - same
    # rcx - n - same

    # r10 - i
    # r11 - j

    #r12-temp i counter
    #r13-temp j counter


    mov $0, %r10        # i = 0
    mov $0, %r11        # j = 0

    movl %ecx, %r9d     # r9 <- n
	imul %r10, %r9      # r9 <- i*n
    add %r11,%r9        # r9 <- i*n + j
	addq %r9, %rdx      # rdx points to i,j element of C    (0,0 element)
    jmp loop_j

loop_i:
    incq %r10           # i++
    cmp %rcx,%r10       
    jge end             # if i >= n;end;

    mov $0, %r11        # j = 0

loop_j:
    	# C_ij = dotprod()

    incq %r11       #j++    (j counter)
    incq %rdx       # rdx++ points to next element of C, i.e., element++ of C
    
    cmp %rcx,%r11   # if j>=n; loop_i
    jge loop_i



    jmp loop_j



end:
	ret
