#include <klee/klee.h>

int main() {
    int a;
    klee_make_symbolic(&a, sizeof(a), "a"); // klee symbolics creation

    klee_assume(a > 0); // necessary klee assumes, prime numbers are positive

    int result = is_prime(a); // call the function with the symbolic parameter

    // necessary klee asserts
    // Example assertions for known primes and non-primes for validation
    if (a == 2 || a == 3 || a == 5 || a == 7)
        klee_assert(result == 1); // Assert that the function recognizes known primes
    else if (a == 1 || a == 4 || a == 6 || a == 8 || a == 9)
        klee_assert(result == 0); // Assert that the function recognizes known non-primes

    return 0;
}