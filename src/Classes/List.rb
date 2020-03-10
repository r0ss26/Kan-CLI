class List
    attr_accessor :title, :cards, :wip_limit

    # A wip_limit of zero (or any negative number) will return false 
    # and means there is no limit to the number of cards that can be added
    def initialize(title, wip_limit=0)
        @title = title
        @wip_limit = wip_limit
        @cards = {} # A dictionary to contain the cards, the key will be the card id
    end

    # A method for adding cards to a list
    def add_card(card)

        # First check if there is a limit set, if there is then
        # make sure there is enough room to add the card, otherwise
        # return an error message
        if @wip_limit && @cards.length < @wip_limit
            @cards[card.title] = card
            return "Succesfully added #{card.title} to #{@title}"
        elsif @wip_limit && @cards.length >= @wip_limit
            return "Card not added. You have reached the WIP limit for this list."
        else
            return "There was an error adding your card"
        end
    end

    # A method for deleting a card from a list
    def delete_card(card)
        @cards[card.desc].delete(card.title)
    end

end