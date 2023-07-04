class Pengajuan::PengajuanBantuan
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Attributes::Dynamic

    has_many :penggalangan_dana, class_name: "Penggalangan::PenggalanganDana"
    has_one :beasiswa, class_name: "Pengajuan::Beasiswa"
    has_one :non_beasiswa, class_name: "Pengajuan::NonBeasiswa"

    validates :nama, presence: true
    validates :no_identitas_pengaju, presence: true
    validates :no_telepon, presence: true
    validates :nomor_rekening, presence: true
    validates :nama_pemilik_rekening, presence: true
    validates :bank, presence: true
    validates :waktu_galang_dana, presence: true
    validates :judul_galang_dana, presence: true
    validates :deskripsi, presence: true
    validates :dana_yang_dibutuhkan, presence: true
    validates :jenis, presence: true
    validates_inclusion_of :jenis, in: %w(Beasiswa NonBeasiswa), message: "harus Beasiswa/NonBeasiswa!"

    field :nama, type: String
    field :no_identitas_pengaju, type: String
    field :no_telepon, type: String
    field :nomor_rekening, type: String
    field :nama_pemilik_rekening, type: String
    field :bank, type: String
    field :waktu_galang_dana, type: DateTime
    field :judul_galang_dana, type: String
    field :deskripsi, type: String
    field :dana_yang_dibutuhkan, type: Integer
    field :jenis, type: String
    field :status_pengajuan, type: String

    scope :pengajuan_baru, -> { where(status_pengajuan: "new")}
    scope :penggalangan_dana, -> { where(status_pengajuan: "approved")}
    scope :pengajuan, -> { where(status_pengajuan: "new") and where(status_pengajuan: "approved")}
    scope :penerima, -> { where(status_pengajuan: "approved") and where(status_pengajuan: "penyaluran") and where(status_pengajuan: "done")}
    scope :penyaluran, -> { where(status_pengajuan: "penyaluran")}
    scope :done, -> { where(status_pengajuan: "done")}
    scope :continue, -> { where(status_pengajuan: "continue")}
  end
  