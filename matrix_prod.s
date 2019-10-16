
    .globl matrix_prod
matrix_prod:            # void matrix_prod(void *A, void *B, void *C, int n);

    # rdi - *A - caller saved
    # rsi - *B -  same
    # rdx - *C - same
    # rcx - n - same

    # r10 - i
    # r11 - j

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
    # save current register values
    pushq %rdi
    pushq %rsi
    pushq %rdx
    pushq %rcx
    # rdx main n bhargna hai, rcx main i, r8 main j
    mov %rcx,%rdx
    mov %r10,%rcx
    mov %r11,%r8

    # call karna hai apne ko dot product
    call dot_prod
    # answer aaega rax main
    # rdi main rax bharna hai, rsi main apne ko 17 bharna hai
    mov %rax,%rdi
    mov $17,%rsi

    # mod call karna hai
    call mod
xx:
    # usse peehle yahan pop karna hai saara kuch pop kardo idhar
    popq %rcx
    popq %rdx
    popq %rsi
    popq %rdi

    # C[i][j] matlab rdx -> save karna hai rax
    mov %rax,(%rdx)

    	# C_ij = dotprod()

    incq %r11       #j++    (j counter)
    incq %rdx       # rdx++ points to next element of C, i.e., element++ of C
    
    cmp %rcx,%r11   # if j>=n; loop_i
    jge loop_i



    jmp loop_j



end:
	ret
