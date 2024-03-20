//start_function
int fibonacci(int n) {
    //check that the input is positive
    if (n < 0) {
        return -1;
    }

    //find the nth fibonacci number
    int f[n + 2]; 
   
    // 0th and 1st number of the series are 0 and 1
    f[0] = 0;
    f[1] = 1;
   
    for (int i = 2; i <= n; i++) { 
        // Add the previous 2 numbers in the series and store it
        f[i] = f[i - 1] + f[i - 2];
    }
   
    return f[n];;
}
//end_function

//start_main
int main(){
    //klee symbolics creation
    int a;
    klee_make_symbolic(&a, sizeof(int), "a");

    //necessary klee assumes
    klee_assume(a >= 0);

    // call the function with the symbolic parameters
    int result = fibonacci(a);
    //necessary klee asserts
    klee_assert(result >= 0);

    return 0;
}
//end_main