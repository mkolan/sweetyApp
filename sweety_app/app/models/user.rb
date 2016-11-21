class User < ActiveRecord::Base
  acts_as_authentic
  enum user_type: [:patient, :doctor]
  has_many :sugar_readings, dependent: :destroy
end