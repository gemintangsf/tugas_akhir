class Donatur < ApplicationRecord
  belongs_to :rekening
  belongs_to :donasi

  validates :nama, presence: true
  validates :nomor_telepon, presence: true

  has_secure_password
  validates :password, length: {minimum: 8 }, if: -> { new_record? || password.nil? }  
end
