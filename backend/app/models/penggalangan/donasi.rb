class Penggalangan::Donasi
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  
  has_many :penggalangan_dana, class_name: "Penggalangan::PenggalanganDana"
  has_many :donatur, class_name: "User::Donatur"

  validates :nominal, presence: true
  
  field :nominal, type: Integer
  field :struk_pembayaran, type: String
  field :nomor_referensi, type: String
  field :waktu_berakhir, type: Time
  field :status, type: Integer

  scope :new_donation, -> { where(status: Enums::StatusDonasi::NEW)}
  scope :expired, -> { where(status: Enums::StatusDonasi::EXPIRED)}
  scope :approved, -> { where(status: Enums::StatusDonasi::APPROVED)}
end
  