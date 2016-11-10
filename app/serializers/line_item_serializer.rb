class LineItemSerializer < ActiveModel::Serializer
    attributes :id, :item_name, :quantity, :rate, :notes
end
