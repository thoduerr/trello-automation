Trello Automation Scripts
========================

These shell scripts allow you to automate the creation of a Trello board, lists, and cards using the Trello API.

Prerequisites
-------------

- Make sure you have the following installed:
  - Bash (compatible shell)
  - cURL
  - jq (a command-line JSON processor)
    - Ensure that you have jq installed on your system before running the script. You can install it using a package manager such as apt, yum, or brew, depending on your operating system.

- Trello
  - Set up a Trello account and create a new board where you want the cards to be added.
  - Generate an API key and token by going to the Trello Developer API page (https://trello.com/app-key) and clicking on "Token."

Getting Started
---------------

1. Set up Environment Variables

   Create an `.env` file in the same directory as the scripts and set the following environment variables:

```shell
cat <<EOF > .env
API_KEY="YOUR_API_KEY"
API_TOKEN="YOUR_API_TOKEN"

EOF
```

Replace "YOUR_API_KEY" and "YOUR_API_TOKEN" with your actual Trello API key and token.

2. Define Lists

Create a `lists.json` file in the same directory as the scripts. In this file, define the names of the lists you want to create on your Trello board. Here's an example `lists.json` file:

```json
{
    "lists": [
        "Architecture",
        "Done",
        "Awaiting Acceptance",
        "Awaiting Deployment",
        "In Progress",
        "Backlog",
        "Icebox"
    ]
}
```

Feel free to modify the list names as needed. Make sure to follow the JSON syntax rules.

3. Create the Trello Board

Run the `create_board.sh` script to create a new Trello board. It uses the API key, token, and board name defined in the script:

```shell
./create_board.sh <board name>

# Example:
./create_board.sh "XZY Development"
```

The script will create a new board with the specified name and display the board ID if successful.

4. Create the Lists

Run the `create_lists.sh` script to create the lists on the Trello board. It uses the API key, token, and list names defined in the `lists.json` file:

```shell
./create_lists.sh <file>

# Example:
./create_lists.sh lists_development.json
```


The script will iterate over the list names defined in `lists.json` and create them on the Trello board. It will display success or error messages for each list.

5. Create the Cards

Create a `cards.json` file in the same directory as the scripts. In this file, define the details of the cards you want to create, including the card name, description, and the associated list name. Here's an example `cards.json` file:

```json
{
  "cards": [
    {
      "name": "Card 1",
      "description": "Description for Card 1",
      "list": "Backlog"
    },
    {
      "name": "Card 2",
      "description": "Description for Card 2",
      "list": "In Progress"
    },
    {
      "name": "Card 3",
      "description": "Description for Card 3",
      "list": "Done"
    }
  ]
}
```


Modify the `cards.json` file to include or remove cards as needed, specifying the card name, description, and the associated list name.

Run the `create_cards.sh` script to create the cards on the Trello board. It uses the API key, token, and the details defined in the `cards.json` file:

```shell
./create_cards.sh <file>

# Example:
./create_cards.sh cards.json
```


The script will create the cards on the specified Trello board and associate them with the respective lists. It will display success or error messages for each card.

---

That's it! You can now use these scripts to automate the creation of a Trello board, lists, and cards. Ensure that the scripts, `.env`, `lists.json`, and `cards.json`
