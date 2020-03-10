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

    # Deletes a given list
    def delete_list(list)
        @lists[list.title].delete(list.title)
    end

    # A method for displaying the board
    def display_board
        # Itereate through each list in the board
        for list in @lists.values
            # Print the title to the user
            system "echo '#{list.title}' | lolcat" 
            # Loop through the cards in the list and print them to the user
            for card in list.cards.values
                puts card.description
            end
        end
    end



end