Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :v1 do
    resources :users, param: :username
    post '/login', to: 'authentication#login'
    
    post '/importExcelCivitasAkademika' => "civitas_akademika#importExcelCivitasAkademika"
    get '/getAllCivitasAkademika' => "civitas_akademika#getAllCivitasAkademika"
    namespace :user do
      resource :admin do
        post "/createAdmin" => "admin#createAdmin"
      end
      resource :donatur do
        get "/getTotalDonatur" => "donatur#getTotalDonatur"
      end
    end
    namespace :pengajuan do
      resource :pengajuan_bantuan do
        get "getDurasiPengajuanBeasiswa" => "pengajuan_bantuan#getDurasiPengajuanBeasiswa"
        post "getPengajuan" => "pengajuan_bantuan#getPengajuan"
        post "getPenerimaBantuanDana" => "pengajuan_bantuan#getPenerimaBantuanDana"
        post "getPenerimaNonBeasiswaByKategori" => "pengajuan_bantuan#getPenerimaNonBeasiswaByKategori"
        get "getLanjutBeasiswa" => "pengajuan_bantuan#getLanjutBeasiswa"
        post "getTotalCalonPengajuan" => "pengajuan_bantuan#getTotalCalonPengajuan"
        post "selectLanjutBeasiswa" => "pengajuan_bantuan#selectLanjutBeasiswa"
        post "getPengajuanNonBeasiswaByKategori" => "pengajuan_bantuan#getPengajuanNonBeasiswaByKategori"
        post "/createPengajuanBeasiswa" => "pengajuan_bantuan#createPengajuanBeasiswa"
        post "/createPengajuanNonBeasiswa" => "pengajuan_bantuan#createPengajuanNonBeasiswa"
        post "/selectPengajuanBeasiswa" => "pengajuan_bantuan#selectPengajuanBeasiswa"
        post "/selectPengajuanNonBeasiswa" => "pengajuan_bantuan#selectPengajuanNonBeasiswa"
        post "/createPenilaianEsai" => "pengajuan_bantuan#createPenilaianEsai"
        post "/getRekapitulasiBeasiswa" => "pengajuan_bantuan#getRekapitulasiBeasiswa"
        get "/getRekapitulasiNonBeasiswa" => "pengajuan_bantuan#getRekapitulasiNonBeasiswa"
        get "/getRekapitulasiBeasiswa" => "pengajuan_bantuan#getRekapitulasiBeasiswa"
        post "/selectPenyaluranNonBeasiswa" => "pengajuan_bantuan#selectPenyaluranNonBeasiswa"
        post "/selectPenyaluranBeasiswa" => "pengajuan_bantuan#selectPenyaluranBeasiswa"
        get "/getTotalPenerimaBantuan" => "pengajuan_bantuan#getTotalPenerimaBantuan"
      end
    end
    namespace :penggalangan do
      resource :donasi do
        post "/getDonasiByPenggalanganDana" => "donasi#getDonasiByPenggalanganDana"
        get "/getAllApprovedDonasi" => "donasi#getAllApprovedDonasi"
        get "/getAllNewDonasi" => "donasi#getAllNewDonasi"
        get "/getTotalAllDonasi" => "donasi#getTotalAllDonasi"
        get "/getTotalNewDonasi" => "donasi#getTotalNewDonasi"
        post "/createDonasi" => "donasi#createDonasi"
        post "/getDurasiDonasi" => "donasi#getDurasiDonasi"
        post "/uploadStrukPembayaran" => "donasi#uploadStrukPembayaran"
        post "/approvalDonasi" => "donasi#approvalDonasi"
      end
      resource :penggalangan_dana do
        post "/createPenggalanganDanaBeasiswa" => "penggalangan_dana#createPenggalanganDanaBeasiswa"
        post "/createPenggalanganDanaNonBeasiswa" => "penggalangan_dana#createPenggalanganDanaNonBeasiswa"
        post "/getPenggalanganDanaNonBeasiswaByKategori" => "penggalangan_dana#getPenggalanganDanaNonBeasiswaByKategori"
        post "/selectPenggalanganDana" => "penggalangan_dana#selectPenggalanganDana"
        get "/getAllPenggalanganDana" => "penggalangan_dana#getAllPenggalanganDana"
        get "/getTotalPenggalanganDana" => "penggalangan_dana#getTotalPenggalanganDana"
        post "/getDurasiPenggalanganDana" => "penggalangan_dana#getDurasiPenggalanganDana"
        post "/getNominalTerkumpulPenggalanganDana" => "penggalangan_dana#getNominalTerkumpulPenggalanganDana"
        post "/getTotalDonaturInPenggalanganDana" => "penggalangan_dana#getTotalDonaturInPenggalanganDana"
        get "/getTotalDonatur" => "penggalangan_dana#getTotalDonatur"
        post "/getDataDonaturByPenggalanganDana" => "penggalangan_dana#getDataDonaturByPenggalanganDana"
        post "/getSaldoAwal" => "penggalangan_dana#getSaldoAwal"
        post "getTotalPengeluaran" => "penggalangan_dana#getTotalPengeluaran"
        post "getSaldoAkhir" => "penggalangan_dana#getSaldoAkhir"
        post "/getApprovedDonasiByPenggalanganDana" => "penggalangan_dana#getApprovedDonasiByPenggalanganDana"
      end
    end
    namespace :rekapitulasi do
      resource :rekapitulasi do
        post "/getRekapitulasiDanaBeasiswa" => "rekapitulasi#getRekapitulasiDanaBeasiswa"
        post "/getTotalPengeluaran" => "rekapitulasi#getTotalPengeluaran"
        post "/getSaldoAkhir" => "rekapitulasi#getSaldoAkhir"
        post "/getApprovedDonasiByPenggalanganDana" => "rekapitulasi#getApprovedDonasiByPenggalanganDana"
        get "/getRekapitulasiDanaNonBeasiswa" => "rekapitulasi#getRekapitulasiDanaNonBeasiswa"
      end
    end
  end
end
