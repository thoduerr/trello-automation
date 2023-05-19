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

JSON_FILE=$1  # Path to the JSON file containing card details

# Read the JSON file and extract card details
CARD_DETAILS=$(cat $JSON_FILE | jq -c '.cards[]')

# Iterate over card details and create Trello cards
while IFS= read -r card; do
    name=$(echo -n "$card" | jq -r '.name')
    description=$(echo -n "$card" | jq -r '.description')
    list_name=$(echo -n "$card" | jq -r '.list')

    # URL encode the card name, description, and list name
    encoded_name=$(echo -n "$name" | jq -s -R -r @uri)
    encoded_description=$(echo -n "$description" | jq -s -R -r @uri)
    # encoded_list_name=$(echo -n "$list_name" | jq -s -R -r @uri)

    # Find the list ID by name
    url="https://api.trello.com/1/boards/$BOARD_ID/lists?key=$API_KEY&token=$API_TOKEN"
    lists_response=$(curl -s $url)
    # list_id=$(echo -n "$lists_response" | jq -r --arg list_name "$encoded_list_name" '.[] | select(.name | contains($list_name)) | .id')
    list_id=$(echo -n "$lists_response" | jq -r --arg list_name "$list_name" '.[] | select(.name | contains($list_name)) | .id')

    if [[ -z "$list_id" ]]; then
        echo "Error: List '$list_name' not found."
        continue
    fi

    url="https://api.trello.com/1/cards?key=$API_KEY&token=$API_TOKEN&idList=$list_id&name=$encoded_name&desc=$encoded_description"
    response=$(curl -s -X POST $url)

    if [[ $response == *"\"id\":"* ]]; then
        echo "Card '$name' created successfully."
    else
        echo "Error creating card '$name': $response"
    fi
done <<< "$CARD_DETAILS"
