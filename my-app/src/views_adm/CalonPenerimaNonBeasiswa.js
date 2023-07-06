import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell, { tableCellClasses } from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';
import TextField from '@mui/material/TextField';
import Button from '@mui/material/Button';
import Container from '@mui/material/Container';
import { styled } from '@mui/material/styles';
import PeopleAltIcon from '@mui/icons-material/PeopleAlt';
import { Box, Typography } from '@mui/material'
import TablePagination from '@mui/material/TablePagination';
import { useState } from 'react';
import TaskAltIcon from '@mui/icons-material/TaskAlt'
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
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

function CalonPenerimaNonBeasiswa() {
	const [open, setOpen] = useState(false);
	const handleOpen = () => {
		setOpen(true);
	};
	const handleClose = () => {
		setOpen(false);
	};
	const headers = [
		{ title: 'No', id: 'no' },
		{ title: 'NIM/NIP', id: 'nim_nip' },
		{ title: 'Nama Penerima', id: 'nama' },
		{ title: 'No Telepon Penerima', id: 'no_telepon' },
		{ title: 'Nama Penanggung Jawab', id: 'nama_pj' },
		{ title: 'No Telepon Penanggung Jawab', id: 'no_telepon_pj' },
		{ title: 'Kategori', id: 'kategori' },
		{ title: 'Judul Bantuan', id: 'judul_bantuan' },
		{ title: 'Dana yang Dibutuhkan', id: 'dana_dibutuhkan' },
		{ title: 'Bukti Butuh Bantuan', id: 'bukti_bantuan' },
	]

	const rows = [
		{
			no: '1',
			nim_nip: '191524024',
			nama: 'Hasbi',
			no_telepon: '08120912312',
			nama_pj: 'Gemintang',
			no_telepon_pj: '0812121249812',
			kategori: 'Medis',
			judul_bantuan: 'Operasi Kanker',
			dana_dibutuhkan: '3000000',
			bukti_bantuan: 'details',
		},

	]
	const [page, setPage] = useState(0);
	const [rowsPerPage, setRowsPerPage] = useState(10);

	const handleChangePage = (event, newPage) => {
		setPage(newPage);
	};

	const handleChangeRowsPerPage = (event) => {
		setRowsPerPage(parseInt(event.target.value, 10));
		setPage(0);
	};
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
				<Typography variant='h4' sx={{ ml: 1 }}>Daftar Calon Penerima Bantuan Dana Non Beasiswa</Typography>
			</Box>
			<Box sx={{ mt: 2, display: 'flex', justifyContent: 'space-between' }}>
				<TextField search
					size='small'
					label="Search" type='search'
					sx={{ minWidth: 350 }}
				></TextField>
			</Box>
			<Box sx={{ mt: 2 }}>
				<TableContainer component={Paper}>
					<Table sx={{ minWidth: 700 }} aria-label="customized table">
						<TableHead >
							{headers.map((header) =>
								<StyledTableCell sx={{ textAlign: 'center' }}>{header.title}</StyledTableCell>
							)}
							<StyledTableCell>Action</StyledTableCell>
						</TableHead>
						<TableBody>
							{
								rows
									.slice(page * rowsPerPage, (page * rowsPerPage) + rowsPerPage)
									.map((row) => (
										<StyledTableRow key={row.no}>
											{Object.entries(headers).map(([key, val]) => (
												<StyledTableCell sx={{ textAlign: 'center' }}>{
													val.id === 'bukti_bantuan' ? <Button onClick={handleOpen}>
														<u style={{ textTransform: "capitalize" }}>Details</u>
													</Button>
														: row[val.id]}</StyledTableCell>
											))}
											<StyledTableCell sx={{ display: 'flex', py: 5 }}>
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
					count={rows.length}
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
export default CalonPenerimaNonBeasiswa;