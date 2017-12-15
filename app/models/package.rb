class Package < ActiveRecord::Base
  belongs_to :user
  has_many :package_histories
  accepts_nested_attributes_for :package_histories
end
