import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell, { tableCellClasses } from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import TablePagination from '@mui/material/TablePagination';
import Paper from '@mui/material/Paper';
import SidebarAdmin from '../components/molekul/sidebar/SidebarAdmin'
import TextField from '@mui/material/TextField';
import Button from '@mui/material/Button';
import { styled } from '@mui/material/styles';
import PeopleAltIcon from '@mui/icons-material/PeopleAlt';
import { Box, Container, Typography } from '@mui/material'
import { useEffect, useState } from 'react';
import TaskAltIcon from '@mui/icons-material/TaskAlt'
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { red } from '@mui/material/colors';
import MenuItem from '@mui/material/MenuItem';

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

function NonBeasiswa() {
	const [open, setOpen] = useState(false);
	const handleOpen = () => {
		setOpen(true);
	};
	const [page, setPage] = useState(0);
	const [rowsPerPage, setRowsPerPage] = useState(10);
	const [dataTable, setDataTable] = useState([])
	const [kategori, setKategori] = useState('')
	const [pengajuan, setPengajuan] = useState('false')
	const [message, setMessage] = useState('')
	const handleClose = () => {
		setOpen(false);
	};
	const handleKategoriChange = (val) => {
		setKategori(val)
		console.log(val)
	}
	const handleChangePage = (event, newPage) => {
		setPage(newPage);
	};
	const handleChangeRowsPerPage = (event) => {
		setRowsPerPage(parseInt(event.target.value, 10));
		setPage(0);
	};
	const headers = [
		{ title: 'Judul Galang Dana', id: 'judul_galang_dana' },
		{ title: 'NIM/NIP Penerima', id: 'nomor_induk', parentId: 'penerima_non_beasiswa' },
		{ title: 'Nama Penerima', id: 'nama', parentId: 'penerima_non_beasiswa' },
		{ title: 'Nomor Telepon Penerima', id: 'nomor_telepon', parentId: 'penerima_non_beasiswa' },
		{ title: 'NIM/NIP Penanggung Jawab', id: 'nomor_induk', parentId: 'penanggung_jawab_non_beasiswa_id' },
		{ title: 'Nama Penanggung Jawab', id: 'nama', parentId: 'penanggung_jawab_non_beasiswa_id' },
		{ title: 'No Telepon Penanggung Jawab', id: 'nomor_telepon', parentId: 'penanggung_jawab_non_beasiswa_id' },
		{ title: 'Dana yang Dibutuhkan', id: 'dana_yang_dibutuhkan' },
		{ title: 'Status', id: 'status_pengajuan' }
	]

	const listKategori = [
		{
			label: 'Medis',
			value: 'Medis'
		},
		{
			label: 'Bencana',
			value: 'Bencana'
		}
	]

	useEffect(() => {
		const getPenerimaNonBeasiswaByKategori = async () => {
			await fetch(
				'http://localhost:8000/v1/pengajuan/pengajuan_bantuan/getNonBeasiswaByKategori',
				{
					method: 'POST',
					headers: {
						Accept: 'application/json',
						'Content-Type': 'application/json',
						'Access-Control-Allow-Origin': '*',
					},
					body: JSON.stringify({
						kategori: kategori,
						is_pengajuan: pengajuan
					})
				})
				.then((response) => response.json())
				.then((data) => {
					if (data.response_code === 200) {
						let arrayData = []
						for (let i = 0; i < data.data.length; i++) {
							arrayData.push(data.data[i])
						}
						setDataTable(arrayData)
					} else {
						setMessage(data.response_message)
						console.log(data.response_message)
					}

				})
				.catch((err) => {
					console.log(err.message);
				})
		}
		getPenerimaNonBeasiswaByKategori()
	}, [kategori])

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
				<Typography variant='h4' sx={{ ml: 1 }}>Daftar Penerima Bantuan Dana Non Beasiswa</Typography>
			</Box>
			<Box sx={{ mt: 2, display: 'flex', justifyContent: 'space-between' }}>
				<TextField search
					label="Search" type='search'
					sx={{ minWidth: 350 }}
					size='small'
				></TextField>
				<TextField select variant="outlined" size="small" label='Pilih kategori' onChange={(val) => { handleKategoriChange(val.target.value) }} sx={{ minWidth: 200 }}>
					{
						listKategori.map((option) => (
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
							{headers.map((header) =>
								<StyledTableCell sx={{ textAlign: 'center' }}>{header.title}</StyledTableCell>
							)}
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
												<StyledTableCell sx={{ textAlign: 'center' }}>
													{
														val.id === 'dokumen_bantuan' ? <Button onClick={handleOpen}>
															<u style={{ textTransform: "capitalize" }}>Lihat Dokumen</u>
														</Button>
															: val.id === 'status_pengajuan' ?
																<Button size='small' variant='outlined' color='success' sx={{ backgroundColor: '#EBF9F1' }}>
																	<Typography style={{ textTransform: "capitalize", color: '#1F9254', fontSize: '12px' }}>Approved!</Typography>
																</Button>
																: <span>{val?.parentId ? row?.[val.parentId]?.[val.id] : row?.[val.id]}</span>
													}
												</StyledTableCell>
											))
											}

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
export default NonBeasiswa;