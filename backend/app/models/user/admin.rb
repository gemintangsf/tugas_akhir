class User::Admin
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  include ActiveModel::SecurePassword

  validates :nama, presence: true
  validates :role, presence: true
  validates :username, presence: true
  validates :nomor_rekening, presence: true
  has_secure_password
  validates :password, length: {minimum: 8 }, if: -> { new_record? || password.nil? }
  validates :nomor_telepon, presence: true

  field :nama, type: String
  field :role, type: String
  field :username, type: String
  field :nomor_rekening, type: String
  field :password_digest, :type => String
  field :nomor_telepon, type: String
end
