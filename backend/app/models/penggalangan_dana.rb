class PenggalanganDana < ApplicationRecord
  belongs_to :donasi
  belongs_to :pengaju_bantuan

  validates :total_pengajuan, presence: true
  validates :total_nominal_terkumpul, presence: true
end
