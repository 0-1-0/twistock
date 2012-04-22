class User
  include Mongoid::Document
  authenticates_with_sorcery!

  
end
