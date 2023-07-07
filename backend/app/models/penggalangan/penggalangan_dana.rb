class Penggalangan::PenggalanganDana
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  
  belongs_to :pengajuan_bantuan, class_name: "Pengajuan::PengajuanBantuan"
  has_many :donasi, class_name: "Penggalangan::Donasi"

  validates :total_pengajuan, presence: true
  validates :total_nominal_terkumpul, presence: true

  field :total_pengajuan, type: Integer
  field :total_nominal_terkumpul, type: Integer
end
  