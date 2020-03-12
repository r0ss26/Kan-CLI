# Require Classes
require_relative "Classes/Board.rb"
require_relative "Classes/Card.rb"
require_relative "Classes/List.rb"

# Require Gems
require 'figlet'
require 'lolcat'
require 'tty-prompt'

# Figlet Configuration
font = Figlet::Font.new('/big.flf')
$figlet = Figlet::Typesetter.new(font)

# TTY-prompt Configuration
$prompt = TTY::Prompt.new

# Check for a commandline argument to display the help file
if ARGV[0] == "-help" || ARGV[0] == "-h"
    system "cat help.txt"
    exit
end

# Store all of the users variables 
# which describe the state of the application
$state = {
    "user" => {},
    "boards" => {},
    "current board" => nil
}

# Handle user sign up
# The Regex patterns for validation were generated using ihateregex.io
def sign_up

    # Error Messages
    username_error = [
        "Your username must be between 3 and 15 characters",
        "and may only contain a-z, numbers or dashes"
    ].join(" ") 

    password_error = [
        "Your password be at least 8 characters long and",
        "must contain an uppercase letter, a lowercase ",
        "letter, a number and a special character."
    ].join(" ")

    # Prompt the user for a username and store it in the $state variable
    $state["user"]["username"] = $prompt.ask("Please enter a username: ") do |q|
        q.validate(/^[a-z0-9_-]{3,15}$/, username_error)
    end

    # Prompt the user for a password and store it in the $state variable
    puts "(#{password_error})"
    $state["user"]["pw"] = $prompt.mask("Please enter a password: ") do |q|
        q.validate(/^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$/, password_error)
    end
end

# Handle board creation
def create_board
    # Prompt the user to create a Board
    name = $prompt.ask("Let's create a board! What would you like to call it?")

    # Make sure the user inputs a name
    while name == nil
        name = $prompt.ask("Please enter a board name: ")
    end
    
    # Create the board and inform the user
    board = Board.new(name)
    puts "Your new board #{board.title.upcase} was created! (#{board.creation_date})".colorize(:green)
    
    # Set the current board to be the newly created board
    $state["current board"] = board

end

# Handle list creation
def create_list

    # Prompt the user to create as many lists as they like
    add_list = $prompt.select(
        "Would you like to add some lists to #{$state["current board"].title.upcase}", 
        {"Yes" => true, "No" => false})

    while add_list
        # Get the list name from the user
        list_name = $prompt.ask("Enter a name for you list: ")

        # Set a limit for the number of cards
        card_limits = [
            "No",
            3,
            5,
            10,
            "Custom" 
        ]

        # Check with the user if they want to limit how many cards can be added to the list
        card_limit = $prompt.select(
            "Would you like to set a limit for the number of cards you can add to this list?", 
            card_limits)

        if card_limit == "Custom"
            card_limit = $prompt.ask("Enter a custom card limit: ").to_i
        elsif card_limit == "No"
            card_limit = false
        end
    
        # Create the list and add it the currently active board
        $state["current board"].add_list(List.new(list_name, card_limit))

        # Check if the user would like to add another list
        add_list = $prompt.select(
            "Would you like to add more lists to #{$state["current board"].title.upcase}", 
            {"Yes" => true, "No" => false})
    end
end

# Prompt the user to create a card and 
# then add it to the chosen list
def create_card
    # If there are no lists then warn the user
    if $state["current board"].lists.empty?
        puts "You must create a list before you can add cards".colorize(:red)
        return
    end

    # Prompt the user to create cards and add them to lists
    add_card = $prompt.select(
        "Would you like to add some cards to your lists?", 
        {"Yes" => true, "No" => false})

    while add_card
        # Check which list to add the card to
        lists = $state["current board"].lists.keys
        add_to_list = $prompt.select("Which list would you like to add the card to?", lists)
        
        # Prompt the user for a description of their card
        card_desc = $prompt.ask("Enter a description for your card: ")
    
        # Create the card and add it to the given list
        card = Card.new(card_desc)
        $state["current board"].lists[add_to_list].add_card(card)
        add_card = $prompt.select("Would you like to add some cards to your lists?", {"Yes" => true, "No" => false})
    end

end

# Handle displaying the initial welcome screen
def display_welcome_screen
    system "echo 'Welcome to Kan-CLI' | figlet | lolcat"
    
    welcome_choices = ["Sign Up", "Exit"]
    welcome_choice = $prompt.select("What do you want to do?", welcome_choices)
    
    if welcome_choice == "Exit"
        exit
    elsif welcome_choice == "Sign Up"
        sign_up
    end
end

# Handle moving a card to a different list
def move_card
    # If there are no lists, there are no cards
    if $state["current board"].lists.empty?
        puts "There are no cards to move".colorize(:red)
        display_menu
    end

    # Check all the lists, if there are no cards display an error
    empty_lists = 0
    for list in $state["current board"].lists.values
        if list.cards.empty?
            empty_lists += 1
        end
    end
    if empty_lists == $state["current board"].lists.length
        
        puts "There are no cards to move".colorize(:red)
        display_menu
    end

    from_list = nil

    # Prompt the user to select which card to move => returns a card object
    card_to_move = $prompt.select("Which card would you like to move?") do |menu|
        # Itereate through each list in the board
        for list in @lists.values
            # Print the cards within the list
            for card in list.cards.values
                menu.choice("[#{list.title}]: #{card.description}", {"card" => card, "list" => list})
            end
        end
    end

    from_list = card_to_move["list"]

    # prompt the user to select which list to move it to => returns a list object
    to_list = $prompt.select("which list would you like to move to?") do |menu|
        for list in @lists.values
            menu.choice("#{list.title}", list)
        end
    end

    # Check the card is not being moved to itself
    if !(from_list == to_list)
        # Move the card - adds the card to the new list if there is room, then deletes from the old list if the add was succesfull
        added_successfully = to_list.add_card(card_to_move["card"])
        if added_successfully
            from_list.delete_card(card_to_move["card"])
        end
    end

    # Show the user their updated board
    display_board
end

# Show the main menu to the user
def display_menu
    # Define the menu
    menu = $prompt.select("What next?") do |menu|
        menu.default 1
      
        menu.choice 'Add a List', 1
        menu.choice 'Add a Card', 2
        menu.choice 'Move card', 3
        menu.choice 'Exit', 4
      end

    # Handle user input
    case menu
    when 1
        input_loop("list")
    when 2
        input_loop("card")
    when 3
        move_card
    when 4
        exit
    end
end

# Define the loop for getting user input
# This runs when the user adds any new components (boards, lists or cards)
def input_loop(start_position)

    # Start the loop at a given position
    if start_position == "board"
        create_board
        create_list
        create_card
    elsif start_position == "list"
        create_list
        create_card
    elsif start_position == "card"
        create_card
    end

    # Show the user their updated board
    $state["current board"].display_board
end

# Start the application
def init
    display_welcome_screen
    input_loop("board")
end

init

# Debugging 
# p $state