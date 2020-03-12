require 'colorize'
require 'colorized_string'

class List
    attr_accessor :title, :cards, :card_limit

    def initialize(title, card_limit=false)
        @title = title
        @card_limit = card_limit
        @cards = {} # A dictionary to contain the cards, the key will be the card id
    end

    # A method for adding cards to a list
    def add_card(card)
        # First check if there is a limit set, if there is then
        # make sure there is enough room to add the card, otherwise
        # return an error message
        if @card_limit && @cards.length < @card_limit || !@card_limit
            @cards[card.id] = card
            puts "Succesfully added card to #{@title}".colorize(:green)
            return true
        elsif @card_limit && @cards.length >= @card_limit
            puts "Card not added. You have reached the card limit for this list.".colorize(:red)
            return false
        else
            puts "There was an error adding your card".colorize(:red)
            return false
        end
    end

    # A method for deleting a card from a list
    def delete_card(card)
        @cards.delete(card.id)
    end
end