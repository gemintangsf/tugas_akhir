class Admin < ApplicationRecord
  belongs_to :rekening

  validates :nama, presence: true
  validates :role, presence: true
  validates :username, presence: true
  has_secure_password
  validates :password, length: {minimum: 8 }, if: -> { new_record? || password.nil? }
  validates :nomor_telepon, presence: true
end
