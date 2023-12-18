import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell, { tableCellClasses } from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';
import SidebarAdmin from '../components/molekul/sidebar/SidebarAdmin'
import TextField from '@mui/material/TextField';
import Button from '@mui/material/Button';
import TableAdmin from '../components/molekul/tabel/Tabel';
import { styled } from '@mui/material/styles';
import PeopleAltIcon from '@mui/icons-material/PeopleAlt';
import { Box, Container, Typography, MenuItem } from '@mui/material'
import { useEffect, useState } from 'react';
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { red } from '@mui/material/colors';
import Modal from '@mui/material/Modal'
import ImgContoh from '../assets/image_beranda/carousel_img.jpg'
import TablePagination from '@mui/material/TablePagination';

const StyledTableCell = styled(TableCell)(({ theme }) => ({
	[`&.${tableCellClasses.head}`]: {
		backgroundColor: theme.palette.common.white,
		color: theme.palette.common.black,

	},
	[`&.${tableCellClasses.body}`]: {
		fontSize: 14,
	},
}));

const StyledTableRow = styled(TableRow)(({ theme }) => ({
	'&:nth-of-type(odd)': {
		backgroundColor: '#E1F1FF',
	},
	// hide last border
	'&:last-child td, &:last-child th': {
		border: 0,
	},
}));

