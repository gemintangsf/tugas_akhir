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
import PenerimaBeasiswa from './views_adm/PenerimaBeasiswa'
import PenerimaNonBeasiswa from './views_adm/PenerimaNonBeasiswa'
import Layout from './components/layout';
import RekapitulasiDana from './views_user/RekapitulasiDana';

import LayoutUser from './components/layout_user';
import LaporanRekapitulasiDonasi from './views_adm/DaftarDonasi';
import FormulirDonasi from './components/form/FormDonasi';
import FormulirBeasiswa from './components/form/FormBeasiswa';
import FormulirNonBeasiswa from './components/form/FormNonBeasiswa';
import FormulirPendaftaranAkun from './components/form/FormAccount';
import LoginUser from './views_user/LoginUser';
// import Item from '@mui/material';

function App() {
	var user = {
		name: "",
		role: "",
	};
	if (localStorage.getItem("token")) {
		user.name = localStorage.getItem("username");
		user.role = localStorage.getItem("role");
	}
	return (
		<React.Fragment>
			<Routes>
				<Route path='/login' element={<Login />} />
				<Route path='/registration' element={<FormulirPendaftaranAkun/>} />
				<Route path='/' element={<Layout isPenanggungJawabJtkBerbagi={true} isPenanggungJawabPihakJurusan={false} isLogin={localStorage.getItem("token") !== null}/>}>
					<Route path='' element={<Dashboard />} />
					<Route path='/calonpenerimabeasiswa' element={<CalonPenerimaBeasiswa />} />
					<Route path='/calonpenerimanonbeasiswa' element={<CalonPenerimaNonBeasiswa />} />
					<Route path='/rekapitulasi-dana' element={<LaporanRekapitulasiBeasiswa />} />
					<Route path='/rekapitulasi-dana/non-beasiswa' element={<LaporanRekapitulasiNonBeasiswa />} />
					<Route path='/rekapitulasi-donasi' element={<LaporanRekapitulasiDonasi />} />
				</Route>
				<Route path='/' element={<Layout isPenanggungJawabJtkBerbagi={true} isPenanggungJawabPihakJurusan={true} isLogin={localStorage.getItem("token") !== null}/>}>
					<Route path='' element={<Dashboard />} />
					<Route path='/penerima-dana' element={<PenerimaBeasiswa />} />
					<Route path='/penerima-dana/beasiswa' element={<PenerimaBeasiswa />} />
					<Route path='/penerima-dana/non-beasiswa' element={<PenerimaNonBeasiswa />} />
				</Route>

				<Route path='/login-user' element={<LoginUser />} />
				<Route path='/' element={<LayoutUser />}>
					<Route path='/beranda' element={<Beranda />} />
					<Route path='/penggalangan-dana' element={<PenggalanganDana />} />
					<Route path='/daftar-penggalangan-dana' element={<DaftarPenggalanganDana />} />
					<Route path='/form-donasi' element={<FormulirDonasi />} />
					<Route path='/form-beasiswa' element={<FormulirBeasiswa />} />
					<Route path='/form-nonbeasiswa' element={<FormulirNonBeasiswa />} />
					<Route path='/rekapitulasi-dana-public' element={<RekapitulasiDana />} />
				</Route>
			</Routes>
		</React.Fragment>
	)
}
export default App;