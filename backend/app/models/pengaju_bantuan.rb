class PengajuBantuan < ApplicationRecord
  belongs_to :beasiswa
  belongs_to :non_beasiswa
  belongs_to :rekening
  has_many :penggalangan_dana

  validates :nama, presence: true
  validates :no_identitas_pengaju, presence: true
  validates :no_telepon, presence: true
  validates :waktu_galang_dana, presence: true
  validates :judul_galang_dana, presence: true
  validates :deskripsi, presence: true
  validates :dana_yang_dibutuhkan, presence: true
  validates :jenis, presence: true
  validates_inclusion_of :jenis, in: %w(Beasiswa NonBeasiswa), message: "harus Beasiswa/NonBeasiswa!"

  scope :pengajuan_baru, -> { where(status_pengajuan: Enums::StatusPengajuan::NEW).union.in(status_penyaluran: Enums::StatusPenyaluran::NULL)}
  scope :pengajuan_approved, -> { where(status_pengajuan: Enums::StatusPengajuan::APPROVED)}
  scope :penggalangan_dana, -> { 
    where(status_pengajuan: Enums::StatusPengajuan::APPROVED).union.in(
      status_pengajuan: Enums::StatusPengajuan::ADMIN
      )
    }
  scope :rekapitulasi_beasiswa, -> { 
    where(status_pengajuan: Enums::StatusPengajuan::APPROVED).union.in(
      status_pengajuan: Enums::StatusPengajuan::DONE).union.in(
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
  scope :penyaluran_non_beasiswa, -> { where(status_pengajuan: Enums::StatusPengajuan::DONE).union.in(status_penyaluran: Enums::StatusPenyaluran::PENDING) }
  scope :penyaluran_beasiswa, -> { where(status_pengajuan: Enums::StatusPengajuan::APPROVED).union.in(
    status_pengajuan: Enums::StatusPengajuan::DONE).union.in(
      status_penyaluran: Enums::StatusPenyaluran::NEW).union.in(
        status_penyaluran: Enums::StatusPenyaluran::PENDING)
    }
  scope :done, -> { where(status_pengajuan: Enums::StatusPengajuan::DONE).union.in(status_penyaluran: Enums::StatusPenyaluran::DELIVERED) }
  scope :pengajuan_baru_admin, -> { where(status_pengajuan: Enums::StatusPengajuan::ADMIN).union.in(status_penyaluran: Enums::StatusPenyaluran::NULL)}
  scope :pengajuan_done_admin, -> { where(status_pengajuan: Enums::StatusPengajuan::DONE).union.in(status_penyaluran: Enums::StatusPenyaluran::NULL)}
  scope :batch_beasiswa, -> { 
    where(status_pengajuan: Enums::StatusPengajuan::ADMIN).union.in(
      status_pengajuan: Enums::StatusPengajuan::DONE).union.in(
      status_penyaluran: Enums::StatusPenyaluran::NULL)}
end
