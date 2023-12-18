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
import { Box, Container, Typography } from '@mui/material'
import { useEffect, useState } from 'react';
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { red } from '@mui/material/colors';
import TablePagination from '@mui/material/TablePagination';
import ArrowBackIcon from '@mui/icons-material/ArrowBack';


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

function LaporanRekapitulasiNonBeasiswa() {
	const [page, setPage] = useState(0);
	const [rowsPerPage, setRowsPerPage] = useState(10);
	const [dataTable, setDataTable] = useState([])
	const [dataTableDetails, setDataTableDetails] = useState([])
	const [month, setMonth] = useState('')

	const [step, setStep] = useState(0)

	const handleNominalChange = () => {

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
	const headers = [
		{ title: 'Judul Galang Dana', id: 'judul_galang_dana' },
		{ title: 'Kategori', id: 'kategori' },
		{ title: 'Nama Penerima', id: 'nama', parentId: 'penerima_non_beasiswa' },
		{ title: 'No Telepon Penerima', id: 'nomor_telepon', parentId: 'penerima_non_beasiswa' },
		{ title: 'Nama Penanggung Jawab', id: 'nama', parentId: 'penanggung_jawab_non_beasiswa_id' },
		{ title: 'No Telepon Penanggung Jawab', id: 'nomor_telepon', parentId: 'penanggung_jawab_non_beasiswa_id' },
		{ title: 'Total Dana Dibutuhkan (Rp)', id: 'dana_yang_dibutuhkan' },
		{ title: 'Total Dana Disalurkan (Rp)', id: 'total_nominal_terkumpul' },
		{ title: 'Status', id: 'status' }
	]
	const headersDetails = [
		{ title: 'Nama Donatur', id: 'nama', parentId: 'donatur_id' },
		{ title: 'Nomor Telepon', id: 'nomor_telepon', parentId: 'donatur_id' },
		{ title: 'Nominal Donasi (Rp)', id: 'nominal_donasi', },
		{ title: 'Status', id: 'status' }
	]
	const getRekapitulasiNonBeasiswa = async () => {
		await fetch(
			'http://localhost:8000/v1/rekapitulasi/getRekapitulasiNonBeasiswa',
			{
				method: 'GET',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
			}
		)
			.then((response) => response.json())
			.then((data) => {
				console.log(data.data)
				if (data.response_code === 200) {
					let arrayData = []
					for (let i = 0; i < data.data.length; i++) {
						arrayData.push(data.data[i])
					}
					console.log(arrayData)
					setDataTable(arrayData)
				}
				else {
					console.log(data.response_message)
				}
			})
			.catch((err) => {
				console.log('error : ' + err.message);
			})
		setStep(0)
	}

	const getRekapitulasiNonBeasiswaDetails = async (id) => {
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
				let arrayDataDonatur = []
				for (let i = 0; i < data.data.length; i++) {
					arrayDataDonatur.push(data.data[i])
				}
				setDataTableDetails(arrayDataDonatur)
				console.log(arrayDataDonatur)
			})
		setStep(1)
	}
	useEffect(() => {
		getRekapitulasiNonBeasiswa()
	}, [])

	const renderRekapitulasiNonBeasiswa = () => {
		return (
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
											<StyledTableCell>{index + 1}</StyledTableCell>
											{Object.entries(headers).map(([key, val]) => (
												<StyledTableCell sx={{ textAlign: 'center' }}>{val.id === 'status' ?
													<Button size='small' variant='outlined' color='success' sx={{ backgroundColor: '#EBF9F1' }}>
														<Typography style={{ textTransform: "capitalize", color: '#1F9254', fontSize: '12px' }}>Delivered</Typography>
													</Button>
													: <span>{val?.parentId ? row?.[val.parentId]?.[val.id] : row?.[val.id]}</span>
												}</StyledTableCell>
											))}
											<StyledTableCell sx={{ display: 'flex', alignItems: 'center' }}>
												<Button size='small' color='primary' onClick={(val) => { getRekapitulasiNonBeasiswaDetails(row.bantuan_dana_non_beasiswa_id, val.target.value) }} >
													<p style={{ textTransform: "capitalize", fontSize: '12px' }}>Details</p>
												</Button>
												<DeleteOutlineIcon sx={{ color: red[500], ml: 1 }} />
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
		)
	}
	const renderDetailsRekapitulasiNonBeasiswa = () => {
		return (
			<Box sx={{ mt: 2 }}>
				<Box>
					<Button sx={{ color: 'black' }} onClick={() => setStep(0)}>
						<ArrowBackIcon fontSize='small' />
						<Typography>Back</Typography>
					</Button>
				</Box>
				<TableContainer component={Paper}>
					<Table sx={{ minWidth: 700 }} aria-label="customized table">
						<TableHead >
							<StyledTableCell>No</StyledTableCell>
							{headersDetails.map((header) =>
								<StyledTableCell sx={{ textAlign: 'center' }}>{header.title}</StyledTableCell>
							)}
						</TableHead>
						<TableBody>
							{
								dataTableDetails
									.slice(page * rowsPerPage, (page * rowsPerPage) + rowsPerPage)
									.map((row, index) => (
										<StyledTableRow key={index}>
											<StyledTableCell>{index + 1}</StyledTableCell>
											{Object.entries(headersDetails).map(([key, val]) => (
												<StyledTableCell sx={{ textAlign: 'center' }}>{val.id === 'status' ?
													<Button size='small' variant='outlined' color='success' sx={{ backgroundColor: '#EBF9F1' }}>
														<Typography style={{ textTransform: "capitalize", color: '#1F9254', fontSize: '12px' }}>Delivered</Typography>
													</Button>
													: <span>{val?.parentId ? row?.[val.parentId]?.[val.id] : row?.[val.id]}</span>
												}</StyledTableCell>
											))}
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
		)
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
				<PeopleAltIcon></PeopleAltIcon>
				<Typography variant='h4' sx={{ ml: 1 }}>Laporan Rekapitulasi Dana Non Beasiswa</Typography>
			</Box>
			<Box sx={{ mt: 2, display: 'flex', justifyContent: 'space-between' }}>
				<TextField search
					label="Search" type='search'
					sx={{ minWidth: 350 }}
					size='small'
				></TextField>
			</Box>
			{
				step === 0 ? renderRekapitulasiNonBeasiswa() : renderDetailsRekapitulasiNonBeasiswa()
			}
		</Container>
	);
}
export default LaporanRekapitulasiNonBeasiswa;