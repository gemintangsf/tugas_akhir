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
import Container from '@mui/material/Container';
import { styled } from '@mui/material/styles';
import DescriptionIcon from '@mui/icons-material/Description';
import { Box, Divider, Typography } from '@mui/material'
import { useEffect, useState } from 'react';
import TaskAltIcon from '@mui/icons-material/TaskAlt'
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { red } from '@mui/material/colors';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';
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

function LaporanRekapitulasiBeasiswa() {
	const [page, setPage] = useState(0);
	const [rowsPerPage, setRowsPerPage] = useState(10);
	const [dataTableDonatur, setDataTableDonatur] = useState([])
	const [dataTablePenerima, setDataTablePenerima] = useState([])
	const [month, setMonth] = useState([])
	const [status, setStatus] = useState('')
	const [nominal, setNominal] = useState('')
	const [id, setId] = useState('')
	const [jenis, setJenis] = useState('Beasiswa')
	const handleChangePage = (event, newPage) => {
		setPage(newPage);
	};

	const handleNominalChange = (val) => {
		setNominal(val)
	}
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
	const [batch, setBatch] = useState([]);

	const handleChange = (event) => {
		setBatch(event.target.value);
	};

	const headers = [
		{ title: 'Nama Donatur', id: 'nama' },
		{ title: 'Nomor Telepon', id: 'nomor_telepon' },
		{ title: 'Nominal Donasi (Rp)', id: 'nominal_donasi' },
		{ title: 'Status', id: 'status' }
	]

	const headers2 = [
		{ title: 'NIM', id: 'no_identitas_pengaju' },
		{ title: 'Nama', id: 'nama' },
		{ title: 'No Telepon Mahasiswa', id: 'no_telepon' },
		{ title: 'Nomor Rekening', id: 'nomor_rekening', parentId: 'bank_id' },
		{ title: 'Nama Bank', id: 'nama_bank', parentId: 'bank_id' },
		{ title: 'Nama Pemilik Rekening', id: 'nama_pemilik_rekening', parentId: 'bank_id' }
	]

	useEffect(() => {
		const getAllPenggalanganDana = async () => {
			await fetch(
				'http://localhost:8000/v1/penggalangan/penggalangan_dana/getAllPenggalanganDana',
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
					console.log(data.data[0]._id)
					setId(data.data[0]._id.$oid)
				})
		}
		getAllPenggalanganDana()
	}, [])
	const getRekapitulasiBeasiswa = async (bulan) => {
		let body;
		if (bulan === null) {
			body = JSON.stringify({
				id: id
			})
		} else {
			body = JSON.stringify({
				id: id,
				month: bulan
			})
		}
		await fetch(
			'http://localhost:8000/v1/rekapitulasi/getRekapitulasiBeasiswa',
			{
				method: 'POST',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
				body: body
			})
			.then((response) => response.json())
			.then((data) => {
				let arrayData = []
				let arrayMonth = []
				let arrayDonatur = []
				for (let i = 0; i < data.data.pengajuan_bantuan_id.length; i++) {
					arrayData.push(data.data.pengajuan_bantuan_id[i])
				}

				setDataTablePenerima(arrayData)
				console.log(arrayData)
				// for (let i = 0; i < data.data.daftar_donasi.length; i++) {
				// 	arrayDonatur.push(data.data.daftar_donasi[i])
				// }
				// setDataTableDonatur(arrayDonatur)
				// console.log(arrayDonatur)
				for (let i = 0; i < data.data.daftar_bulan.length; i++) {
					arrayMonth.push({
						name: data.data.daftar_bulan[i],
						value: data.data.daftar_bulan[i]
					})
				}
				setMonth(arrayMonth)
				console.log(arrayMonth)
			})
	}
	useEffect(() => {
		if (id) {
			getRekapitulasiBeasiswa()
		}
	}, [id])
	const selectPenyaluranDanaBeasiswa = async (id) => {
		await fetch(
			'http://localhost:8000/v1/rekapitulasi/selectPenyaluranBeasiswa',
			{
				method: 'POST',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
				body: JSON.stringify({
					is_penyaluran: status,
					id: id,
					nominal_penyaluran: nominal
				})
			})
			.then((response) => response.json())
			.then((data) => {
				let arrayData = []
				arrayData.push(data.data.nominal_penyaluran)
				console.log(data.data.nominal_penyaluran);

			})
			.catch((err) => {
				console.log(err.message);
			})

	}

	// useEffect(() => {
	// 	getApprovedDonasi()
	// }, [id])
	const getApprovedDonasi = async () => {
		await fetch(
			'http://localhost:8000/v1/rekapitulasi/getApprovedDonasiByPenggalanganDana',

			{
				method: 'POST',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
				body: JSON.stringify({
					id: id,
					month: month
				})
			})
			.then((response) => response.json())
			.then((data) => {
				console.log(data.data)
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
				<DescriptionIcon />
				<Typography variant='h4' sx={{ ml: 1 }}>Laporan Rekapitulasi Dana Beasiswa</Typography>
			</Box>
			<Box sx={{ display: 'flex', justifyContent: 'space-between' }}>
				<Box sx={{ mt: 2, display: 'flex' }}>
					<Box sx={{ minWidth: 120 }}>
						<TextField select variant="outlined" size="small" label='Pilih batch' sx={{ minWidth: 200 }}>
							{
								batch.map((option) => (
									<MenuItem key={option.value} value={option.value}>
										{option.label}
									</MenuItem>
								))
							}
						</TextField>

					</Box>
					<Box sx={{ ml: 1 }}>
						<TextField select variant="outlined" size="small" label='Pilih bulan' sx={{ minWidth: 200 }} onChange={(val) => getRekapitulasiBeasiswa(val.target.value)}>
							{
								month.map((option) => (
									<MenuItem key={option.value} value={option.value} onClick={(val) => getApprovedDonasi(val.target.value)}>
										{option.name}
									</MenuItem>
								))
							}
						</TextField>
					</Box>

				</Box>
				<Box sx={{ mt: 2 }}>
					<TextField search
						size='small'
						label="Search" type='search'
					></TextField>
				</Box>
			</Box>
			<Box sx={{ mt: 2 }}>
				<Box>
					<TableContainer component={Paper}>
						<Table sx={{ minWidth: 700 }} aria-label="customized table">
							<TableHead >
								<StyledTableCell>No</StyledTableCell>
								{headers2.map((header) =>
									<StyledTableCell sx={{ textAlign: 'center' }}>{header.title}</StyledTableCell>
								)}
								<StyledTableCell sx={{ textAlign: 'center' }}>Total Dana Disalurkan (Rp)</StyledTableCell>
								<StyledTableCell sx={{ textAlign: 'center' }}>Action</StyledTableCell>
							</TableHead>
							<TableBody>
								{
									dataTablePenerima
										.slice(page * rowsPerPage, (page * rowsPerPage) + rowsPerPage)
										.map((row, index) => (
											<StyledTableRow key={index}>
												<StyledTableCell>{index + 1}</StyledTableCell>
												{Object.entries(headers2).map(([key, val]) => (
													<StyledTableCell sx={{ textAlign: 'center' }}>{val.id === 'status' ?
														<Button size='small' variant='outlined' color='success' sx={{ backgroundColor: '#EBF9F1' }}>
															<Typography style={{ textTransform: "capitalize", color: '#1F9254', fontSize: '12px' }}>Delivered</Typography>
														</Button>
														: <span>{val?.parentId ? row?.[val.parentId]?.[val.id] : row?.[val.id]}</span>
													}</StyledTableCell>
												))}

												<StyledTableCell>
													<TextField label="Cth: 400000" variant='outlined' sx={{ minWidth: 150 }} onChange={(val) => { handleNominalChange(parseInt(val.target.value)) }} />
												</StyledTableCell>
												<StyledTableCell sx={{ display: 'flex' }} >
													<Button onClick={(val) => { selectPenyaluranDanaBeasiswa(row._id.$oid, val.target.value) }}>
														<TaskAltIcon sx={{ mr: 2 }} color='primary' />
													</Button>
													<DeleteOutlineIcon sx={{ color: red[500] }} />
												</StyledTableCell>
											</StyledTableRow>
										)
										)}
							</TableBody>
						</Table>
					</TableContainer>
				</Box>
				<Box sx={{ mt: 3 }}>
					<Typography variant='h4'>List Donatur</Typography>
				</Box>
				<Box sx={{ mt: 1 }}>
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
									dataTableDonatur
										.slice(page * rowsPerPage, (page * rowsPerPage) + rowsPerPage)
										.map((row, index) => (
											<StyledTableRow key={index}>
												<StyledTableCell>{index + 1}</StyledTableCell>
												{Object.entries(headers).map(([key, val]) => (
													<StyledTableCell sx={{ textAlign: 'center' }}>{val.id === 'status' ?
														<Button size='small' variant='outlined' color='success' sx={{ backgroundColor: '#EBF9F1' }}>
															<Typography style={{ textTransform: "capitalize", color: '#1F9254', fontSize: '12px' }}>Delivered</Typography>
														</Button>
														: <span>{val?.parentId ? row?.[val.parentId]?.[val.id] : row?.[val.id]}</span>
													}</StyledTableCell>
												))}
												<StyledTableCell sx={{ display: 'flex' }}>
													<TaskAltIcon sx={{ mr: 2 }} color='primary' />
													<DeleteOutlineIcon sx={{ color: red[500] }} />
												</StyledTableCell>
											</StyledTableRow>
										)
										)}
							</TableBody>
						</Table>
					</TableContainer>
				</Box>

				<TablePagination
					component="div"
					count={dataTableDonatur.length}
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
export default LaporanRekapitulasiBeasiswa;