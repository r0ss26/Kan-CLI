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

# Prompt the user for a username and password
def sign_up

    #Prompt user for username and store
    username = $prompt.ask("Please enter a username: ") do |q|
        q.validate(/^[a-z0-9_-]{3,15}$/, "Your username must only contain a-z characters, numbers or dashes")
    end

    #Prompt user for password
    password = $prompt.mask("Please enter a password: ") do |q|
        q.validate(/^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$/, "Your username must contain an uppercase letter, a lowercase letter, a number and a special character.")
    end

    return {
        username => username,
        password => password
    }

end

def create_board

    # Prompt the user for a name
    name = $prompt.ask("Let's create your first board! What would you like to call it?")
    board = Board.new(name)
    puts "Your new board #{board.title.upcase} was created at #{board.creation_date}"
    return board
    
end

def create_lists(board)

    lists = $prompt.select("Would you like to add some lists to #{board.title}", ["Yes", "No"])

end

def init

    # Welcome screen
    system "echo 'Welcome to Kan-CLI' | figlet | lolcat"

    welcome_choices = ["Sign Up", "Exit"]
    welcome_choice = $prompt.select("What do you want to do?", welcome_choices)
    
    if welcome_choice == "Exit"
        return 1
    elsif welcome_choice == "Sign Up"
        sign_up
    end
    
    # Prompt the user to create a Board
    create_board

    # Prompt the user to create lists


    # Prompt the user to create cards and add them to lists
    

end

init


# puts "What would you like to call your board?"
# board_name = gets.chomp
# new_board = Board.new(board_name)

# p new_board

# puts "Congratulations, you created a new board named #{new_board.title}"

# puts "would you like to add a list?"

# create_list = gets.chomp

# while create_list
#     puts "Create a new list called: "
#     new_list_name = gets.chomp
    
#     puts "Would you like to limit the number of card in #{new_list_name}? Enter NO or a number to limit to"
#     response = gets.chomp
#     if response != "NO"
#         wip_limit = response
#     end

#     new_list = List.new(new_list_name, wip_limit)
# end

# p new_list