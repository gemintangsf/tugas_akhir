class Penggalangan::Donasi
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  
  belongs_to :penggalangan_dana, class_name: "Penggalangan::PenggalanganDana"
  belongs_to :donatur, class_name: "User::Donatur"

  validates :nominal, presence: true
  validates :nama_pemilik_rekening, presence: true
  validates :nomor_referensi, presence: true

  field :nominal, type: Integer
  field :nama_pemilik_rekening, type: String
  field :struk_pembayaran, type: String
  field :nomor_referensi, type: String
  field :waktu_berakhir, type: Time
  field :status, type: Integer

  scope :new_donation, -> { where(status: Enums::StatusDonasi::NEW)}
  scope :expired, -> { where(status: Enums::StatusDonasi::EXPIRED)}
  scope :approved, -> { where(status: Enums::StatusDonasi::APPROVED)}
end
  