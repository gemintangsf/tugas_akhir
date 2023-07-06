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
import { Box, Typography } from '@mui/material'
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

function LaporanRekapitulasiBeasiswa() {
	const [open, setOpen] = useState(false);
	const handleOpen = () => {
		setOpen(true);
	};
	const handleClose = () => {
		setOpen(false);
	};
	const headers = [
		{ title: 'No', id: 'no' },
		{ title: 'Nama Donatur', id: 'nama_donatur' },
		{ title: 'Nomor Telepon', id: 'no_telepon' },
		{ title: 'Nominal Donasi (Rp)', id: 'nominal_donasi' },
		{ title: 'Nama Penerima', id: 'nama_penerima' },
		{ title: 'Nominal Pengeluaran Dana (Rp)', id: 'nominal_pengeluaran' },
		{ title: 'Status', id: 'status' }
	]
	const rows = [
		{
			no: '1',
			nama_donatur: 'Hasbi',
			no_telepon: '082121445524',
			nominal_donasi: '1000000',
			nama_penerima: '08120912312',
			nominal_pengeluaran: '1000000'
		},
		{
			no: '2',
			nama_donatur: 'Hasbi',
			no_telepon: '082121445524',
			nominal_donasi: '1000000',
			nama_penerima: '08120912312',
			nominal_pengeluaran: '1000000'
		},
		{
			no: '3',
			nama_donatur: 'Hasbi',
			no_telepon: '082121445524',
			nominal_donasi: '1000000',
			nama_penerima: '08120912312',
			nominal_pengeluaran: '1000000'
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
				<DescriptionIcon />
				<Typography variant='h4' sx={{ ml: 1 }}>Laporan Rekapitulasi Dana Beasiswa</Typography>
			</Box>
			<Box sx={{ mt: 2, display: 'flex', justifyContent: 'space-between' }}>
				<div style={{ display: 'flex', alignItems: 'center' }}>
					<TextField search
						size='small'
						label="Search" type='search'
						sx={{ minWidth: 350 }}
					></TextField>
				</div>
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
							{rows.map((row) => (
								<StyledTableRow key={row.no}>
									{Object.entries(headers).map(([key, val]) => (
										<StyledTableCell sx={{ textAlign: 'center' }}>{val.id === 'status' ?
											<Button size='small' variant='outlined' color='success' sx={{ backgroundColor: '#EBF9F1' }}>
												<Typography style={{ textTransform: "capitalize", color: '#1F9254', fontSize: '12px' }}>Delivered</Typography>
											</Button>
											: row[val.id]}</StyledTableCell>
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
		</Container>
	);
}
export default LaporanRekapitulasiBeasiswa;