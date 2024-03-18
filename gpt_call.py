import requests

def call_chatgpt(input_file, output_file, api_key):
    # Step 1: Read the contents of the input file
    with open(input_file, 'r') as file:
        prompt = file.read()

    # Prepare the API request
    url = "https://api.openai.com/v1/chat/completions"
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {api_key}"
    }
    payload = {
        "model": "gpt-3.5", #change it to 4
        "messages": [{"role": "user", "content": prompt}]
    }

    # Step 2: Make the API call to ChatGPT
    response = requests.post(url, json=payload, headers=headers)
    response_json = response.json()
    print(response_json)

    # Extract the response text
    try:
        chat_response = response_json['choices'][0]['message']['content']
    except (KeyError, IndexError):
        chat_response = "Error parsing response"

    # Step 3: Write the response to the output file
    with open(output_file, 'w') as file:
        file.write(chat_response)

# Replace 'YOUR_API_KEY_HERE' with your actual OpenAI API key
api_key = "sk-PSC7IwtfJEFasf6wCvdgT3BlbkFJQF1KmNSkbFAtfhMxE0Kv0"

# Specify the input and output files
input_file = "template_modified.c"  # This file should contain your prompt/message
output_file = "response.c"

# Call the function with the specified input and output files
call_chatgpt(input_file, output_file, api_key)