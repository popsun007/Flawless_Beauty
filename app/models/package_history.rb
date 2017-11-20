class PackageHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :package
end
