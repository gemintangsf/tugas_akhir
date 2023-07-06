import React from 'react';
import './App.css';
import { Routes, Route } from 'react-router-dom';
// import { ThemeProvider } from '@emotion/react';
import Dashboard from './views_adm/DashboardAdmin';
import CalonPenerimaBeasiswa from './views_adm/CalonPenerimaBeasiswa';
import CalonPenerimaNonBeasiswa from './views_adm/CalonPenerimaNonBeasiswa';
import LaporanRekapitulasiBeasiswa from './views_adm/LaporanRekapitulasiBesiswa';
import LaporanRekapitulasiNonBeasiswa from './views_adm/LaporanRekapitulasiNonBeasiswa';
import Login from './views_adm/Login';
import Beranda from './views_user/Beranda';
import PenggalanganDana from './views_user/PenggalanganDana'
import DaftarPenggalanganDana from './views_user/DaftarPenggalanganDana';
import PenerimaDana from './views_adm/PenerimaDana';
import PenerimaBeasiswa from './views_adm/PenerimaBeasiswa'
import PenerimaNonBeasiswa from './views_adm/PenerimaNonBeasiswa'
import Layout from './components/layout';
import DataDiri from './views_user/form_donasi/DataDiri';
import UploadPembayaran from './views_user/form_donasi/UploadBukti';
import IdentitasMahasiswa from './views_user/form_beasiswa/DataDiri'
import PersyaratanView from './views_user/form_beasiswa/Persyaratan';
import IdentitasPenerimaBantuan from './views_user/form_non_beasiswa/DataDiri';
import IdentitasPenanggungJawab from './components/form/form_nonbeasiswa/DataDiriPenanggungJawab';
import PersyaratanBencanaViews from './views_user/form_non_beasiswa/PersyaratanBencana';
import GalangDanaViews from './views_user/form_non_beasiswa/InfoGalangDana';
import PersyaratanMedisViews from './views_user/form_non_beasiswa/PersyaratanMedis';
import LayoutUser from './components/layout_user';
import DaftarPenggalanganDanaMedis from './views_user/DaftarPenggalanganDanaMedis';
import DaftarPenggalanganDanaBeasiswa from './views_user/DaftarPenggalanganDana';
import DaftarPenggalanganDanaBencana from './views_user/DaftarPenggalanganDanaBencana';
import LaporanRekapitulasiDonasi from './views_adm/DaftarDonasi';
// import Item from '@mui/material';

function App() {
	return (
		<React.Fragment>
			<Routes>
				<Route path='/login' element={<Login />}></Route>
				<Route path='/' element={<Layout isAdmin={true} />}>
					<Route path='/' element={<Dashboard />} />
					<Route path='/penerima-dana' element={<PenerimaBeasiswa />} />
					<Route path='/penerima-dana/beasiswa' element={<PenerimaBeasiswa />} />
					<Route path='/penerima-dana/non-beasiswa' element={<PenerimaNonBeasiswa />} />
					<Route path='/calonpenerimabeasiswa' element={<CalonPenerimaBeasiswa />} />
					<Route path='/calonpenerimanonbeasiswa' element={<CalonPenerimaNonBeasiswa />} />
					<Route path='/rekapitulasi-dana' element={<LaporanRekapitulasiBeasiswa />} />
					<Route path='/rekapitulasi-dana/beasiswa' element={<LaporanRekapitulasiBeasiswa />} />
					<Route path='/rekapitulasi-dana/non-beasiswa' element={<LaporanRekapitulasiNonBeasiswa />} />
					<Route path='/rekapitulasi-donasi' element={<LaporanRekapitulasiDonasi />}></Route>
				</Route>
				<Route path='/' element={<LayoutUser />}>
					<Route path='/beranda' element={<Beranda />} />
					<Route path='/penggalangan-dana' element={<PenggalanganDana />} />
					<Route path='/daftar-penggalangan-dana/beasiswa' element={<DaftarPenggalanganDanaBeasiswa />} />
					<Route path='/daftar-penggalangan-dana/medis' element={<DaftarPenggalanganDanaMedis />} />
					<Route path='/daftar-penggalangan-dana/bencana' element={<DaftarPenggalanganDanaBencana />} />
					<Route path='/form-donasi' element={<DataDiri />}></Route>
					<Route path='/form-donasi/upload-struk' element={<UploadPembayaran />}></Route>
					<Route path='/form-beasiswa' element={<IdentitasMahasiswa />}></Route>
					<Route path='/form-beasiswa/persyaratan' element={<PersyaratanView />}></Route>
					<Route path='/form-nonbeasiswa' element={<IdentitasPenerimaBantuan />}></Route>
					<Route path='/form-nonbeasiswa/penanggungjawab' element={<IdentitasPenanggungJawab />}></Route>
					<Route path='/form-nonbeasiswa/penanggungjawab/persyaratan-bencana' element={<PersyaratanBencanaViews />}></Route>
					<Route path='/form-nonbeasiswa/penanggungjawab/persyaratan-medis' element={<PersyaratanMedisViews />}></Route>
					<Route path='/form-nonbeasiswa/penanggungjawab/persyaratan-medis/info-galang-dana' element={<GalangDanaViews />}></Route>
					<Route path='/form-nonbeasiswa/penanggungjawab/persyaratan-bencana/info-galang-dana' element={<GalangDanaViews />}></Route>
				</Route>
			</Routes>
		</React.Fragment>

	)
}
export default App;