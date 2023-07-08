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
import { Box, Container } from "@mui/material";
// import { Archive, Box as BoxFeather, FilePlus, FileText, Home, Menu, User, Users } from "react-feather";
import { Outlet } from "react-router-dom";


import Header from '../components/header/HeaderBerandaUser'


const LayoutUser = () => {
	return (
		<Container
			disableGutters
			sx={{
				display: 'flex',
				flexDirection: 'column',
			}}
		>
			<Header />
			<Box sx={{ width: '100%', overflowY: 'auto', pt: '53px' }}>
				<Outlet />
			</Box>
		</Container>
	)
}
export default LayoutUser;