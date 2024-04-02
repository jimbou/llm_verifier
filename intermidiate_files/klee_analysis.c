#include <klee/klee.h>

int is_prime(int n) {
    if (n <= 1) return 0; // 0 and 1 are not prime numbers
    if (n <= 3) return 1; // 2 and 3 are prime numbers
    
    // This is checked so that we can skip middle five numbers in below loop
    if (n % 2 == 0 || n % 3 == 0) return 0;
    
    for (int i = 5; i * i <= n; i += 6) {
        if (n % i == 0 || n % (i + 2) == 0)
            return 0;
    }
    return 1;
}

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