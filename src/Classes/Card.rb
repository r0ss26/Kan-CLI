require 'suid'

class Card
    attr_accessor :id, :description, :creation_date

    def initialize(description)
        @description = description
        @creation_date = creation_date
        @id = SUID.generate
    end
end