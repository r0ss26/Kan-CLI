require 'colorize'
require 'colorized_string'

class List
    attr_accessor :title, :cards, :wip_limit

    # A wip_limit of zero (or any negative number) will return false 
    # and means there is no limit to the number of cards that can be added
    def initialize(title, wip_limit=false)
        @title = title
        @wip_limit = wip_limit
        @cards = {} # A dictionary to contain the cards, the key will be the card id
    end

    # A method for adding cards to a list
    def add_card(card)

        # First check if there is a limit set, if there is then
        # make sure there is enough room to add the card, otherwise
        # return an error message
        if @wip_limit && @cards.length < @wip_limit || !@wip_limit
            @cards[card.id] = card
            puts "Succesfully added card to #{@title}".colorize(:green)
            return true
        elsif @wip_limit && @cards.length >= @wip_limit
            puts "Card not added. You have reached the WIP limit for this list.".colorize(:red)
            return false
        else
            puts "There was an error adding your card".colorize(:red)
            return false
        end
    end

    # A method for moving a card
    def move_card(card, to_list) 

        # # Check if the destination has enough room
        # if to_list.cards.values.length == to_list.wip_limit 
        #     puts "#{to_list.title} has reached its card limit"
        # else

        #     # add the card to the new list
        #     to_list.add_card(card)

        #     # delete the card from the current list
        #     delete_card(card)
        
        # end
    end

    # A method for deleting a card from a list
    def delete_card(card)
        @cards.delete(card.id)
    end
end