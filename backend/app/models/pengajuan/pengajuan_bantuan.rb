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
    field :status_pengajuan, type: Integer
    field :status_penyaluran, type: Integer

    scope :pengajuan_baru, -> { where(status_pengajuan: Enums::StatusPengajuan::NEW).union.in(status_penyaluran: Enums::StatusPenyaluran::NULL)}
    scope :penggalangan_dana, -> { where(status_pengajuan: Enums::StatusPengajuan::APPROVED)}
    scope :rekapitulasi_beasiswa, -> { 
      where(status_pengajuan: Enums::StatusPengajuan::APPROVED).union.in(
        status_penyaluran: Enums::StatusPenyaluran::NEW).union.in(
          status_penyaluran: Enums::StatusPenyaluran::PENDING).union.in(
            status_penyaluran: Enums::StatusPenyaluran::DELIVERED
          )
    }
    scope :rekapitulasi_non_beasiswa, -> { 
      where(status_pengajuan: Enums::StatusPengajuan::DONE).union.in(
        status_penyaluran: Enums::StatusPenyaluran::PENDING).union.in(
            status_penyaluran: Enums::StatusPenyaluran::DELIVERED
          )
    }
    scope :done, -> { where(status_pengajuan: Enums::StatusPengajuan::DONE).union.in(status_penyaluran: Enums::StatusPenyaluran::DELIVERED) }
    scope :pengajuan_baru_admin, -> { where(status_pengajuan: Enums::StatusPengajuan::ADMIN).union.in(status_penyaluran: Enums::StatusPenyaluran::NULL)}
  end
  