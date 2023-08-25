import { useState, useEffect } from 'react';
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
import SearchIcon from '@mui/icons-material/Search';
import AddIcon from '@mui/icons-material/Add';
import ButtonBase from '../components/base/Button';
import TaskAltIcon from '@mui/icons-material/TaskAlt'
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { red } from '@mui/material/colors';
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

function BantuanBeasiswa() {
	const [jenis, setJenis] = useState('Beasiswa')
	const [pengajuan, setPengajuan] = useState('false')
	const [open, setOpen] = useState(false);
	const [dataTable, setDataTable] = useState([])
	const [page, setPage] = useState(0);
	const [rowsPerPage, setRowsPerPage] = useState(10);
	const handleOpen = () => {
		setOpen(true);
	};
	const handleClose = () => {
		setOpen(false);
	};
	const handleChangePage = (event, newPage) => {
		setPage(newPage);
	};
	const handleChangeRowsPerPage = (event) => {
		setRowsPerPage(parseInt(event.target.value, 10));
		setPage(0);
	};
	useEffect(() => {
		const getPenerimaBeasiswa = async () => {
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
						is_pengajuan: pengajuan
					})
				})
				.then((response) => response.json())
				.then((data) => {
					let arrayData = []
					for (let i = 0; i < data.data.length; i++) {
						arrayData.push(data.data[i])
					}
					setDataTable(arrayData)
				})
				.catch((err) => {
					console.log(err.message);
				})
		}
		getPenerimaBeasiswa()
	}, [])

	const headers = [
		{ title: 'NIM', id: 'no_identitas_pengaju' },
		{ title: 'Nama', id: 'nama' },
		{ title: 'No Telepon Mahasiswa', id: 'no_telepon' },
		{ title: 'Nomor Rekening', id: 'nomor_rekening', parentId: 'bank_id' },
		{ title: 'Nama Bank', id: 'nama_bank', parentId: 'bank_id' },
		{ title: 'Nama Pemilik Rekening', id: 'nama_pemilik_rekening', parentId: 'bank_id' },
		{ title: 'Dokumen Kehadiran Perkuliahan', id: 'dokumen_kehadiran' },
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
				<Typography variant='h4' sx={{ ml: 1 }}>Daftar Penerima Bantuan Dana Beasiswa</Typography>
			</Box>
			<Box sx={{ mt: 2, display: 'flex', justifyContent: 'space-between' }}>
				<TextField search
					label="Search" type='search'
					sx={{ minWidth: 350 }}
					size='small'
				></TextField>
			</Box>
			<Box sx={{ mt: 2 }}>
				<TableContainer component={Paper}>
					<Table sx={{ minWidth: 700 }} aria-label="customized table">
						<TableHead>
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
											{
												Object.entries(headers).map(([key, val]) => (
													<StyledTableCell sx={{ textAlign: 'center' }}>{val.id === 'dokumen_kehadiran' ? <Button onClick={handleOpen}>
														<u style={{ textTransform: "capitalize" }}>Lihat Dokumen</u>
													</Button>
														: <span>{val?.parentId ? row?.[val.parentId]?.[val.id] : row?.[val.id]}</span>
													}</StyledTableCell>
												))
											}
											<StyledTableCell sx={{ display: 'flex', py: 4.5 }}>
												<TaskAltIcon sx={{ mr: 1 }} color='primary' />
												<DeleteOutlineIcon sx={{ color: red[500] }} />
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
export default BantuanBeasiswa;