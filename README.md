
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

2. **Building Containers Manually**: If you encounter issues with Docker Compose, you can manually build and run the containers based on the documentation provided for Infer and KLEE. Update the image names in `scripts/verification_klee.sh` and `scripts/verification_infer.sh` accordingly. The Manager container can be built and run using the following commands:
    ```bash
    docker build -t manager_image .
    docker run -d --name manager_container -v /var/run/docker.sock:/var/run/docker.sock manager_image
    ```

At this point, you should have all three containers built and be inside the Manager container, ready to execute the verification tasks.

## Usage
- **Prompt Construction**: [Instructions on how to construct prompts for LLMs]
- **Code Extraction**: [Instructions on how to extract code from LLM outputs]
- **Verification**: [Instructions on how to use the verification scripts]



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


## Contributing
Contributions to this project are welcome. Please follow the standard GitHub pull request process to propose changes.

## License
This project is licensed under the [LICENSE] - see the LICENSE file for details.
