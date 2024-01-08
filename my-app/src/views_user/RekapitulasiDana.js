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
import Modal from '@mui/material/Modal'


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
		backgroundColor: '#E8FFE1',
	},
	// hide last border
	'&:last-child td, &:last-child th': {
		border: 0,
	},
}));

function RekapitulasiDana() {
	const [page, setPage] = useState(0);
	const [rowsPerPage, setRowsPerPage] = useState(10);
	const [dataTableDonatur, setDataTableDonatur] = useState([])
	const [dataTablePenerima, setDataTablePenerima] = useState([])
	const [monthArray, setMonthArray] = useState([])
	const [indexMonth, setIndexMonth] = useState([])
	const [status, setStatus] = useState('true')
	const [nominal, setNominal] = useState('')
	const [id, setId] = useState('')
	const [infoDana, setInfoDana] = useState([])
	const [jenis, setJenis] = useState('Beasiswa')
	const [bulanPenyaluran, setBulanPenyaluran] = useState('')
    const [nominalPenyaluran, setNominalPenyaluran] = useState('')
	
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
	const [batch, setBatch] = useState([]);

	const handleChange = (event) => {
		setBatch(event.target.value);
	};

	const headers = [
		{ title: 'Nama Donatur', id: 'nama', parentId: 'donatur_id' },
		{ title: 'Nominal Donasi (Rp)', id: 'nominal_donasi' },

	]

	const headers2 = [
		{ title: 'NIM', id: 'nim', parentId: 'mahasiswa' },
		{ title: 'Nama', id: 'nama', parentId: 'mahasiswa' },
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
					console.log(data.data[0].penggalangan_dana_id)
					setId(data.data[0].penggalangan_dana_id)
				})
		}
		getAllPenggalanganDana()
	}, [])

	useEffect(() => {
		const getAllBatchRekapitulasiBeasiswa = async () => {
			await fetch ('http://localhost:8000/v1/rekapitulasi/getAllBatchRekapitulasiBeasiswa',
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
				let arrayBatch = []
				for (let i=0; i < data.data.length; i++) {
					arrayBatch.push({
						label: i + 1,
						value: data.data[i]
					})
				}
				setBatch(arrayBatch)
				console.log(arrayBatch)
			})
		}
		getAllBatchRekapitulasiBeasiswa()
	}, [])
		const getBulanRekapitulasiBeasiswa = async (batch) => {
			await fetch ('http://localhost:8000/v1/rekapitulasi/getBulanRekapitulasiBeasiswa',
			{
				method: 'POST',
				headers:{
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
				body: JSON.stringify({
					id: batch
				})
			})
			.then((response) => response.json())
			.then((data) => {
				console.log(data.data)
				let arrayMonth = []
				for (let i = 0; i < data.data.length; i++) {
						arrayMonth.push({
							name: data.data[i],
							value: data.data[i],
							index: i
					})
				}
				setMonthArray(arrayMonth)
				console.log(arrayMonth) 
			})
		}
	
	const getRekapitulasiBeasiswa = async (monthSelect) => {
		const startBulanPenyaluran = monthArray?.[5]?.name
		const aprilMonthIndex = monthArray?.find((month) => month?.name === startBulanPenyaluran)?.index
		let aprilMonthToNow = monthArray?.filter((month, index) => index >= aprilMonthIndex)
		let monthLeft = monthArray?.filter(month => !aprilMonthToNow.includes(month))
		aprilMonthToNow.push(...monthLeft)
		let fixedMonthArray = aprilMonthToNow.map((month, index) => ({...month, index}))
		fixedMonthArray?.map((month) => {
			const monthName = month?.name
			if (monthName === monthSelect) {
				setBulanPenyaluran(month.index)
                console.log(month.index)
			}
		})
		
		await fetch ('http://localhost:8000/v1/rekapitulasi/getRekapitulasiBeasiswa',
			{
				method: 'POST',
				headers:{
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
				body: JSON.stringify({
					id: id,
					month: monthSelect
				})
			})
			.then((response) => response.json())
			.then((data) => {
				let arrayPenerima = []
				let arrayDonatur = []
				let arrayDana = []
                let arrayNominalPenyaluran = []
				for (let i=0; i < data.data.penerima_beasiswa.length; i++) {
					arrayPenerima.push(data.data.penerima_beasiswa[i])
				}
				for (let i=0; i < data.data.rekapitulasi_donasi.length; i++) {
					arrayDonatur.push(data.data.rekapitulasi_donasi[i])
				}
                
                console.log(nominalPenyaluran + 'cobacoba')     
				arrayDana.push(data.data.rekapitulasi_dana)
                console.log(data.data.penerima_beasiswa[0].nominal_penyaluran[bulanPenyaluran] + 'test')
                
                
				setInfoDana(arrayDana)
				setDataTablePenerima(arrayPenerima)
				setDataTableDonatur(arrayDonatur)
                setNominalPenyaluran(arrayNominalPenyaluran)
				// console.log(arrayDonatur)
				// console.log(arrayPenerima)
				// console.log(arrayDana)
                console.log(bulanPenyaluran)
                console.log(arrayNominalPenyaluran)
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
			<Box sx={{ display: 'flex', padding: 2, backgroundColor: '#698D01', color: 'white', borderRadius: '4px', alignItems: 'center' }}>
				<DescriptionIcon />
				<Typography variant='h4' sx={{ ml: 1 }}>Laporan Rekapitulasi Dana Beasiswa</Typography>
			</Box>
			<Box sx={{ display: 'flex', justifyContent: 'space-between' }}>
				<Box sx={{ mt: 2, display: 'flex' }}>
					<Box sx={{ minWidth: 120 }}>
						<TextField select variant="outlined" size="small" label='Pilih batch' sx={{ minWidth: 200 }} onChange={(val) => getBulanRekapitulasiBeasiswa(val.target.value)}>
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
								monthArray.map((option) => (
									<MenuItem key={option.value} value={option.value} label={option.label}>
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
                                <StyledTableCell sx={{textAlign: 'center'}}>Total Dana yang Disalurkan</StyledTableCell>
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
															<Typography style={{ textTransform: "capitalize", color: '#1F9254', fontSize: '12px' }}>Approved</Typography>
														</Button> : val.id === 'dokumen_kehadiran_perkuliahan' ?
														<Button>
															Open
														</Button>
														: 
                                                        <span>{val?.parentId ? row?.[val.parentId]?.[val.id] : row?.[val.id]}</span>
													}</StyledTableCell>
												))}
                                                <StyledTableCell sx={{textAlign: 'center'}}>{row.nominal_penyaluran[bulanPenyaluran - 1]}</StyledTableCell>
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
							</TableHead>
							<TableBody>
								{
									dataTableDonatur
										.slice(page * rowsPerPage, (page * rowsPerPage) + rowsPerPage)
										.map((row, index) => (
											<StyledTableRow key={index}>
												<StyledTableCell>{index + 1}</StyledTableCell>
												{Object.entries(headers).map(([key, val]) => (
													<StyledTableCell sx={{ textAlign: 'center' }}>{val.id === "struk_pembayaran" ? <Button>Open</Button> : val.id === 'status' ?
														<Button size='small' variant='outlined' color='success' sx={{ backgroundColor: '#EBF9F1' }}>
															<Typography style={{ textTransform: "capitalize", color: '#1F9254', fontSize: '12px' }}>Approved</Typography>
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
				<Box>
					{
						infoDana
						.map((info, index) =>
						<Box>
							<Typography>Saldo awal        : {info.saldo_awal}</Typography>
							<Typography>Saldo akhir       : {info.saldo_akhir}</Typography>
							<Typography>Total Pemasukan   : {info.total_pemasukan}</Typography>
							<Typography>Total Pengeluaran : {info.total_pengeluaran}</Typography>
						</Box>
						)
					}
				</Box>
			</Box>
		</Container>
	);
}
export default RekapitulasiDana;