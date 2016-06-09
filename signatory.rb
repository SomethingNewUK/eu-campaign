class Signatory
  include Mongoid::Document
  field :twitter_id, type: Integer
  field :name, type: String
  field :nickname, type: String  
  field :image, type: String
end