function LaporanRekapitulasiDonasi() {
	const [page, setPage] = useState(0);
	const [rowsPerPage, setRowsPerPage] = useState(10);
	const [dataTable, setDataTable] = useState([]);
	const [expiredTable, setExpiredTable] = useState([])
	const [status, setStatus] = useState('true')
	const [step, setStep] = useState(0)
	const [stat, setStat] = useState('')
	const handleStatChange = (val) => {
		setStat(val)
	}


	const handleChangePage = (event, newPage) => {
		setPage(newPage);
	};

	const handleChangeRowsPerPage = (event) => {
		setRowsPerPage(parseInt(event.target.value, 10));
		setPage(0);
	};
	const [open, setOpen] = useState(false);
	const handleOpen = () => {
		setOpen(true);
	};
	const handleClose = () => {
		setOpen(false);
	};
	const statusDonasi = [
		{
			label: 'New Donation',
			value: 0,
		},
		{
			label: 'Expired Donation',
			value: 4,
		}
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
	const [openModal, setOpenModal] = useState(false);
	const handleOpenModal = () => {
		setOpenModal(true);
	};
	const handleCloseModal = () => setOpenModal(false);

	const approvalDonasi = async (id) => {
		await fetch(
			'http://localhost:8000/v1/penggalangan/donasi/approvalDonasi',
			{
				method: 'POST',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
				body: JSON.stringify({
					nomor_referensi: id,
					is_approve: status
				})
			}
		)
	}

	useEffect(() => {
		const getDaftarDonasi = async () => {
			await fetch(
				'http://localhost:8000/v1/penggalangan/donasi/getDonasiByStatus',
				{
					method: 'POST',
					headers: {
						Accept: 'application/json',
						'Content-Type': 'application/json',
						'Access-Control-Allow-Origin': '*',
					},
					body: JSON.stringify({
						status: stat
					})
				}
			)
				.then((response) => response.json())
				.then((data) => {
					if (data.response_code === 200) {
						let selectedArray = []

						for (let i = 0; i < data.data.length; i++) {
							selectedArray.push(data.data[i])
						}
						setDataTable(selectedArray)

						console.log(selectedArray)
					}
					else {
						setDataTable([])
					}
				})
				.catch((err) => {
					console.log('error: ' + err.message)
				})
		}
		getDaftarDonasi()
	}, [stat])


	const headers = [
		{ title: 'Judul Galang Dana', id: 'judul_galang_dana'},
		{ title: 'Nama Donatur', id: 'nama', parentId: 'donatur' },
		{ title: 'No Telepon Donatur', id: 'nomor_telepon', parentId: 'donatur'},
		{ title: 'Nominal Donasi', id: 'nominal_donasi' },
		{ title: 'Nama Pemilik Rekening', id: 'nama_pemilik_rekening', parentId: 'rekening_bank' },
		{ title: 'Nomor Referensi', id: 'nomor_referensi' },
		{ title: 'Nama Bank', id: 'nama_bank', parentId: 'rekening_bank' },
		{ title: 'Status', id: 'status' },
	]
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
				<PeopleAltIcon></PeopleAltIcon>
				<Typography variant='h4' sx={{ ml: 1 }}>Laporan Rekapitulasi Donasi</Typography>
			</Box>
			<Box sx={{ mt: 2, display: 'flex', justifyContent: 'space-between' }}>
				<TextField search
					label="Search" type='search'
					sx={{ minWidth: 350 }}
					size='small'
				></TextField>
				<TextField select variant="outlined" size="small" label='Donasi Baru' onChange={(val) => { handleStatChange(val.target.value) }} sx={{ minWidth: 200 }}>
					{
						statusDonasi.map((option) => (
							<MenuItem key={option.value} value={option.value}>
								{option.label}
							</MenuItem>
						))
					}
				</TextField>
			</Box>
			<Box sx={{ mt: 2 }}>
				<TableContainer component={Paper}>
					<Table sx={{ minWidth: 700 }} aria-label="customized table">
						<TableHead >
							<StyledTableCell>No</StyledTableCell>
							{headers
								.map((header) =>
									<StyledTableCell sx={{ textAlign: 'center' }}>{header.title}</StyledTableCell>
								)}
							<StyledTableCell sx={{ textAlign: 'center' }}>Struk Pembayaran</StyledTableCell>
						</TableHead>
						<TableBody>
							{
								dataTable
									.slice(page * rowsPerPage, (page * rowsPerPage) + rowsPerPage)
									.map((row, index) => (
										<StyledTableRow key={index}>
											<StyledTableCell>
												{index + 1}
											</StyledTableCell>
											{Object.entries(headers).map(([key, val]) => (
												<StyledTableCell sx={{ textAlign: 'center' }}>{val.id === 'status' ?
													<Button size='small' variant='outlined' color='success' onClick={(val) => { approvalDonasi(row.nomor_referensi, val.target.value) }} sx={{ backgroundColor: '#EBF9F1' }}>
														<Typography style={{ textTransform: "capitalize", color: '#1F9254', fontSize: '12px' }}>Approve!</Typography>
													</Button>
													: <span>{val?.grandParentId ? row?.[val.grandParentId]?.[val.parentId]?.[val.id] : val?.parentId ? row?.[val.parentId]?.[val.id] : row?.[val.id]}</span>
												}
												</StyledTableCell>
											))}
											<StyledTableCell sx={{ display: 'flex', alignItems: 'center' }}>
												<Button size='small' color='primary' onClick={handleOpenModal} >
													<p style={{ textTransform: "capitalize", fontSize: '12px' }}>Details</p>
												</Button>
												<Modal
													open={openModal}
													onClose={handleCloseModal}
													aria-labelledby="modal-modal-title"
													aria-describedby="modal-modal-description"
												>
													<Box sx={styleBox}>
														<Box sx={{ backgroundColor: '#1559E6', borderRadius: '4px 4px 0 0', p: 2 }}>
															<Typography variant='h3' color={'white'}>Bukti Struk Pembayaran</Typography>
														</Box>
														<Box>
															<img src={ImgContoh} alt="" style={{ width: '500px' }} />

														</Box>
													</Box>
												</Modal>
											</StyledTableCell>
										</StyledTableRow>
									))
							}
						</TableBody>
					</Table>
				</TableContainer>
				<TablePagination
					component="div"
					count={dataTable.length}
					page={page}
					onPageChange={handleChangePage}
					rowsPerPage={rowsPerPage}
					onRowsPerPageChange={handleChangeRowsPerPage}
				>
				</TablePagination>
			</Box>
		</Container>
	);
}
export default LaporanRekapitulasiDonasi;