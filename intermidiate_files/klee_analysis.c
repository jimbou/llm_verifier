#include <klee/klee.h>

int find_big(int a, int b, int c) {
    if (a >= b && a >= c){
        return a;
    }
    else if (b >= a && b >= c){
        return b;
    }
    else {
        return c;
    }
}

#include <klee/klee.h>

int main() {
    int x, y, z;
    
    //klee symbolics creation
    klee_make_symbolic(&x, sizeof(x), "x");
    klee_make_symbolic(&y, sizeof(y), "y");
    klee_make_symbolic(&z, sizeof(z), "z");
    
    // call the function with the symbolic parameters
    int result = find_big(x, y, z);

    // create necessary KLEE assumes
    klee_assume(x >= 0);
    klee_assume(y >= 0);
    klee_assume(z >= 0);

    // necessary KLEE asserts
    klee_assert(result >= x);
    klee_assert(result >= y);
    klee_assert(result >= z);
    
    return 0;
}