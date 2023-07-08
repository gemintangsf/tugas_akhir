import '../App.css';
import * as React from 'react';
import Typography from '@mui/material/Typography'
import ButtonBase from '../components/base/Button';
import Grid from '@mui/material/Grid';
import { Box, Container } from '@mui/material';
import CardInfo from '../components/molekul/card/CardInfo';
import DashboardIcon from '@mui/icons-material/Dashboard';
import Menu from '@mui/material/Menu';
import MenuItem from '@mui/material/MenuItem';
import Button from '@mui/material/Button'
import Modal from '@mui/material/Modal';
import TextField from '@mui/material/TextField';
import Divider from '@mui/material/Divider';
// import Item from '@mui/material';


function Dashboard() {
	const cardList = [
		{ title: 'List Calon Penerima Beasiswa', description: 'Mahasiswa', value: 6 },
		{ title: 'Pengajuan Bantuan Dana Tersedia', description: 'Pengajuan', value: 6 },
		{ title: 'Pengajuan Bantuan Dana Diterima', description: 'Pengajuan', value: 6 },
		{ title: 'Dana Terkumpul', description: 'Total Dana Terkumpul', value: 50000000 }
	]
	const styleBox = {
		position: 'absolute',
		top: '50%',
		left: '50%',
		transform: 'translate(-50%, -50%)',
		width: 500,
		bgcolor: 'background.paper',
		boxShadow: 24,
		borderRadius: '4px 4px 4px 4px'
	}
	const [anchorEl, setAnchorEl] = React.useState(null);
	const open = Boolean(anchorEl)
	const handleCloseMenu = () => setAnchorEl(null)

	const handleClick = (event) => {
		setAnchorEl(event.currentTarget);
	};

	const [openModal, setOpenModal] = React.useState(false);
	const handleOpen = () => {
		setOpenModal(true);
		setAnchorEl(null);
	};

	const [openModalNonBeasiswa, setOpenModalNonBeasiswa] = React.useState(false)
	const handleOpenNonBeasiswa = () => {
		setOpenModalNonBeasiswa(true);
		setAnchorEl(null);
	}

	const [openModalGalangDana, setOpenModalGalangDana] = React.useState(false)
	const handleOpenGalangDana = () => {
		setOpenModalGalangDana(true);
		setOpenModalNonBeasiswa(false);
	}
	const handleCloseModalGalangDana = () => setOpenModalGalangDana(false);
	const handleCloseModal = () => setOpenModal(false);

	return (
		<Container
			disableGutters
			maxWidth={false}
			sx={{
				width: '100%',
				height: '100%',
				p: 2
			}}
		>
			<Box sx={{ display: 'flex', padding: 2, backgroundColor: '#1559E6', color: 'white', borderRadius: '4px', alignItems: 'center' }}>
				<DashboardIcon fontSize='small'></DashboardIcon>
				<Typography variant='h4' sx={{ ml: 1 }}>Dashboard</Typography>
			</Box>
			<Box sx={{ display: 'flex', mt: 2, justifyContent: 'space-between' }}>
				<Typography variant="h3">
					Selamat Datang, Admin!
				</Typography>
				<Button variant='contained'
					id="basic-button"
					aria-controls={open ? 'basic-menu' : undefined}
					aria-haspopup="true"
					aria-expanded={open ? 'true' : undefined}
					onClick={handleClick}
				>
					<Typography>Buat Galang Dana!</Typography>
				</Button>
				<Menu
					id="basic-menu"
					anchorEl={anchorEl}
					open={open}
					MenuListProps={{
						'aria-labelledby': 'basic-button',

					}}
				>
					<MenuItem onClick={handleOpen}>Beasiswa</MenuItem>
					<MenuItem onClick={handleOpenNonBeasiswa}>Non Beasiswa</MenuItem>
				</Menu>
				<Modal
					open={openModal}
					onClose={handleCloseModal}
					aria-labelledby="modal-modal-title"
					aria-describedby="modal-modal-description"
				>
					<Box sx={styleBox}>
						<Box sx={{ backgroundColor: '#1559E6', borderRadius: '4px 4px 0 0', p: 2 }}>
							<Typography variant='h3' color={'white'}>Formulir Galang Dana Beasiswa</Typography>
						</Box>
						<Box sx={{ display: 'flex', flexDirection: 'column', p: 2 }}>
							<Box sx={{ display: 'flex' }}>
								<Box>
									<Typography>Judul Galang Dana</Typography>
									<TextField size='small' variant='outlined' label='cth: Beasiswa JTK' />
								</Box>
								<Box sx={{ ml: 2 }}>
									<Typography>Kuota Beasiswa</Typography>
									<TextField size='small' variant='outlined' label='cth: 8' />
								</Box>
								<Box sx={{ ml: 2 }}>
									<Typography>Tanggal Berakhir</Typography>
									<TextField size='small' type='date' variant='outlined' />
								</Box>
							</Box>
							<Box sx={{ display: 'flex', flexDirection: 'column', pt: 2 }}>
								<Typography>Deskripsi Galang Dana</Typography>
								<TextField variant='outlined' label='Deskprisi'></TextField>
								<Typography sx={{ pt: 2 }}>Isi Redaksi</Typography>
								<TextField variant='outlined' label='Isi Redaksi'></TextField>
							</Box>
							<Box sx={{ pt: 2, display: 'flex', justifyContent: 'flex-end' }}>
								<Button variant='contained' onClick={handleCloseModal}>Submit</Button>
							</Box>
						</Box>
					</Box>
				</Modal>
				<Modal
					open={openModalNonBeasiswa}
					onClose={handleCloseModal}
					aria-labelledby="modal-modal-title"
					aria-describedby="modal-modal-description"
				>
					<Box sx={styleBox}>
						<Box sx={{ backgroundColor: '#1559E6', borderRadius: '4px 4px 0 0', p: 2 }}>
							<Typography variant='h3' color={'white'}>Formulir Galang Dana Non Beasiswa</Typography>
						</Box>
						<Box sx={{ p: 2, display: 'flex', flexDirection: 'column' }}>
							<Box sx={{ pb: 1 }}>
								<Typography variant='h3'>Identitas Penanggung Jawab</Typography>
							</Box>
							<Divider />
							<Box sx={{ display: 'flex', pt: 1 }}>
								<Box>
									<Typography>Nama</Typography>
									<TextField size='small' variant='outlined' label='cth: Beasiswa JTK' sx={{ width: '226px' }} />
								</Box>
								<Box sx={{ ml: 2 }}>
									<Typography>No Telepon</Typography>
									<TextField size='small' variant='outlined' label='cth: 082121441234' sx={{ width: '226px' }} />
								</Box>
							</Box>
							<Box sx={{ pb: 1, pt: 3 }}>
								<Typography variant='h3'>Identitas Penerima Dana</Typography>
							</Box>
							<Divider />
							<Box sx={{ display: 'flex', pt: 1 }}>
								<Box>
									<Typography>Nama</Typography>
									<TextField size='small' variant='outlined' label='cth: Beasiswa JTK' sx={{ width: '226px' }} />
								</Box>
								<Box sx={{ ml: 2 }}>
									<Typography>No Telepon</Typography>
									<TextField size='small' variant='outlined' label='cth: 082121441234' sx={{ width: '226px' }} />
								</Box>
							</Box>
							<Box sx={{ display: 'flex', pt: 1 }}>
								<Box>
									<Typography>Nama Pemilik Rekening</Typography>
									<TextField size='small' variant='outlined' label='cth: Hasbi Islahi' sx={{ width: '226px' }} />
								</Box>
								<Box sx={{ ml: 2 }}>
									<Typography>Bank Rekening</Typography>
									<TextField size='small' variant='outlined' label='cth: Mandiri' sx={{ width: '226px' }} />
								</Box>
							</Box>
							<Box sx={{ pt: 1 }}>
								<Typography>Nomor Rekening</Typography>
								<TextField size='small' variant='outlined' label='cth: 13000462110001' sx={{ width: '226px' }} />
							</Box>
							<Box sx={{ pt: 2, display: 'flex', justifyContent: 'flex-end' }}>
								<Button variant='contained' onClick={handleOpenGalangDana}>Selanjutnya</Button>
							</Box>
						</Box>
					</Box>
				</Modal>
				<Modal
					open={openModalGalangDana}
					onClose={handleCloseModal}
					aria-labelledby="modal-modal-title"
					aria-describedby="modal-modal-description"
				>
					<Box sx={styleBox}>
						<Box sx={{ backgroundColor: '#1559E6', borderRadius: '4px 4px 0 0', p: 2 }}>
							<Typography variant='h3' color={'white'}>Formulir Galang Dana Non Beasiswa</Typography>
						</Box>
						<Box sx={{ p: 2, display: 'flex', flexDirection: 'column' }}>
							<Box sx={{ pb: 1 }}>
								<Typography variant='h3'>Informasi Galang Dana</Typography>
							</Box>
							<Divider />
							<Box sx={{ display: 'flex', pt: 1 }}>
								<Box >
									<Typography>Judul Galang Dana</Typography>
									<TextField size='small' variant='outlined' label='cth: Beasiswa JTK' sx={{ width: '468px' }} />
								</Box>
							</Box>
							<Box sx={{ pt: 1 }}>
								<Typography>Deskripsi</Typography>
								<TextField size='small' variant='outlined' label='cth: 5000000' sx={{ width: '468px' }} />
							</Box>
							<Box sx={{ display: 'flex', pt: 1 }}>
								<Box>
									<Typography>Tanggal Berakhir</Typography>
									<TextField size='small' type='date' sx={{ width: '226px' }} />
								</Box>
								<Box sx={{ ml: 2 }}>
									<Typography>Nominal Dana Dibutuhkan</Typography>
									<TextField size='small' variant='outlined' label='cth: 5000000' sx={{ width: '226px' }} />
								</Box>
							</Box>
						</Box>
						<Box sx={{ display: 'flex', justifyContent: 'flex-end', pr: 2, pb: 2 }}>
							<Button variant='contained' onClick={handleCloseModalGalangDana} sx={{ mr: 1 }}>Submit</Button>
							<Button variant='outlined' onClick={handleOpenNonBeasiswa}>Sebelumnya</Button>
						</Box>
					</Box>
				</Modal>
			</Box>
			<Box sx={{ mt: 2 }}>
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
export default Dashboard;
