module Users
  class CategorySerializer
    include JSONAPI::Serializer
    attributes :name
  end
end
