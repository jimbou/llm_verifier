
# Large Language Model C Function Autocompletion Verifier

## Introduction
This project explores the implementation of a solution to improve the reliability of Large Language Models (LLMs) for generating C function autocompletions. We focus on three main areas: prompt construction to generate accurate LLM completions, code extraction to isolate relevant code from LLM outputs, and verifier tailoring, employing both static (Infer) and dynamic (KLEE) analysis for code verification. Our approach aims to automate the completion and verification process, enhancing the utility of LLMs in software development using C, while minimizing the risk of errors in critical systems. This end-to-end tool represents a significant step towards safer and more efficient LLM-assisted coding practices.

## Getting Started

### Prerequisites
- Docker
- Docker Compose (optional but recommended for managing multiple containers seamlessly)

### Setup
1. **Start Containers**: Use the `start_containers.sh` script to create the three containers and enter an interactive session in the manager container. The setup involves the following containers:
    - **Manager Container**: Acts as the brain of the project, executing Python and bash scripts, making API calls to LLMs, and orchestrating the verification tasks in the other containers.
    - **Infer Container**: Dedicated to static code analysis using Infer.
    - **KLEE Container**: Focused on dynamic analysis using KLEE. This container is pulled directly from Docker Hub.

   The Infer and Manager containers are built from Dockerfiles located in the `dockerfile` folder. If the images are already available, Docker Compose will skip pulling and rebuilding them.

2. **Alternative - Building Containers Manually**: If you encounter issues with Docker Compose, you can manually build and run the containers based on the documentation provided for Infer and KLEE. Update the image names in `scripts/verification_klee.sh` and `scripts/verification_infer.sh` accordingly. The Manager container can be built and run using the following commands:
    ```bash
    docker build -t manager_image .
    docker run -d --name manager_container -v /var/run/docker.sock:/var/run/docker.sock manager_image
    ```

At this point, you should have all three containers built and be inside the Manager container terminal, ready to execute the verification tasks.



# Verification Tool Usage Guide

## Running the Verification Tool

### Prerequisites
- **Recommended Environment**: It is advisable to run the commands within the Docker manager for optimal performance and compatibility.
- **Alternative Environment**: If you are using a Linux environment with Python3 installed, you can execute the commands directly from the repository folder.

### Command Usage
To start the verification process, use the following command:

```sh
./verifier.sh <arg1> <arg2>
```

- `arg1` (First Argument): Specifies the maximum number of retries for the verification process. A value of `0` means the tool will only verify the original code without attempting any fixes in case of errors.
- `arg2` (Second Argument): This is a boolean flag indicating whether the API calls should be made manually or automatically:
  - If `true`, the tool generates a prompt in `template_modified.c` within the `prompt` folder. You should manually copy this prompt into an LLM (Large Language Model) of your choice and submit the response back into `llm_response.c`. For retries, use `prompt/template_retry_modified.c` and `llm_re_response.c` respectively.
  - If `false`, the tool automatically makes calls to ChatGPT-4 using a provided token, handling the entire process without the need for manual intervention. Please note that the token has a limited number of credits, and misuse is discouraged.

### Process Overview
1. **Code Submission**: You will be prompted to input your incomplete C code into a newly created file.
2. **Additional Context**: To enhance the accuracy of the response, you will be asked three questions:
   - Desired output of the code.
   - Contextual information for assertion creation, including acceptable variable ranges for both input and output.
   - Required include directives, formatted as `#include <stdio.h>`, etc.

Using the information provided, the tool crafts a prompt using `template.c` and proceeds based on the value of `arg2`.

### Verification and Debugging
- The response is processed to extract the code, which is then used for analysis via Infer and Klee tools within their respective Docker containers.
- Infer analysis checks for potential bugs, and Klee analysis verifies the code against predefined conditions.
- If no errors are detected by either tool, the code is deemed verified and saved in `verified.c`.
- In case of errors, and if the retry limit hasn't been reached, the tool attempts to debug the code automatically. A new prompt is created based on the errors and any additional user input, initiating another round of verification.
- This cycle repeats until the code is successfully verified or the maximum retry limit is reached.

By adhering to these guidelines, you can effectively utilize the verification tool to ensure your code meets the desired standards and functions as expected.

