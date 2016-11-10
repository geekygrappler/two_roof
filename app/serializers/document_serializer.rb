class DocumentSerializer < ActiveModel::Serializer
    attributes :id, :title
    has_many :line_items
end
