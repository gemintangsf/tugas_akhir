class RekapitulasiBeasiswa < ApplicationRecord
  self.table_name = 'rekapitulasibeasiswa'
  self.primary_key = 'batch'

  has_many :rekapitulasibeasiswa_has_donasi, class_name: "RekapitulasiBeasiswaHasDonasi"
  has_many :donasi, class_name: "Donasi", through: :rekapitulasibeasiswa_has_donasi
end
