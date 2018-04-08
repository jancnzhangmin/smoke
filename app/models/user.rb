class User < ApplicationRecord
  has_many :childrens, class_name: "User", foreign_key: "up_id"
  belongs_to :parent, class_name: "User", foreign_key: "up_id", optional: true
  has_and_belongs_to_many :devices
end
