class Donasi < ApplicationRecord
  has_many :penggalangan_dana
  has_many :donatur

  validates :nominal, presence: true

  scope :new_donation, -> { where(status: Enums::StatusDonasi::NEW)}
  scope :expired, -> { where(status: Enums::StatusDonasi::EXPIRED)}
  scope :approved, -> { where(status: Enums::StatusDonasi::APPROVED)}
end
