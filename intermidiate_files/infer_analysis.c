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