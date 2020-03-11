require 'tty-box'

class Board
    attr_accessor :title, :creation_date, :lists

    def initialize(title)
        @title = title
        @creation_date = Time.new
        @lists = {} # A hash to contain the lists, the key will be the list title, and the value will be the list object
    end

    # Takes a list and adds it to the board
    def add_list(list)
        @lists[list.title] = list
    end

    # Deletes a given list from the board
    def delete_list(list)
        @lists[list.title].delete(list.title)
    end

    # A method for displaying the board
    def display_board
        system "clear"
        
        # Itereate through each list in the board
        for list in @lists.values
            # Store the card description in an array used to print to the user
            card_descriptions = []
            for card in list.cards.values
                card_descriptions.push(card.description)
            end

            # Use a TTY Box to represent a list visually
            print TTY::Box.frame(width: 30, height: (list.cards.values.length + 1) * 2, title: {top_left: "#{list.title}"}) { card_descriptions.join("\n") }
        end

        display_menu
    end
end