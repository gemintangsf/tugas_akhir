class PenggalanganDanaBeasiswa < ApplicationRecord
  self.table_name = 'penggalangandanabeasiswa'
  self.primary_key = 'penggalangan_dana_beasiswa_id'
  
  has_many :bantuan_dana_beasiswa, class_name: "BantuanDanaBeasiswa"
  has_many :donasi, class_name: "Donasi"
  belongs_to :penanggung_jawab, class_name: "PenanggungJawab"

  scope :on_going, -> { where(status: Enums::StatusPenggalanganDanaBeasiswa::ONGOING)}
end
