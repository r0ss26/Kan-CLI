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
end