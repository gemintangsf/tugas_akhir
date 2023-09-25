class Beasiswa < ApplicationRecord
    has_one :pengaju_bantuan

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
end
