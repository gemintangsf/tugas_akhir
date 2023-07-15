class Penggalangan::PenggalanganDana
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  
  belongs_to :pengajuan_bantuan, class_name: "Pengajuan::PengajuanBantuan", optional: true
  belongs_to :donasi, class_name: "Penggalangan::Donasi", optional: true

  validates :total_pengajuan, presence: true
  validates :total_nominal_terkumpul, presence: true

  field :total_pengajuan, type: Integer
  field :total_nominal_terkumpul, type: Integer
end
  