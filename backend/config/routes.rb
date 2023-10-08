Rails.application.routes.draw do
  resources :admins
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :v1 do
    resources :users, param: :username
    resource :authentication do
      post '/login', to: 'authentication#login'
    end
    
    resource :civitas_akademika do
      post '/importExcelCivitasAkademika' => "civitas_akademika#importExcelCivitasAkademika"
      get '/getAllCivitasAkademika' => "civitas_akademika#getAllCivitasAkademika"
      post '/search' => "civitas_akademika#search"
    end

    resource :rekapitulasi do
      post "/getRekapitulasiBeasiswa" => "rekapitulasi#getRekapitulasiBeasiswa"
      get "/getRekapitulasiNonBeasiswa" => "rekapitulasi#getRekapitulasiNonBeasiswa"
      post "/getApprovedDonasiByPenggalanganDana" => "rekapitulasi#getApprovedDonasiByPenggalanganDana"
      post "/selectPenyaluranBeasiswa" => "rekapitulasi#selectPenyaluranBeasiswa"
      post "/selectPenyaluranNonBeasiswa" => "rekapitulasi#selectPenyaluranNonBeasiswa"
      get "/getAllRekapitulasiBeasiswa" => "rekapitulasi#getAllRekapitulasiBeasiswa"
    end

    namespace :user do
      resource :admin do
        post "/createAdmin" => "admin#createAdmin"
        get "/getBankByAdmin" => "admin#getBankByAdmin"
      end
      resource :donatur do
        get "/getTotalDonatur" => "donatur#getTotalDonatur"
      end
    end
    namespace :pengajuan do
      resource :pengajuan_bantuan do
        get "getDurasiPengajuanBeasiswa" => "pengajuan_bantuan#getDurasiPengajuanBeasiswa"
        post "getPengajuanBantuan" => "pengajuan_bantuan#getPengajuanBantuan"
        post "getNonBeasiswaByKategori" => "pengajuan_bantuan#getNonBeasiswaByKategori"
        get "getLanjutBeasiswa" => "pengajuan_bantuan#getLanjutBeasiswa"
        post "getTotalCalonPengajuan" => "pengajuan_bantuan#getTotalCalonPengajuan"
        post "selectLanjutBeasiswa" => "pengajuan_bantuan#selectLanjutBeasiswa"
        post "/createPengajuanBeasiswa" => "pengajuan_bantuan#createPengajuanBeasiswa"
        post "/createPengajuanNonBeasiswa" => "pengajuan_bantuan#createPengajuanNonBeasiswa"
        post "/approvalPengajuanBeasiswa" => "pengajuan_bantuan#approvalPengajuanBeasiswa"
        post "/approvalPengajuanNonBeasiswa" => "pengajuan_bantuan#approvalPengajuanNonBeasiswa"
        post "/createPenilaianEsai" => "pengajuan_bantuan#createPenilaianEsai"
        get "/getTotalPenerimaBantuan" => "pengajuan_bantuan#getTotalPenerimaBantuan"
      end
    end
    namespace :penggalangan do
      resource :donasi do
        post "/getDonasiByPenggalanganDana" => "donasi#getDonasiByPenggalanganDana"
        post "/getDonasiByStatus" => "donasi#getDonasiByStatus"
        get "/getTotalAllDonasi" => "donasi#getTotalAllDonasi"
        get "/getTotalNewDonasi" => "donasi#getTotalNewDonasi"
        post "/createDonasi" => "donasi#createDonasi"
        post "/getPendingDonasi" => "donasi#getPendingDonasi"
        post "/uploadStrukPembayaran" => "donasi#uploadStrukPembayaran"
        post "/approvalDonasi" => "donasi#approvalDonasi"
        post "/search" => "donasi#search"
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
        post "/getDataDonaturByPenggalanganDana" => "penggalangan_dana#getDataDonaturByPenggalanganDana"
      end
    end
  end
end
