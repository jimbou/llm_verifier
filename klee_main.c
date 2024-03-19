#include <klee/klee.h>

int main(){
    int n;
    // klee symbolics creation
    klee_make_symbolic(&n, sizeof(n), "n");

    // necessary klee assumes
    klee_assume(n >= 0); // Assume n is positive or zero
    klee_assume(n < 45); //assume n <45 for overflows
    // call the function with the symbolic parameter
    int fib = fibonacci(n);

    // necessary klee asserts
    klee_assert(fib >= 0); // Fibonacci numbers are always non-negative
    if (n > 1) {
        klee_assert(fib >= n - 1); // For n > 1, fib(n) >= n - 1
    }

    return 0;
}
//
//