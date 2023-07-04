class User::Donatur
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Attributes::Dynamic
    include ActiveModel::SecurePassword

    has_many :donasi, class_name: "Penggalangan::Donasi"
  
    validates :nama, presence: true
    validates :nomor_telepon, presence: true
    has_secure_password
    validates :password, length: {minimum: 8 }, if: -> { new_record? || password.nil? }
  
    field :nama, type: String
    field :nomor_telepon, type: String
    field :password_digest, :type => String
    field :status, type: Boolean
    
    scope :donatur_registered, -> { where(status: 1)}
  end
  