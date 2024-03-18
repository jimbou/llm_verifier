//start_function
int fibonacci(int n) {
    // check that the input is positive 
    if (n < 0) {
        return -1; // return error
    }

    // find the nth fibonacci number 
    if (n == 0) {
        return 0; 
    } else if (n == 1) {
        return 1; 
    } else {
        int fib_pre_pre = 0;
        int fib_pre = 1;
        int fibonacci = 0;

        for (int i = 2; i <=n; ++i) {
            fibonacci = fib_pre + fib_pre_pre;
            fib_pre_pre = fib_pre;
            fib_pre = fibonacci;
        }

        return fibonacci;
    }
}
//end_function

//start_main
#include <klee/klee.h>
int main() {
    // klee symbolic creation
    int n;
    klee_make_symbolic(&n, sizeof(n), "n");

    // necessary klee assumes
    klee_assume(n >= 0);

    // call the function with the symbolic parameters
    int result = fibonacci(n);

    // necessary klee asserts
    // the result is always >= 0 because of the input restriction (n >= 0)
    klee_assert(result >= 0);

    // positive Fibonacci numbers are monotonically increasing with n, hence result should be >= n-1
    if (n > 1) {
      klee_assert(result >= n-1);
    }

    return 0;
}
//end_main