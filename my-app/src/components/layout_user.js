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
// import HeaderLogin from '../components/header/HeaderBerandaUserLogin'



const LayoutUser = () => {
	// const [step, setStep] = React.useState(0);
	// const renderLayout = () => {
	// 	<Box>
	// 			<Header />
	// 			<Box sx={{ width: '100%', overflowY: 'auto', pt: '53px' }}>
	// 				<Outlet />
	// 			</Box>
	// 		</Box>
	// }
	
	// const renderLayoutLogin = () => {
	// 	<Box>
	// 			<HeaderLogin />
	// 			<Box sx={{ width: '100%', overflowY: 'auto', pt: '53px' }}>
	// 				<Outlet />
	// 			</Box>
	// 		</Box>
	// }
	const [headerSize, setHeaderSize] = React.useState(true);
	const handleToggleSidebar = () => {
		setHeaderSize(!headerSize);
	}
	return (
		<Container
				disableGutters
				sx={{
					display: 'flex',
					flexDirection: 'column',
					height: '100%',
					minWidth: '100%'
				}}
			>
		
			<Header size={headerSize}/>
			<Box sx={{ width: '100%', overflowY: 'auto', pt: '53px' }}>
				<Outlet />
			</Box>
		
		</Container>
	)
}
export default LayoutUser;