# Require Classes
require_relative "Classes/Board.rb"
require_relative "Classes/Card.rb"
require_relative "Classes/List.rb"

# Require Gems
require 'figlet'
require 'lolcat'
require 'tty-prompt'
require 'cli/ui'

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
            wip_limit = false
        end
    
        # Create the list and add it the given board
        $state["current board"].add_list(List.new(list_name, wip_limit))

        add_list = $prompt.select("Would you like to add more lists to #{$state["current board"].title.upcase}", {"Yes" => true, "No" => false})

    end

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
        $state["current board"].lists[add_to_list].add_card(card)
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

def move_card
    from_list = nil
    # Prompt the user to select which card to move
    card_to_move = $prompt.select("Which card would you like to move?") do |menu|
        # Itereate through each list in the board
        for list in @lists.values
            for card in list.cards.values
                from_list = list.title
                menu.choice "#{card.description}", card
            end
        end
    end

    # prompt the user to select which list to move it to
    to_list = $prompt.select("which list would you like to move to?") do |menu|
        for list in @lists.values
            menu.choice "#{list.title}", list
        end
    end

    # add the card to the new list
    to_list.add_card(card_to_move)

    # delete the card
    $state["current board"].lists[from_list].delete_card(card_to_move)


end

def display_menu

    menu = $prompt.select("What next?") do |menu|
        menu.default 3
      
        menu.choice 'Add a List', 1
        menu.choice 'Add a Card', 2
        menu.choice 'Exit', 3
        menu.choice 'Move card', 4
      end

    case menu
    when 1
        input_loop("list")
    when 2
        input_loop("card")
    when 3
        return 1
    when 4
        move_card
    end

    input_loop("card")
end


def init
    display_welcome_screen
    input_loop("board")
end

def input_loop(start_position)
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

    $state["current board"].display_board
    display_menu
end

init

p $state