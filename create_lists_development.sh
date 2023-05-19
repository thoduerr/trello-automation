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

# Check if BOARD_ID are already set
if [[ -z "$BOARD_ID" ]]; then
  echo "Error: BOARD_ID not set. Please define in the .env file."
  exit 1
fi

# Predefined lists
LIST_NAMES=("Icebox" "Backlog" "In Progress" "Awaiting Deployment" "Awaiting Acceptance" "Done")

# Create lists
for list_name in "${LIST_NAMES[@]}"; do
    # URL encode the list name
    encoded_list_name=$(echo -n "$list_name" | jq -s -R -r @uri)

    url="https://api.trello.com/1/lists?key=${API_KEY}&token=${API_TOKEN}&idBoard=${BOARD_ID}&name=${encoded_list_name}"
    response=$(curl -s -X POST $url)

    if [[ $response == *"\"id\":"* ]]; then
        echo "List '$list_name' created successfully."
    else
        echo "Error creating list '$list_name': $response"
    fi
done