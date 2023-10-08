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
import { Box, Checkbox, Container, Modal, Typography, MenuItem } from '@mui/material'
import SearchIcon from '@mui/icons-material/Search';
import AddIcon from '@mui/icons-material/Add';
import ButtonBase from '../components/base/Button';
import TaskAltIcon from '@mui/icons-material/TaskAlt';
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import * as React from 'react'
import TablePagination from '@mui/material/TablePagination';
import { red } from '@mui/material/colors';

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

function CalonPenerimaBeasiswa() {
	const [dataTable, setDataTable] = React.useState([])
	const [jenis, setJenis] = React.useState('Beasiswa')
	const [id, setId] = React.useState('')
	const [penilaianEsai, setPenilaianEsai] = React.useState('')
	const [approve, setApprove] = React.useState('true')
	const [status, setStatus] = React.useState('true')
	const [page, setPage] = React.useState(0);
	const [rowsPerPage, setRowsPerPage] = React.useState(10);


	const handlePenilaianEsaiChange = (val) => {
		setPenilaianEsai(val)
		console.log(val)
	}
	const handleChangePage = (event, newPage) => {
		setPage(newPage);
	};

	const handleChangeRowsPerPage = (event) => {
		setRowsPerPage(parseInt(event.target.value, 10));
		setPage(0);
	};

	React.useEffect(() => {
		const dataTableCalonBeasiswa = async () => {
			await fetch(
				'http://localhost:8000/v1/pengajuan/pengajuan_bantuan/getPengajuanBantuan',
				{
					method: 'POST',
					headers: {
						Accept: 'application/json',
						'Content-Type': 'application/json',
						'Access-Control-Allow-Origin': '*',
					},
					body: JSON.stringify({
						jenis: jenis,
						is_pengajuan: status
					})
				}
			)
				.then((response) => response.json())
				.then((data) => {
					let arrayData = []
					for (let i = 0; i < data.data.length; i++) {
						arrayData.push(data.data[i])
					}
					setDataTable(arrayData)
					console.log(arrayData)
				})
				.catch((err) => {
					console.log(err.message);
				})
		}
		dataTableCalonBeasiswa()
	}, [])

	const createPenilaianEsai = async (id, penilaianEsai) => {
		await fetch(
			"http://localhost:8000/v1/pengajuan/pengajuan_bantuan/createPenilaianEsai",
			{
				method: 'POST',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
				body: JSON.stringify({
					id: id,
					penilaian_esai: penilaianEsai
				})
			})
			.then((response) => response.json())
			.then((data) => {

				console.log(data.data)
			})
	}

	const approvePengajuanBeasiswa = async (id) => {
		await fetch(
			'http://localhost:8000/v1/pengajuan/pengajuan_bantuan/selectNewPengajuan',
			{
				method: 'POST',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
				body: JSON.stringify({
					id: id,
					is_approve: approve
				})
			})
			.then((response) => response.json())
			.then((data) => {
				console.log(data.data)
			})
	}
	const nilaiEsai = [
		{
			label: 'Kurang',
			value: 'Kurang',
		},
		{
			label: 'Cukup',
			value: 'Cukup',
		},
		{
			label: 'Baik',
			value: 'Baik',
		},
		{
			label: 'Sangat Baik',
			value: 'SangatBaik'
		}
	]
	const headers = [
		{ title: 'NIM', id: 'no_identitas_pengaju' },
		{ title: 'Nama', id: 'nama' },
		{ title: 'No Telepon', id: 'no_telepon' },
		{ title: 'Golongan UKT', id: "golongan_ukt", parentId: 'beasiswa_id' },
		{ title: 'Dokumen Golongan UKT', id: 'kuitansi_pembayaran_ukt', parentId: 'beasiswa_id' },
		{ title: 'Gaji Orang Tua', id: 'gaji_orang_tua', parentId: 'beasiswa_id' },
		{ title: 'Dokumen Slip Gaji', id: 'bukti_slip_gaji_orang_tua', parentId: 'beasiswa_id' },
		{ title: 'Jumlah Tanggungan Keluarga', id: 'jumlah_tanggungan_keluarga', parentId: 'beasiswa_id' },
		{ title: 'Dokumen Esai', id: 'esai', parentId: 'beasiswa_id' },
		{ title: 'Penilaian Esai', id: 'penilaian_esai' },
		{ title: 'Biaya Pengeluaran Keluarga', id: 'total_pengeluaran_keluarga', parentId: 'beasiswa_id' },
		{ title: 'Biaya Transportasi', id: 'biaya_transportasi', parentId: 'beasiswa_id' },
		{ title: 'Biaya Konsumsi', id: 'biaya_konsumsi', parentId: 'beasiswa_id' },
		{ title: 'Biaya Internet', id: 'biaya_internet', parentId: 'beasiswa_id' },
		{ title: 'Biaya Kos', id: 'biaya_kos', parentId: 'beasiswa_id' },
		{ title: 'Status', id: 'status_pengajuan' }
	]

	const style = {
		position: 'absolute',
		top: '50%',
		left: '50%',
		transform: 'translate(-50%, -50%)',
		bgcolor: 'background.paper',
		border: '2px solid #000',
		boxShadow: 24,
		p: 4,
	};

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
	const [openModal, setOpenModal] = React.useState(false);
	const handleOpenModal = () => {
		setOpenModal(true);
	};
	const handleCloseModal = () => {
		setOpenModal(false);
	};
	console.log(headers)
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
				<PeopleAltIcon fontSize='small' />
				<Typography variant='h4' sx={{ ml: 1 }}>Daftar Calon Penerima Bantuan Dana Beasiswa</Typography>
			</Box>
			<Box sx={{ mt: 2, display: 'flex', justifyContent: 'space-between' }}>
				<div style={{ display: 'flex', alignItems: 'center' }}>
					<TextField search
						size='small'
						label="Search" type='search'
						sx={{ minWidth: 350 }}
					></TextField>
				</div>
				<div>
					<ButtonBase variant={'contained'} text={'Seleksi Beasiswa'}></ButtonBase>
				</div>
			</Box>
			<Box sx={{ mt: 2 }}>
				<TableContainer component={Paper}>
					<Table sx={{ minWidth: 700 }} aria-label="customized table">

						<TableHead >
							<StyledTableCell>No</StyledTableCell>
							{headers.map((header) =>
								<StyledTableCell sx={{ textAlign: 'center' }}>{header.title}</StyledTableCell>
							)}
							<StyledTableCell sx={{ textAlign: 'center' }}>Action</StyledTableCell>
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
												<StyledTableCell sx={{ textAlign: 'center' }}>{
													val.id === 'penilaian_esai' ?
														<TextField select variant="outlined" size="small" label='Masukkan nilai' sx={{ width: 150 }} onChange={(val) => { createPenilaianEsai(row._id.$oid, val.target.value) }}>
															{
																nilaiEsai.map((option) => (
																	<MenuItem key={option.value} value={option.value}>
																		{option.label}
																	</MenuItem>
																))
															}
														</TextField>
														:
														val.id === 'kuitansi_pembayaran_ukt' || val.id === 'bukti_slip_gaji_orang_tua' || val.id === 'esai' ?
															<Button onClick={handleOpenModal}>
																<u style={{ textTransform: "capitalize" }}>Details</u>
															</Button>
															: val.id === 'status_pengajuan' ?
																<Button size='small' variant='outlined' color='error' sx={{ backgroundColor: '#CFACAD' }}>
																	<Typography style={{ textTransform: "capitalize", color: '#A30D11', fontSize: '12px' }}>Pending</Typography>
																</Button> :
																<span>{val?.parentId ? row?.[val.parentId]?.[val.id] : row?.[val.id]}</span>
												}
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
																asd
															</Box>
														</Box>
													</Modal>
												</StyledTableCell>
											)
											)}
											<StyledTableCell sx={{ display: 'flex' }}>
												<Button onClick={(val) => { approvePengajuanBeasiswa(row._id.$oid, val.target.value) }}>
													<TaskAltIcon sx={{ mr: 1 }} color='primary' />
												</Button>
											</StyledTableCell>
										</StyledTableRow>
									)
									)}
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
export default CalonPenerimaBeasiswa;