#!/bin/bash

# Function to select a random quote
get_quote() {
    # Parsing all the lines from the quotes.txt file into an array
    while IFS= read -r line; do
	quotes+=("$line")
    done < "quotes.txt"
    # Returning a random quote
    printf "${quotes[$RANDOM % ${#quotes[@]}]}"
}

# Function used to calculate typing speed in WPM
calculate_wpm() {
    printf $(printf "%.2f" $(echo "scale=2; ($(printf "$1" | wc -w) / $2) * 60" | bc))
}

# Main function
testdata() {
    # Test initialisation step
    quote=$(get_quote); start=$(date +%s.%N)

    # Prompting user to type
    clear; printf "Type the following text:"'\n\n'"$quote"'\n'; read -p "" input

    # Calculating elapsed time
    end=$(date +%s.%N); elapsed=$(bc <<< "scale=3; $end - $start")

    # Checking for any typos
    if [[ "$input" == "$quote" ]]; then
        printf "\nCorrect!\n"
    else
        printf "\nIncorrect: Typos were made.\n"
    fi

    # Calculating the user's typing speed in WPM
    wpm=$(calculate_wpm "$input" "$elapsed"); printf "Your WPM: $wpm"'\n\n'"Press Enter to continue to the next test"'\n'"Press Ctrl + C to exit"'\n'
    read -p "" restart

    if ! [[ $restart ]]; then
        testdata
    fi
}

testdata
