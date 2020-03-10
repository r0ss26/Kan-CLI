class Board(title)
    attr_accessor :title, :creation_date, :lists

    def initialize(title)
        @title = title
        @creation_date = Time.new
        @lists = {}
    end

    # Takes a list and adds it to the board
    def add_list(list)
        @lists[list.title] = list
    end

    # Deletes a given list
    def delete_list(list)
        @lists[list.title].delete(list.title)
    end
end