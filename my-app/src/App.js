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

import LayoutUser from './components/layout_user';
import LaporanRekapitulasiDonasi from './views_adm/DaftarDonasi';
import FormulirDonasi from './components/form/FormDonasi';
import FormulirBeasiswa from './components/form/FormBeasiswa';
import FormulirNonBeasiswa from './components/form/FormNonBeasiswa';
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
					<Route path='/daftar-penggalangan-dana' element={<DaftarPenggalanganDana />} />
					<Route path='/form-donasi' element={<FormulirDonasi />} />
					<Route path='/form-beasiswa' element={<FormulirBeasiswa />} />
					<Route path='/form-nonbeasiswa' element={<FormulirNonBeasiswa />} />
				</Route>
			</Routes>
		</React.Fragment>

	)
}
export default App;