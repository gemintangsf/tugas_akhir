# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_09_25_091354) do

  create_table "admins", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nama"
    t.string "role"
    t.string "username"
    t.string "password_digest"
    t.string "nomor_telepon"
    t.bigint "rekening_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rekening_id"], name: "index_admins_on_rekening_id"
  end

  create_table "beasiswas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "golongan_ukt"
    t.string "kuitansi_pembayaran_ukt"
    t.integer "gaji_orang_tua"
    t.string "bukti_slip_gaji_orang_tua"
    t.string "esai"
    t.integer "jumlah_tanggungan_keluarga"
    t.string "biaya_transportasi"
    t.string "biaya_konsumsi"
    t.string "biaya_internet"
    t.string "biaya_kost"
    t.integer "total_pengeluaran_keluarga"
    t.integer "penilaian_esai"
    t.integer "nominal_penyaluran"
    t.json "bulan_penyaluran"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "civitas_akademikas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nama"
    t.string "nomor_induk"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "donasis", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "nominal_donasi"
    t.string "struk_pembayaran"
    t.string "nomor_referensi"
    t.time "waktu_berakhir"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "donaturs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nama"
    t.string "nomor_telepon"
    t.string "password_digest"
    t.boolean "status"
    t.bigint "rekening_id", null: false
    t.bigint "donasi_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["donasi_id"], name: "index_donaturs_on_donasi_id"
    t.index ["rekening_id"], name: "index_donaturs_on_rekening_id"
  end

  create_table "non_beasiswas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nama_penerima"
    t.string "no_identitas_penerima"
    t.string "no_telepon_penerima"
    t.string "bukti_butuh_bantuan"
    t.string "kategori"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pengaju_bantuans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nama"
    t.string "no_identitas_pengaju"
    t.string "no_telepon"
    t.string "waktu_galang_dana"
    t.string "judul_galang_dana"
    t.string "deskripsi"
    t.string "dana_yang_dibutuhkan"
    t.string "jenis"
    t.integer "status_pengajuan"
    t.integer "status_penyaluran"
    t.bigint "beasiswa_id", null: false
    t.bigint "non_beasiswa_id", null: false
    t.bigint "rekening_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["beasiswa_id"], name: "index_pengaju_bantuans_on_beasiswa_id"
    t.index ["non_beasiswa_id"], name: "index_pengaju_bantuans_on_non_beasiswa_id"
    t.index ["rekening_id"], name: "index_pengaju_bantuans_on_rekening_id"
  end

  create_table "penggalangan_danas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "total_pengajuan"
    t.integer "total_nominal_terkumpul"
    t.bigint "donasi_id", null: false
    t.bigint "pengaju_bantuan_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["donasi_id"], name: "index_penggalangan_danas_on_donasi_id"
    t.index ["pengaju_bantuan_id"], name: "index_penggalangan_danas_on_pengaju_bantuan_id"
  end

  create_table "rekenings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nama_bank"
    t.string "nomor_rekening"
    t.string "nama_pemilik_rekening"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "admins", "rekenings"
  add_foreign_key "donaturs", "donasis"
  add_foreign_key "donaturs", "rekenings"
  add_foreign_key "pengaju_bantuans", "beasiswas"
  add_foreign_key "pengaju_bantuans", "non_beasiswas"
  add_foreign_key "pengaju_bantuans", "rekenings"
  add_foreign_key "penggalangan_danas", "donasis"
  add_foreign_key "penggalangan_danas", "pengaju_bantuans"
end
