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
import Modal from '@mui/material/Modal'
import ImgContoh from '../assets/image_beranda/carousel_img.jpg'
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

function LaporanRekapitulasiDonasi() {
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
	const [openModal, setOpenModal] = useState(false);
	const handleOpenModal = () => {
		setOpenModal(true);
	};
	const handleCloseModal = () => setOpenModal(false);
	const headers = [
		{ title: 'No', id: 'no' },
		{ title: 'Judul Galang Dana', id: 'judul' },
		{ title: 'Nama Donatur', id: 'nama_donatur' },
		{ title: 'No Telepon Donatur', id: 'no_telepon' },
		{ title: 'Nominal Donasi', id: 'nominal' },
		{ title: 'Nama Pemilik Rekening', id: 'nama_pemilik' },
		{ title: 'Nomor Rekening', id: 'no_rekening' },
		{ title: 'Nama Bank', id: 'nama_bank' },
		{ title: 'Status', id: 'status' },
	]

	const rows = [
		{
			no: '1',
			judul: 'Operasi Jantung',
			nama_donatur: 'Hasbi',
			no_telepon: '082121444529',
			nominal: '50000',
			nama_pemilik: 'MUHAMAD HASBI',
			no_rekening: '130006421462',
			nama_bank: 'Mandiri',
		},
		{
			no: '2',
			judul: 'Operasi Jantung',
			nama_donatur: 'Hasbi',
			no_telepon: '082121444529',
			nominal: '50000',
			nama_pemilik: 'MUHAMAD HASBI',
			no_rekening: '130006421462',
			nama_bank: 'Mandiri',
		},
		{
			no: '3',
			judul: 'Operasi Jantung',
			nama_donatur: 'Hasbi',
			no_telepon: '082121444529',
			nominal: '50000',
			nama_pemilik: 'MUHAMAD HASBI',
			no_rekening: '130006421462',
			nama_bank: 'Mandiri',
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
				<Typography variant='h4' sx={{ ml: 1 }}>Laporan Rekapitulasi Donasi</Typography>
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
							<StyledTableCell sx={{ textAlign: 'center' }}>Struk Pembayaran</StyledTableCell>
						</TableHead>
						<TableBody>
							{rows
								.slice(page * rowsPerPage, (page * rowsPerPage) + rowsPerPage)
								.map((row) => (
									<StyledTableRow key={row.no}>
										{Object.entries(headers).map(([key, val]) => (
											<StyledTableCell sx={{ textAlign: 'center' }}>{val.id === 'status' ?
												<Button size='small' variant='outlined' color='success' sx={{ backgroundColor: '#EBF9F1' }}>
													<Typography style={{ textTransform: "capitalize", color: '#1F9254', fontSize: '12px' }}>Approved</Typography>
												</Button>
												: row[val.id]}</StyledTableCell>
										))}
										<StyledTableCell sx={{ display: 'flex', alignItems: 'center' }}>
											<Button size='small' color='primary' onClick={handleOpenModal} >
												<p style={{ textTransform: "capitalize", fontSize: '12px' }}>Details</p>
											</Button>
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
														<img src={ImgContoh} alt="" style={{ width: '500px' }} />
													</Box>
												</Box>
											</Modal>
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
export default LaporanRekapitulasiDonasi;