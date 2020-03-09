class Board(title)
    attr_accessor :title, :creation_date, :lists

    def initialize(title)
        @title = title
        @creation_date = Time.new
        @lists = []
    end

    def add_list(list)
        # TODO
    end

    def delete_board()
        # TODO
    end

end

class List(title)
    attr_accessor :title, :cards

    def initialize(title)
        @title = title
        @cards = {}
    end

    def add_card(card)

    end

end