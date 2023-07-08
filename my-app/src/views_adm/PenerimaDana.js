import '../App.css';
import * as React from 'react';
import Typography from '@mui/material/Typography'
import ButtonBase from '../components/base/Button';
import Grid from '@mui/material/Grid';
import { Box, Container } from '@mui/material';
import CardInfo from '../components/molekul/card/CardInfo';
import DashboardIcon from '@mui/icons-material/Dashboard';
// import Item from '@mui/material';


function PenerimaBantuan() {
	const cardList = [
		{ title: 'List Calon Penerima Beasiswa', description: 'Mahasiswa', value: 6 },
		{ title: 'Pengajuan Bantuan Dana Tersedia', description: 'Pengajuan', value: 6 },
		{ title: 'Pengajuan Bantuan Dana Diterima', description: 'Pengajuan', value: 6 },
		{ title: 'Dana Terkumpul', description: 'Total Dana Terkumpul', value: 50000000 }
	]

	return (
		<Container
			disableGutters
			maxWidth={false}
			sx={{
				width: '100%',
				height: '100%',
			}}
		>
			<Box sx={{ display: 'flex', padding: 3, backgroundColor: '#1559E6', color: 'white' }}>
				<DashboardIcon></DashboardIcon>
				<Typography sx={{ ml: 1, fontSize: '20px' }}>Dashboard</Typography>
			</Box>
			<Box sx={{ display: 'flex', flexDirection: 'column', mt: 2 }}>
				<Typography variant="h5">
					Selamat Datang, Admin!
				</Typography>
				<Grid container spacing={1} sx={{ mt: 8, justifyContent: 'center' }}>
					<Grid item>
						<ButtonBase variant='contained' text='Buat Galang Dana'>
						</ButtonBase>
					</Grid>
					<Grid item>
						<ButtonBase variant='outlined' text='Buka Pendaftaran!'>
						</ButtonBase>
					</Grid>
				</Grid>
			</Box>
			<Box>
				<Grid container spacing={2}>

					{cardList.map((info, index) =>
					(
						<Grid item md={6} >
							<CardInfo title={info.title} description={info.description} value={info.value} index={index} />
						</Grid>
					))}

				</Grid>
			</Box>
		</Container>
	);
}
export default PenerimaBantuan;
