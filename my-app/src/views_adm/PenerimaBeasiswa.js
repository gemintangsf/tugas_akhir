import { useState } from 'react';
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
	const [open, setOpen] = useState(false);
	const handleOpen = () => {
		setOpen(true);
	};
	const handleClose = () => {
		setOpen(false);
	};
	const headers = [
		{ title: 'No', id: 'no' },
		{ title: 'NIM', id: 'nim' },
		{ title: 'Nama', id: 'nama' },
		{ title: 'No Telepon Mahasiswa', id: 'no_telepon' },
		{ title: 'Nomor Rekening', id: 'no_rekening' },
		{ title: 'Nama Bank', id: 'nama_bank' },
		{ title: 'Nama Pemilik Rekening', id: 'pemilik_rekening' },
		{ title: 'Dokumen Kehadiran Perkuliahan', id: 'dokumen_kehadiran' },
	]

	const rows = [
		{
			no: '1',
			nim: '191524024',
			nama: 'Hasbi',
			no_telepon: '08120912312',
			no_rekening: '13000872810',
			nama_bank: 'Mandiri',
			pemilik_rekening: 'Muhamad Hasbi',
			dokumen_kehadiran: 'details',
		},
		{
			no: '2',
			nim: '191524024',
			nama: 'Hasbi',
			no_telepon: '08120912312',
			no_rekening: '13000872810',
			nama_bank: 'Mandiri',
			pemilik_rekening: 'Muhamad Hasbi',
			dokumen_kehadiran: 'details',
		},
		{
			no: '3',
			nim: '191524024',
			nama: 'Hasbi',
			no_telepon: '08120912312',
			no_rekening: '13000872810',
			nama_bank: 'Mandiri',
			pemilik_rekening: 'Muhamad Hasbi',
			dokumen_kehadiran: 'details',
		},
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
							{headers.map((header) =>
								<StyledTableCell sx={{ textAlign: 'center' }}>{header.title}</StyledTableCell>
							)}
							<StyledTableCell sx={{ textAlign: 'center' }}>Action</StyledTableCell>
						</TableHead>
						<TableBody>
							{rows.map((row) => (
								<StyledTableRow key={row.no}>
									{Object.entries(headers).map(([key, val]) => (
										<StyledTableCell sx={{ textAlign: 'center' }}>{val.id === 'dokumen_kehadiran' ? <Button onClick={handleOpen}>
											<u style={{ textTransform: "capitalize" }}>Lihat Dokumen</u>
										</Button>
											: row[val.id]}</StyledTableCell>
									))}

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
			</Box>
		</Container>
	);
}
export default BantuanBeasiswa;