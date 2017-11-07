class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :products
  has_many :appointments

  def self.search(search)
  	if search
  		where(["
  						first_name iLIKE ? 
  						OR last_name iLIKE ? 
  						OR phone LIKE ? 
  						OR email iLIKE ?", 
  						"%#{search + '%'}", 
  						"%#{search + '%'}", 
  						"%#{search + '%'}", 
  						"%#{search + '%'}"
  					])
  	else
  		all
  	end
  end
end
