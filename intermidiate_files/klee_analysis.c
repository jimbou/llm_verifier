#include <klee/klee.h>

int fibonacci(int n) {
    // Check that the input is positive
    if (n < 0) {
        return -1; // Invalid input
    } else if (n == 0) {
        return 0; // Base case
    } else if (n == 1) {
        return 1; // Base case
    }

    int a = 0, b = 1, c;
    for (int i = 2; i <= n; i++) {
        c = a + b; // Correct calculation of Fibonacci sequence
        a = b;
        b = c;
    }
    return b;
}
//

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