class Document < ApplicationRecord
    validates_presence_of  :title

    has_many :line_items
end
