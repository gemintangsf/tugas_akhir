class Rekening < ApplicationRecord
  validates :nama_bank, presence: true
  validates :nomor_rekening, presence: true
  validates :nama_pemilik_rekening, presence: true
end
