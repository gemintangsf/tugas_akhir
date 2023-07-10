class Pengajuan::NonBeasiswa
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  
  belongs_to :pengajuan_bantuan, class_name: "Pengajuan::PengajuanBantuan"

  validates :nama_penerima, presence: true
  validates :no_identitas_penerima, presence: true
  validates :no_telepon_penerima, presence: true
  validates :bukti_butuh_bantuan, presence: true
  validates :kategori, presence: true
  validates_inclusion_of :kategori, in: %w(Medis Bencana Duka), message: "harus Medis/Bencana/Duka!"

  field :nama_penerima, type: String
  field :no_identitas_penerima, type: String
  field :no_telepon_penerima, type: String
  field :bukti_butuh_bantuan, type: String
  field :kategori, type: String
end
  