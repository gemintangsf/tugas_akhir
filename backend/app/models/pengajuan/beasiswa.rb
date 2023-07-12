class Pengajuan::Beasiswa
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  
  has_one :pengajuan_bantuan, class_name: "Pengajuan::PengajuanBantuan"

  validates :golongan_ukt, presence: true
  validates :kuitansi_pembayaran_ukt, presence: true
  validates :gaji_orang_tua, presence: true
  validates :bukti_slip_gaji_orang_tua, presence: true
  validates :esai, presence: true
  validates :jumlah_tanggungan_keluarga, presence: true
  validates :biaya_transportasi, presence: true
  validates :biaya_konsumsi, presence: true
  validates :biaya_internet, presence: true
  validates :total_pengeluaran_keluarga, presence: true

  field :golongan_ukt, type: Integer
  field :kuitansi_pembayaran_ukt, type: String
  field :gaji_orang_tua, type: Integer
  field :bukti_slip_gaji_orang_tua, type: String
  field :esai, type: String
  field :jumlah_tanggungan_keluarga, type: Integer
  field :biaya_transportasi, type: String
  field :biaya_konsumsi, type: String
  field :biaya_internet, type: String
  field :biaya_kos, type: String
  field :total_pengeluaran_keluarga, type: Integer
  field :penilaian_esai, type: Integer
end
