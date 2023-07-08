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
import { useState } from 'react';
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

function LaporanRekapitulasiNonBeasiswa() {
	const [page, setPage] = useState(0);
	const [rowsPerPage, setRowsPerPage] = useState(10);

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
		{ title: 'No', id: 'no' },
		{ title: 'Judul Galang Dana', id: 'judul' },
		{ title: 'Kategori', id: 'kategori' },
		{ title: 'Nama Penerima', id: 'nama_penerima' },
		{ title: 'No Telepon Penerima', id: 'no_telp_penerima' },
		{ title: 'Nama Penanggung Jawab', id: 'nama_pj' },
		{ title: 'No Telepon Penanggung Jawab', id: 'no_telp_pj' },
		{ title: 'Total Dana Dibutuhkan (Rp)', id: 'dana_dibutuhkan' },
		{ title: 'Total Dana Disalurkan (Rp)', id: 'dana_disalurkan' },
		{ title: 'Status', id: 'status' }
	]

	const rows = [
		{
			no: '1',
			judul: 'Operasi Jantung',
			kategori: 'Medis',
			nama_penerima: 'John',
			no_telp_penerima: '082121344252',
			nama_pj: 'Hasbi',
			no_telp_pj: '082138712301',
			dana_dibutuhkan: '1000000',
			dana_disalurkan: '1000000'
		},
		{
			no: '2',
			judul: 'Operasi Jantung',
			kategori: 'Medis',
			nama_penerima: 'John',
			no_telp_penerima: '082121344252',
			nama_pj: 'Hasbi',
			no_telp_pj: '082138712301',
			dana_dibutuhkan: '1000000',
			dana_disalurkan: '1000000'
		},
		{
			no: '3',
			judul: 'Operasi Jantung',
			kategori: 'Medis',
			nama_penerima: 'John',
			no_telp_penerima: '082121344252',
			nama_pj: 'Hasbi',
			no_telp_pj: '082138712301',
			dana_dibutuhkan: '1000000',
			dana_disalurkan: '1000000'
		}
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
				<Typography variant='h4' sx={{ ml: 1 }}>Laporan Rekapitulasi Dana Non Beasiswa</Typography>
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
						<TableHead >
							{headers.map((header) =>
								<StyledTableCell sx={{ textAlign: 'center' }}>{header.title}</StyledTableCell>
							)}
							<StyledTableCell sx={{ textAlign: 'center' }}>Action</StyledTableCell>
						</TableHead>
						<TableBody>
							{rows
								.slice(page * rowsPerPage, (page * rowsPerPage) + rowsPerPage)
								.map((row) => (
									<StyledTableRow key={row.no}>
										{Object.entries(headers).map(([key, val]) => (
											<StyledTableCell sx={{ textAlign: 'center' }}>{val.id === 'status' ?
												<Button size='small' variant='outlined' color='success' sx={{ backgroundColor: '#EBF9F1' }}>
													<Typography style={{ textTransform: "capitalize", color: '#1F9254', fontSize: '12px' }}>Delivered</Typography>
												</Button>
												: row[val.id]}</StyledTableCell>
										))}
										<StyledTableCell sx={{ display: 'flex', alignItems: 'center' }}>
											<Button size='small' color='primary' onClick={handleOpen} >
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
export default LaporanRekapitulasiNonBeasiswa;