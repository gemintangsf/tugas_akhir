class NonBeasiswa < ApplicationRecord
  has_one :pengaju_bantuan
  
  validates :nama_penerima, presence: true
  validates :no_identitas_penerima, presence: true
  validates :no_telepon_penerima, presence: true
  validates :bukti_butuh_bantuan, presence: true
  validates :kategori, presence: true
  validates_inclusion_of :kategori, in: %w(Medis Bencana Duka), message: "harus Medis/Bencana/Duka!"
end
