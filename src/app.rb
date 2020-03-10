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
figlet = Figlet::Typesetter.new(font)

# TTY-prompt Configuration
$prompt = TTY::Prompt.new

# Store all of the users boards in the form
# title => board object
$state = {
    "user" => {},
    "boards" => {},
    "current board" => nil
}

# Handle user sign up
def sign_up

    #Prompt user for username and store
    username = $prompt.ask("Please enter a username: ") do |q|
        q.validate(/^[a-z0-9_-]{3,15}$/, "Your username must only contain a-z characters, numbers or dashes")
    end

    #Prompt user for password
    password = $prompt.mask("Please enter a password: ") do |q|
        q.validate(/^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$/, "Your username must contain an uppercase letter, a lowercase letter, a number and a special character.")
    end

    # Store the username and password in the state variable
    $state["user"]["username"] = username
    $state["user"]["pw"] = password

    create_board

end

# Handle board creation
def create_board

    # Prompt the user to create a Board
    name = $prompt.ask("Let's create a board! What would you like to call it?")

    # Create the board and inform the user
    board = Board.new(name)
    puts "Your new board #{board.title.upcase} was created! (#{board.creation_date})"

    $state["current board"] = board

    # Store the board in the state variable
    $state["boards"][board.title] = board

    create_list
end

# Handle list creation
def create_list

    # Prompt the user to create lists
    add_list = $prompt.select("Would you like to add some lists to #{$state["current board"].title.upcase}", {"Yes" => true, "No" => false})
    while add_list
        # create_list($state["current board"])
        # add_list = $prompt.select("Would you like to add another list to #{board.title.upcase}", {"Yes" => true, "No" => false})

        # Get the list name from the user
        list_name = $prompt.ask("Enter a name for you list: ")

        # Set a limit for the number of cards
        wip_limits = [
            "No",
            3,
            5,
            10,
            "Custom" 
        ]
    
        wip_limit = $prompt.select("Would you like to set a limit for the number of cards you can add to this list?", wip_limits)
        if wip_limit == "Custom"
            wip_limit = $prompt.ask("Enter a custom card limit: ").to_i
        elsif wip_limit == "No"
            wip_limit = 0
        end
    
        # Create the list and add it the given board
        $state["current board"].add_list(List.new(list_name, wip_limit))

        add_list = $prompt.select("Would you like to add more lists to #{$state["current board"].title.upcase}", {"Yes" => true, "No" => false})

    end

    create_card

end

# Create a card and add it to a given list
def create_card

    # Prompt the user to create cards and add them to lists
    add_card = $prompt.select("Would you like to add some cards to your lists?", {"Yes" => true, "No" => false})

    while add_card

        lists = $state["current board"].lists.keys

        add_to_list = $prompt.select("Which list would you like to add the card to?", lists)
        
        card_desc = $prompt.ask("Enter a description for your card: ")
    
        # Create the card and add it to the given list
        card = Card.new(card_desc)
        $state["current board"].lists[add_to_list]

        add_card = $prompt.select("Would you like to add some cards to your lists?", {"Yes" => true, "No" => false})
    end


end

def display_welcome_screen
    system "echo 'Welcome to Kan-CLI' | figlet | lolcat"
    
    welcome_choices = ["Sign Up", "Exit"]
    welcome_choice = $prompt.select("What do you want to do?", welcome_choices)
    
    if welcome_choice == "Exit"
        return 1
    elsif welcome_choice == "Sign Up"
        sign_up
    end
end

def init
    display_welcome_screen
end

init

p $state