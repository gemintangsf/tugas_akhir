import { Box, Menu, MenuItem, Typography, Button } from "@mui/material"
import { useNavigate, useLocation } from "react-router-dom"
import React, { useState } from "react"


const Sidebar = (props) => {
	const navigate = useNavigate();
	const location = useLocation();
	return (
		<React.Fragment>
			<Box
				sx={{
					display: "flex",
					flexDirection: "column",
					backgroundColor: '#1559E6',
					color: '#FFFFFF',
					width: '240',
					position: 'fixed',
					height: '100vh',
					p: 2
				}}
			>
				{
					props.menu.map((data, index) => {
						return (
							<React.Fragment>
								<MenuItem
									key={"key" + index + "_" + data.name}
									className="active"
									onClick={() => {
										navigate(data.url)
									}
									}
								>
									<Box
										sx={{
											display: 'flex',
											flexDirection: 'column',
											width: '100%',
											py: 1
										}}
									>
										<Box
											sx={{
												display: 'flex',
												alignItems: 'center',
												borderRadius: '5px',
												gap: 1
											}}
										>
											{data.icon}{props.size && data.name}
										</Box>
									</Box>
								</MenuItem>
								{
									location.pathname === "/penerima-dana" && data.name === "Penerima Dana" &&
									<Box sx={{
										display: 'flex',
										flexDirection: 'column',
										width: '100%',
									}}>
										<MenuItem onClick={() => navigate('/penerima-dana/beasiswa')}><Typography sx={{ ml: 3 }}>Beasiswa</Typography></MenuItem>
										<MenuItem onClick={() => navigate('/penerima-dana/non-beasiswa')}><Typography sx={{ ml: 3 }}>Non Beasiswa</Typography></MenuItem>
									</Box>
								}
								{
									location.pathname === "/rekapitulasi-dana" && data.name === "Rekapitulasi Dana" &&
									<Box sx={{
										display: 'flex',
										flexDirection: 'column',
										width: '100%'
									}}>
										<MenuItem onClick={() => navigate('/rekapitulasi-dana/beasiswa')}><Typography sx={{ ml: 3 }}>Beasiswa</Typography></MenuItem>
										<MenuItem onClick={() => navigate('/rekapitulasi-dana/non-beasiswa')}><Typography sx={{ ml: 3 }}>Non Beasiswa</Typography></MenuItem>
									</Box>
								}
							</React.Fragment>
						)
					})}
			</Box>
		</React.Fragment>
	)
}
export default Sidebar;