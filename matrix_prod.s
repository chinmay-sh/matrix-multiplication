
    .globl matrix_prod
matrix_prod:            # void matrix_prod(void *A, void *B, void *C, int n);

    # Algorithm:
    # Loops over every element of C, keeping track of row and column changes in i and j variables.
    # Calls dotprod function with respective row and column and stores the mod(result,17) in C[i][j] element.
    # loop_i keeps track of i variable and updates it. It also resets j to 0 after every row change. If the rows are finished,
    #   it ends the program.
    # loop_j keeps track of j variable and loops over every element of C and calculates C[i][j] by calling dot_prod and mod.
    #   It goes over columns of i_th row, and if columns are finished, it jumps to loop_i to change the row or end program.

    # register map
    # rdi - *A - points to first element of A
    # rsi - *B - points to first element of B
    # rdx - *C - points to first element of C
    # rcx - n
    # r10 - i
    # r11 - j

    mov $0, %r10        # i = 0 (row counter)
    mov $0, %r11        # j = 0 (column counter)

    jmp loop_j

loop_i:
    incq %r10           # i++

    cmp %rcx,%r10       
    jge end             # if i >= n;end;

    mov $0, %r11        # j = 0 (reset j counter to 0 after every row)

loop_j:

    # save current register values
    pushq %rdi
    pushq %rsi
    pushq %rdx
    pushq %rcx

    # Modify argument registers for dot_prod function call
    mov %rcx,%rdx   # rdx <- n
    mov %r10,%rcx   # rcx <- i
    mov %r11,%r8    # r8 <- j

    # Call dot_prod function
    call dot_prod      # dot_prod(*A,*B,n,i,j)

    # rax holds the dotprod result
    # Preparing argument registers for mod function call
    mov %rax,%rdi   # rdi <- result of dot_prod
    mov $17,%rsi    # rsi <- 17 (mod value)

    # Call mod function
    call mod        # mod(dot_prod(*A,*B,n,i,j),17)

    # Restoring registers from stack
    popq %rcx
    popq %rdx
    popq %rsi
    popq %rdi

    # C[i][j] <- rax
    mov %rax,(%rdx) # C[i][j] = mod(dot_prod(*A,*B,n,i,j),17)

    incq %r11       #j++    (j counter increment)
    incq %rdx       # rdx++ points to next element of C, i.e., element++ of C
    
    cmp %rcx,%r11   # if j>=n; loop_i
    jge loop_i

    jmp loop_j      # next column of i_th row

end:
	ret
