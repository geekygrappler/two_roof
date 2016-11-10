class LineItem < ApplicationRecord
    validates_presence_of :item_name

    belongs_to :document
end
