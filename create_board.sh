#!/bin/bash

# Load environment variables from .env file
if [[ -f .env ]]; then
  source .env
fi

# Check if API_KEY and API_TOKEN are already set
if [[ -z "$API_KEY" || -z "$API_TOKEN" ]]; then
  echo "Error: API_KEY or API_TOKEN not set. Please define them in the .env file."
  exit 1
fi

BOARD_NAME=$1 # Name of the new board

# URL encode the board name
encoded_board_name=$(echo "$BOARD_NAME" | jq -s -R -r @uri)

# Create a new board
url="https://api.trello.com/1/boards?key=${API_KEY}&token=${API_TOKEN}&name=${encoded_board_name}"
response=$(curl -s -X POST $url)

if [[ $response == *"\"id\":"* ]]; then
  board_id=$(echo $response | jq -r '.id')
  echo "Board '$BOARD_NAME' created successfully with ID: $board_id"
  echo "BOARD_ID=$board_id" >>.env
else
  echo "Error creating board '$BOARD_NAME': $response"
  exit 1
fi