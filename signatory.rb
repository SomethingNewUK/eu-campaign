class Signatory
  include Mongoid::Document
  field :twitter_id, type: Integer
  field :facebook_id, type: Integer
  field :name, type: String
  field :nickname, type: String  
  field :image, type: String
  field :url, type: String
  
  def self.create_from_twitter(auth_data)
    # Store signature
    if Signatory.find_by(twitter_id: auth_data['uid']).nil?
      s = Signatory.create( 
        twitter_id: auth_data['uid'],
        name:       auth_data['info']['name'],
        nickname:   auth_data['info']['nickname'],    
        image:      auth_data['info']['image'],
        url:        auth_data['info']['urls']['Twitter'],
      )
    end
  end
  
  def self.create_from_facebook(auth_data)
    # Store signature
    if Signatory.find_by(facebook_id: auth_data['uid']).nil?
      s = Signatory.create( 
        facebook_id: auth_data['uid'],
        name:        auth_data['info']['name'],
        image:       auth_data['info']['image'],
        url:         auth_data['info']['urls']['Facebook'],
      )
    end
  end

end

