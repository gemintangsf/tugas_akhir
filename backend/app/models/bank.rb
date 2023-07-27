class Bank
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Attributes::Dynamic
    
    has_one :pengajuan_bantuan, class_name: "Pengajuan::PengajuanBantuan"
    has_one :admin, class_name: "User::Admin"
    has_one :donatur, class_name: "User::Donatur"
    
    validates :nama_bank, presence: true
    validates :nomor_rekening, presence: true
    validates :nama_pemilik_rekening, presence: true

    field :nama_bank, type: String
    field :nomor_rekening, type: String
    field :nama_pemilik_rekening, :type => String
end