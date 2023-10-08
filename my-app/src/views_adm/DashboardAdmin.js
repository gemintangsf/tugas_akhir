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
import { useLocation, Link } from 'react-router-dom';
// import Item from '@mui/material';


function Dashboard() {


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
	const [jenisBeasiswa, setJenisBeasiswa] = React.useState('Beasiswa');
	const [judulGalangDana, setJudulGalangDana] = React.useState('');
	const [deskripsi, setDeskripsi] = React.useState('');
	const [kuotaBeasiswa, setKuotaBeasiswa] = React.useState('');
	const [tanggalBerakhir, setTanggalBerakhir] = React.useState('');
	const [id, setId] = React.useState('64f8c7c1e21fac129c8e33cc');
	const [jumlahPenerimaBantuan, setJumlahPenerimaBantuan] = React.useState('')
	const [jumlahDonasi, setJumlahDonasi] = React.useState('')
	const [openModal, setOpenModal] = React.useState(false);
	const [openModalImportData, setOpenModalImportData] = React.useState(false);
	const [openModalNonBeasiswa, setOpenModalNonBeasiswa] = React.useState(false);
	const [openModalGalangDana, setOpenModalGalangDana] = React.useState(false);
	const [anchorEl, setAnchorEl] = React.useState(null);
	const [jenis, setJenis] = React.useState('NonBeasiswa')
	const [jumlahPengajuan, setJumlahPengajuan] = React.useState('')
	const [jumlahDana, setJumlahDana] = React.useState('')
	const handleJudulChange = (val) => {
		setJudulGalangDana(val)
	}
	const handleDeskripsiChange = (val) => {
		setDeskripsi(val)
	}
	const handleKuotaBeasiswaChange = (val) => {
		setKuotaBeasiswa(val)
	}
	const handleTanggalBerakhirChange = (val) => {
		setTanggalBerakhir(val)
	}

	const open = Boolean(anchorEl)
	const handleCloseMenu = () => setAnchorEl(null)

	const handleClick = (event) => {
		setAnchorEl(event.currentTarget);
	};

	const cardList = [
		{ title: 'Pengajuan Bantuan Dana Non Beasiswa', description: 'Pengajuan', value: jumlahPengajuan },
		{ title: 'Penggalangan Dana Berlangsung', description: 'Penggalangan Dana', value: jumlahPenerimaBantuan },
		{ title: 'Daftar Donasi', description: 'Donatur', value: jumlahDonasi },
		{ title: 'Dana Terkumpul', description: 'Total Dana Terkumpul', value: jumlahDana }
	]

	var menuList = cardList;
	const location = useLocation()
	const currentLocationData = menuList.reduce((result, item) => item.url === location.pathname ? [...result, item] : result, []);
	const handleOpen = () => {
		setOpenModal(true);
		setAnchorEl(null);
		setJenisBeasiswa();
		console.log(jenisBeasiswa, 'test1')
	};

	const handleOpenNonBeasiswa = () => {
		setOpenModalNonBeasiswa(true);
		setAnchorEl(null);
	}
	const handleOpenGalangDana = () => {
		setOpenModalGalangDana(true);
		setOpenModalNonBeasiswa(false);
	}
	const handleOpenImportData = () => {
		setOpenModalImportData(true)
	}
	const handleCloseModalGalangDana = () => setOpenModalGalangDana(false);
	const handleCloseModal = () => setOpenModal(false);
	const handleCloseModalImportData = () => setOpenModalImportData(false);

	const getTotalCalonPengajuan = async () => {
		await fetch(
			'http://localhost:8000/v1/pengajuan/pengajuan_bantuan/getTotalCalonPengajuan',
			{
				method: 'POST',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
				body: JSON.stringify({
					jenis: jenis
				})
			}
		)
			.then((response) => response.json())
			.then((data) => {
				console.log(data.data)
				let arrayData = []
				arrayData.push(data.data)
				setJumlahPengajuan(arrayData)
			})

	}
	const getTotalDanaTerkumpul = async () => {
		await fetch(
			'http://localhost:8000/v1/penggalangan/donasi/getTotalAllDonasi',
			{
				method: 'GET',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
			})
			.then((response) => response.json())
			.then((data) => {
				console.log(data.data)
				let arrayData = []
				arrayData.push(data.data)
				setJumlahDana(arrayData)
			})
	}
	const getTotalNewDonasi = async () => {
		await fetch(
			'http://localhost:8000/v1/penggalangan/donasi/getTotalNewDonasi',
			{
				method: 'GET',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
			})
			.then((response) => response.json())
			.then((data) => {
				console.log(data.data)
				let arrayData = []
				arrayData.push(data.data)
				setJumlahDonasi(arrayData)
			})
	}
	const getTotalPenerimaBantuan = async () => {
		await fetch(
			'http://localhost:8000/v1/pengajuan/pengajuan_bantuan/getTotalPenerimaBantuan',
			{
				method: 'GET',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
			})
			.then((response) => response.json())
			.then((data) => {
				console.log(data.data.penerima_bantuan_admin)
				let arrayData = []
				arrayData.push(data.data.penerima_bantuan_admin)
				setJumlahPenerimaBantuan(arrayData)
			})
	}
	React.useEffect(() => {
		getTotalPenerimaBantuan()
		getTotalNewDonasi()
		getTotalCalonPengajuan()
		getTotalDanaTerkumpul()
	}, [])
	const createPenggalanganDana = async () => {
		await fetch('http://localhost:8000/v1/penggalangan/penggalangan_dana/createPenggalanganDanaBeasiswa',
			{
				mode: 'cors',
				method: 'POST',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
				body: JSON.stringify({
					id: id,
					judul_galang_dana: judulGalangDana,
					deskripsi: deskripsi,
					total_pengajuan: kuotaBeasiswa
				}),
			})
			.then((response) => response.json())
			.then((data) => {
				console.log(data.id, 'test id');
			})
			.catch((err) => {
				console.log(err.message);
			})
	}
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
			<Box sx={{ mt: 2 }}>
				<Box>
					<Typography variant="h3">
						Selamat Datang, Admin!
					</Typography>
				</Box>
				<Box sx={{ mt: 6, display: 'flex', justifyContent: 'center' }}>
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
					<Button variant='outlined' sx={{ ml: 2 }} onClick={handleOpenImportData}>
						<Typography>Import Data</Typography>
					</Button>
				</Box>
				<Modal
					open={openModalImportData}
					onClose={handleCloseModalImportData}
				>
					<Box sx={styleBox}>
						<Box sx={{ backgroundColor: '#1559E6', borderRadius: '4px 4px 0 0', p: 2 }}>
							<Typography variant='h3' color={'white'}>Import Data Civitas Akademika JTK POLBAN</Typography>
						</Box>
						<Box>
							<TextField type='file'></TextField>
						</Box>
					</Box>
				</Modal>
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
									<TextField size='small' variant='outlined' label='cth: Beasiswa JTK' onChange={(val) => { handleJudulChange(val.target.value) }} />
								</Box>
								<Box sx={{ ml: 2 }}>
									<Typography>Kuota Beasiswa</Typography>
									<TextField size='small' variant='outlined' label='cth: 8' onChange={(val) => { handleKuotaBeasiswaChange(val.target.value) }} />
								</Box>
								<Box sx={{ ml: 2 }}>
									<Typography>Tanggal Berakhir</Typography>
									<TextField size='small' type='date' variant='outlined' onChange={(val) => { handleTanggalBerakhirChange(val.target.value) }} />
								</Box>
							</Box>
							<Box sx={{ display: 'flex', flexDirection: 'column', pt: 2 }}>
								<Typography>Deskripsi Galang Dana</Typography>
								<TextField variant='outlined' label='Deskprisi' onChange={(val) => { handleDeskripsiChange(val.target.value) }}></TextField>
								<Typography sx={{ pt: 2 }}>Isi Redaksi</Typography>
								<TextField variant='outlined' label='Isi Redaksi'></TextField>
							</Box>
							<Box sx={{ pt: 2, display: 'flex', justifyContent: 'flex-end' }}>
								<Button variant='contained' onClick={createPenggalanganDana}>Submit</Button>
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
			<Box >
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
