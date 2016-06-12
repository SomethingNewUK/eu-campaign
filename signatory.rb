class Signatory
  include Mongoid::Document
  field :twitter_id, type: Integer
  field :facebook_id, type: Integer
  field :name, type: String
  field :nickname, type: String  
  field :image, type: String
  field :url, type: String
  
  def self.create_or_update_from_twitter(auth_data)
    # Create data hash
    data = {
      twitter_id: auth_data['uid'],
      name:       auth_data['info']['name'],
      nickname:   auth_data['info']['nickname'],    
      image:      auth_data['info']['image'],
      url:        auth_data['info']['urls']['Twitter'],
    }
    # Store signature
    s = Signatory.find_by(twitter_id: data[:twitter_id])
    if s
      s.update_attributes!(data)
    else
      s = Signatory.create(data)
    end
  end
  
  def self.create_or_update_from_facebook(auth_data)
    # Create data hash
    data = {
      facebook_id: auth_data['uid'],
      name:        auth_data['info']['name'],
      image:       auth_data['info']['image'],
      url:         auth_data['info']['urls']['Facebook'],
    }
    # Store signature
    s = Signatory.find_by(facebook_id: data[:facebook_id])
    if s
      s.update_attributes!(data)
    else
      s = Signatory.create(data)
    end
  end

end