## Example Video Tutorial : Sort 5 numbers
Here you can find an example tutorial video on how to use the tool:
  [![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/wKydsmQ2hzw/maxresdefault.jpg)](https://www.youtube.com/watch?v=wKydsmQ2hzw)\

## Exaple of verifier use : Prime Checker Function 
An example of veriier use for a function that checks in a number is prime or not can be found in the e
xamples folder : https://github.com/jimbou/llm_verifier/tree/master/examples
## Example of verifier use : Fibonacci Function 

This section provides a detailed example of using the llm verifier to autocomplete the Fibonacci function. The example includes code snippets, prompts, and responses from the language model, along with the reports generated by KLEE and Infer static analysis tools.

### Code Snippet for Autocompletion

The initial code snippet provided for autocompletion is as follows:

```c
int fibonacci(int n) {
    //check that the input is positive
    if (n < 0) {
        return -1;
    }
    //find the nth fibonacci number
}
```
- The output requested was : the nth fibonacci number.
- The context given was : the input n should be positive or 0 and the result should be >=0 and >= n-1
- No necessary includes were provided

### Prompt Created

The prompt created for the language model was:

```plaintext
/*Desired output: the nth fibonacci number */
/*Relevant Context: the input n should be positive or 0 and the result should be >=0 and >= n-1 */

//start_function pls keep this comment in your response

int fibonacci(int n) {
    //check that the input is positive
    if (n < 0) {
        return -1;
    }
    //find the nth fibonacci number

    //please fill the rest of the code
}
//end_function pls keep this comment in your response

//now pls create a main in the correct format to be analysed by klee

//start_main pls keep this comment in your response
int main(){
    //klee symbolics creation

    //necessary klee assumes

    // call the function with the symbolic parameters

    //necessary klee asserts
    return 0;
}
//end_main pls keep this comment in your response
```

### Response from the Language Model

The language model provided the following response:
```plaintext
Here is the provides code that implements a function to calculate the nth Fibonacci number in c:



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
The main function to execute the fibonacci function with symbolic inputs and assertions is as follows:

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
```
 ### Extracting the code for the analysis and creation of the files used for klee and infer analysis

#### The c source code analysed by infer  is
```c

int fibonacci(int n) {
    //check that the input is positive
    if (n < 0) {
        return -1;
    }

    //find the nth fibonacci number
    int f[n + 2]; // 0th and 1st number of the series are 0 and 1
    f[0] = 0;
    f[1] = 1;

    for (int i = 2; i <= n; i++) {
        // Add the previous 2 numbers in the series and store it
        f[i] = f[i - 1] + f[i - 2];
    }

    return f[n];
}
```


#### The c source code analysed by klee is
```c

int fibonacci(int n) {
    //check that the input is positive
    if (n < 0) {
        return -1;
    }

    //find the nth fibonacci number
    int f[n + 2]; // 0th and 1st number of the series are 0 and 1
    f[0] = 0;
    f[1] = 1;

    for (int i = 2; i <= n; i++) {
        // Add the previous 2 numbers in the series and store it
        f[i] = f[i - 1] + f[i - 2];
    }

    return f[n];
}
 
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
```

### Analysis Reports

#### Infer Report

```
No issues found
```

#### KLEE Report

KLEE provided warnings and errors, indicating issues such as undefined references, large memory allocations, and access violations. An example of an error found with the corresponding test case can be seen below:
```plaintext
KLEE: ERROR: verification/klee_analysis.c:13: memory error: null page access
KLEE: NOTE: now ignoring this error at this location

Error: memory error: null page access
File: verification/klee_analysis.c
Line: 13
assembly.ll line: 581
State: 2
Stack: 
	#000000581 in fibonacci(n=symbolic) at verification/klee_analysis.c:13
	#100000655 in __user_main() at verification/klee_analysis.c:34
	#200000377 in __uClibc_main(95399398657104, 1, 95399398126992, 0, 0, 0, 0) at libc/misc/internals/__uClibc_main.c:401
	#300000549 in main(1, 95399398126992)
Info: 
	address: 0
	next: object at 95399375867648 of size 768
		MO127[768] allocated at global:__C_ctype_b_data

ktest file : 'klee-last/test000002.ktest'
args       : ['verification/klee_analysis.bc']
num objects: 1
object 0: name: 'a'
object 0: size: 4
object 0: data: b'\xff\xff\xff\x1f'
object 0: hex : 0xffffff1f
object 0: int : 536870911
object 0: uint: 536870911
object 0: text: ....
```

### Second llm iteration for debugging
From the errors klee produced we noticed that it probably is relevant to large n as inputs that caused overflows.
- So we provided this debug context :
    The errors are possibly caused by overflows .Pls make sure that n for klee is relatively small around up to 40. Also dont use a table in the function but intermidiate vars
#### New prompt for debugging
The new prompt created is the following:

```plaintext
//you provided the  code that can be seen after //start_function 

//it produced these errors:
/*
Klee_error : 
Error: concretized symbolic size
File: verification/klee_analysis.c
Line: 10
assembly.ll line: 576
State: 3
Stack: 
	#000000576 in fibonacci(n=symbolic) at verification/klee_analysis.c:10
	#100000655 in __user_main() at verification/klee_analysis.c:34
	#200000377 in __uClibc_main(95399398657104, 1, 95399398126992, 0, 0, 0, 0) at libc/misc/internals/__uClibc_main.c:401
	#300000549 in main(1, 95399398126992)
Info: 
  size expr: (Mul w64 4
                       (ZExt w64 (Add w32 2
                                          (ReadLSB w32 0 a))))
  concretization : 8589934596
  unbound example: 8

ktest file : 'klee-last/test000001.ktest'
args       : ['verification/klee_analysis.bc']
num objects: 1
object 0: name: 'a'
object 0: size: 4
object 0: data: b'\x00\x00\x00\x00'
object 0: hex : 0x00000000
object 0: int : 0
object 0: uint: 0
object 0: text: ....

Error: memory error: null page access
File: verification/klee_analysis.c
Line: 13
assembly.ll line: 581
State: 2
Stack: 
	#000000581 in fibonacci(n=symbolic) at verification/klee_analysis.c:13
	#100000655 in __user_main() at verification/klee_analysis.c:34
	#200000377 in __uClibc_main(95399398657104, 1, 95399398126992, 0, 0, 0, 0) at libc/misc/internals/__uClibc_main.c:401
	#300000549 in main(1, 95399398126992)
Info: 
	address: 0
	next: object at 95399375867648 of size 768
		MO127[768] allocated at global:__C_ctype_b_data

ktest file : 'klee-last/test000002.ktest'
args       : ['verification/klee_analysis.bc']
num objects: 1
object 0: name: 'a'
object 0: size: 4
object 0: data: b'\xff\xff\xff\x1f'
object 0: hex : 0xffffff1f
object 0: int : 536870911
object 0: uint: 536870911
object 0: text: ....

Error: memory error: out of bound pointer
File: verification/klee_analysis.c
Line: 14
assembly.ll line: 583
State: 1
Stack: 
	#000000583 in fibonacci(n=symbolic) at verification/klee_analysis.c:14
	#100000655 in __user_main() at verification/klee_analysis.c:34
	#200000377 in __uClibc_main(95399398657104, 1, 95399398126992, 0, 0, 0, 0) at libc/misc/internals/__uClibc_main.c:401
	#300000549 in main(1, 95399398126992)
Info: 
	address: 95399403143172
	next: object at 95399375867648 of size 768
		MO127[768] allocated at global:__C_ctype_b_data

ktest file : 'klee-last/test000003.ktest'
args       : ['verification/klee_analysis.bc']
num objects: 1
object 0: name: 'a'
object 0: size: 4
object 0: data: b'\xff\xff\xff\x7f'
object 0: hex : 0xffffff7f
object 0: int : 2147483647
object 0: uint: 2147483647
object 0: text: ....


Infer_error : 


*/
//end of errors
//Pls correct the errors by changing the code accordingly 

/*Desired output: 
*/
/*Relevant Context: 
The errors are possibly caused by overflows .Pls make sure that n for klee is relatively small around up to 40. Also dont use a table in the function but intermidiate vars
*/

//the below code produced errors
//start_function pls keep this comment in your response

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
//
//end_function pls keep this comment in your response

//now pls create a main in the correct format to be analysed by klee

//start_main pls keep this comment in your response
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
//
//end_main pls keep this comment in your response
```

#### Response from llm
```plaintext
To correct the errors and meet the desired output conditions, we need to adjust the Fibonacci sequence calculation and ensure the function correctly calculates the nth Fibonacci number. . Here's the corrected version of the function:

//start_function

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
//end_function

For the main function that can be analyzed by KLEE, the provided version is already correctly formatted. The klee_make_symbolic function is used to create a symbolic variable, and klee_assume ensures that the symbolic input meets certain conditions. klee_assert is then used to check the properties of the output. Here it is without modifications for clarity:

//start_main

#include <klee/klee.h>

int main(){
    int n;
    // klee symbolics creation
    klee_make_symbolic(&n, sizeof(n), "n");

    // necessary klee assumes
    klee_assume(n >= 0); // Assume n is positive or zero
    klee_assume(n < 40); //assume n <40 for overflows
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
//end_main

This corrected version of the fibonacci function should now produce the desired output without triggering the assertions in the main function when analyzed by KLEE.
```

#### Extracted code for klee and infer analysis
##### The c source code analysed by infer  is
```c

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
```


##### The c source code analysed by klee is
```c

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
        a = b;
        b = c;
    }
    return b;
}
 
int main(){
    int n;
    // klee symbolics creation
    klee_make_symbolic(&n, sizeof(n), "n");

    // necessary klee assumes
    klee_assume(n >= 0); // Assume n is positive or zero
    klee_assume(n < 40); //assume n <40 for overflows
    // call the function with the symbolic parameter
    int fib = fibonacci(n);

    // necessary klee asserts
    klee_assert(fib >= 0); // Fibonacci numbers are always non-negative
    if (n > 1) {
        klee_assert(fib >= n - 1); // For n > 1, fib(n) >= n - 1
    }

    return 0;
}
```
#### Analysis Results and final verified code
The new analysis of the debugged code by Klee and Infer found no Erros and the verified code was presented to the user :

```c

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
```


## Contributing
Contributions to this project are welcome. Please follow the standard GitHub pull request process to propose changes.


