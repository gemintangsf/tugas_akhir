/**
 *
 *  Layout component
 *  Basic layout for most of user interface design.
 *
 * Structure:
 * 1. navbar
 * 2.1 Sidebar
 * 2.2 Content
 *
 */

import React from 'react';
import { Box, IconButton, Container, Typography } from "@mui/material";
// import { Archive, Box as BoxFeather, FilePlus, FileText, Home, Menu, User, Users } from "react-feather";
import { useLocation, Outlet, useNavigate } from "react-router-dom";


import Header from '../components/header/HeaderBerandaUser'
import Sidebar from './molekul/sidebar/SidebarAdmin';
import { useState } from 'react';
import { useEffect } from 'react';
import DashboardIcon from '@mui/icons-material/Dashboard';
import GroupIcon from '@mui/icons-material/Group';
import DescriptionIcon from '@mui/icons-material/Description';
import VolunteerActivismIcon from '@mui/icons-material/VolunteerActivism';

const Layout = ({isPenanggungJawabJtkBerbagi, isPenanggungJawabPihakJurusan}) => {
	const navigate = useNavigate();
	const penanggungJawabJtkBerbagiMenuList = [
		{ name: 'Dashboard', url: '/', icon: <DashboardIcon /> },
		{ name: 'Calon Beasiswa', url: '/calonpenerimabeasiswa', icon: <GroupIcon /> },
		{ name: 'Calon Non Beasiswa', url: '/calonpenerimanonbeasiswa', icon: <GroupIcon /> },
		{
			name: 'Penerima Dana', url: '/penerima-dana', icon: <GroupIcon />,
			child: [
				{ name: 'Penerima Beasiswa', url: 'penerima-dana/beasiswa' },
				{ name: 'Penerima Non Beasiswa', url: 'penerima-dana/non-beasiswa' },
			]
		},
		{
			name: 'Rekapitulasi Dana', url: '/rekapitulasi-dana', icon: <DescriptionIcon />,
			child: [
				{ name: 'Beasiswa', url: '/rekapitulasi-dana/beasiswa' },
				{ name: 'Non Beasiswa', url: '/rekapitulasi-dana/non-beasiswa' },
			]
		},
		{ name: 'Daftar Donasi', url: '/rekapitulasi-donasi', icon: <VolunteerActivismIcon /> },
	]

	const penanggungJawabPihakJurusanMenuList = [
		{ name: 'Dashboard', url: '/', icon: <DashboardIcon /> },
		{
			name: 'Penerima Dana', url: '/penerima-dana', icon: <GroupIcon />,
			child: [
				{ name: 'Penerima Beasiswa', url: 'penerima-dana/beasiswa' },
				{ name: 'Penerima Non Beasiswa', url: 'penerima-dana/non-beasiswa' },
			]
		},
	]
	var menuLists = [];

	if (isPenanggungJawabJtkBerbagi) {
		menuLists = penanggungJawabJtkBerbagiMenuList
	} else if (isPenanggungJawabPihakJurusan) {
		menuLists = penanggungJawabPihakJurusanMenuList
	}
	const location = useLocation();
	const currentLocationData = menuLists.reduce((result, item) => item.url === location.pathname ? [...result, item] : result, []);
	const [sidebarSize, setSidebarSize] = useState(true);
	const handleToggleSidebar = () => {
		setSidebarSize(!sidebarSize);
	}
	return (
		<Container
			disableGutters

			sx={{
				display: 'flex',
				flexDirection: 'row',
				height: '100%',
				minWidth: '100%'
			}}
		>
			<Sidebar menu={menuLists} size={sidebarSize} />
			<Box sx={{ width: '100%', overflowY: 'auto', pl: '232px' }}>
				<Outlet />
			</Box>
		</Container>
	)
}
export default Layout;