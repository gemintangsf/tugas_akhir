class Donasi < ApplicationRecord
  self.table_name = 'donasi'
  self.primary_key = 'nomor_referensi'

  belongs_to :penggalangan_dana_beasiswa, class_name: "PenggalanganDanaBeasiswa", optional: true
  belongs_to :bantuan_dana_non_beasiswa, class_name: "BantuanDanaNonBeasiswa", optional: true
  belongs_to :donatur, class_name: "Donatur"

  has_many :rekapitulasibeasiswa_has_donasi, class_name: "RekapitulasiBeasiswaHasDonasi"
  has_many :rekapitulasi_beasiswa, class_name: "RekapitulasiBeasiswa", through: :rekapitulasibeasiswa_has_donasi

  validates :nominal_donasi, presence: true

  scope :new_donation, -> { where(status: Enums::StatusDonasi::NEW)}
  scope :expired, -> { where(status: Enums::StatusDonasi::EXPIRED)}
  scope :approved, -> { where(status: Enums::StatusDonasi::APPROVED)}
end
