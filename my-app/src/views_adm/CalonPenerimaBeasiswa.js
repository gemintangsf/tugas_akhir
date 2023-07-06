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
import { Box, Checkbox, Container, Modal, Typography } from '@mui/material'
import SearchIcon from '@mui/icons-material/Search';
import AddIcon from '@mui/icons-material/Add';
import ButtonBase from '../components/base/Button';
import TaskAltIcon from '@mui/icons-material/TaskAlt';
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import * as React from 'react'
import TablePagination from '@mui/material/TablePagination';
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

function CalonPenerimaBeasiswa() {
	// const [open, setOpen] = React.useState(false);
	// const handleOpen = () => {
	// 	setOpen(true);
	// };

	const headers = [
		{ title: 'No', id: 'no' },
		{ title: 'NIM', id: 'nim' },
		{ title: 'Nama', id: 'nama' },
		{ title: 'No Telepon', id: 'no_telepon' },
		{ title: 'Golongan UKT', id: 'golongan_ukt' },
		{ title: 'Dokumen Golongan UKT', id: 'dokumen_ukt' },
		{ title: 'Gaji Orang Tua', id: 'gaji_ortu' },
		{ title: 'Dokumen Slip Gaji', id: 'dokumen_gaji' },
		{ title: 'Jumlah Tanggungan Keluarga', id: 'tanggungan_keluarga' },
		{ title: 'Penilaian Esai', id: 'penilaian_esai' },
		{ title: 'Biaya Pengeluaran Keluarga', id: 'biaya_pengeluaran' },
		{ title: 'Biaya Transportasi', id: 'biaya_transportasi' },
		{ title: 'Biaya Konsumsi', id: 'biaya_konsumsi' },
		{ title: 'Biaya Internet', id: 'biaya_internet' },
		{ title: 'Biaya Kos', id: 'biaya_kos' },
	]

	const rows = [
		{
			no: '1',
			nim: '191524024',
			nama: 'Hasbi',
			no_telepon: '08120912312',
			golongan_ukt: '2',
			dokumen_ukt: 'details',
			gaji_ortu: '10000',
			dokumen_gaji: 'details',
			tanggungan_keluarga: '3',
			penilaian_esai: 'Baik',
			biaya_pengeluaran: '350000',
			biaya_transportasi: '350000',
			biaya_konsumsi: '350000',
			biaya_internet: '350000',
			biaya_kos: '350000',
		},
		{
			no: '2',
			nim: '191524024',
			nama: 'Hasbi',
			no_telepon: '08120912312',
			golongan_ukt: '2',
			dokumen_ukt: 'details',
			gaji_ortu: '10000',
			dokumen_gaji: 'details',
			tanggungan_keluarga: '3',
			penilaian_esai: 'Baik',
			biaya_pengeluaran: '350000',
			biaya_transportasi: '350000',
			biaya_konsumsi: '350000',
			biaya_internet: '350000',
			biaya_kos: '350000',

		},
		{
			no: '3',
			nim: '191524024',
			nama: 'Hasbi',
			no_telepon: '08120912312',
			golongan_ukt: '2',
			dokumen_ukt: 'details',
			gaji_ortu: '10000',
			dokumen_gaji: 'details',
			tanggungan_keluarga: '3',
			penilaian_esai: 'Baik',
			biaya_pengeluaran: '350000',
			biaya_transportasi: '350000',
			biaya_konsumsi: '350000',
			biaya_internet: '350000',
			biaya_kos: '350000',
		},
		{
			no: '4',
			nim: '191524024',
			nama: 'Hasbi',
			no_telepon: '08120912312',
			golongan_ukt: '2',
			dokumen_ukt: 'details',
			gaji_ortu: '10000',
			dokumen_gaji: 'details',
			tanggungan_keluarga: '3',
			penilaian_esai: 'Baik',
			biaya_pengeluaran: '350000',
			biaya_transportasi: '350000',
			biaya_konsumsi: '350000',
			biaya_internet: '350000',
			biaya_kos: '350000',
		},
		{
			no: '5',
			nim: '191524024',
			nama: 'Hasbi',
			no_telepon: '08120912312',
			golongan_ukt: '2',
			dokumen_ukt: 'details',
			gaji_ortu: '10000',
			dokumen_gaji: 'details',
			tanggungan_keluarga: '3',
			penilaian_esai: 'Baik',
			biaya_pengeluaran: '350000',
			biaya_transportasi: '350000',
			biaya_konsumsi: '350000',
			biaya_internet: '350000',
			biaya_kos: '350000',
		},
		{
			no: '6',
			nim: '191524024',
			nama: 'Hasbi',
			no_telepon: '08120912312',
			golongan_ukt: '2',
			dokumen_ukt: 'details',
			gaji_ortu: '10000',
			dokumen_gaji: 'details',
			tanggungan_keluarga: '3',
			penilaian_esai: 'Baik',
			biaya_pengeluaran: '350000',
			biaya_transportasi: '350000',
			biaya_konsumsi: '350000',
			biaya_internet: '350000',
			biaya_kos: '350000',
		},
		{
			no: '7',
			nim: '191524024',
			nama: 'Hasbi',
			no_telepon: '08120912312',
			golongan_ukt: '2',
			dokumen_ukt: 'details',
			gaji_ortu: '10000',
			dokumen_gaji: 'details',
			tanggungan_keluarga: '3',
			penilaian_esai: 'Baik',
			biaya_pengeluaran: '350000',
			biaya_transportasi: '350000',
			biaya_konsumsi: '350000',
			biaya_internet: '350000',
			biaya_kos: '350000',
		},
		{
			no: '8',
			nim: '191524024',
			nama: 'Hasbi',
			no_telepon: '08120912312',
			golongan_ukt: '2',
			dokumen_ukt: 'details',
			gaji_ortu: '10000',
			dokumen_gaji: 'details',
			tanggungan_keluarga: '3',
			penilaian_esai: 'Baik',
			biaya_pengeluaran: '350000',
			biaya_transportasi: '350000',
			biaya_konsumsi: '350000',
			biaya_internet: '350000',
			biaya_kos: '350000',
		}, {
			no: '9',
			nim: '191524024',
			nama: 'Hasbi',
			no_telepon: '08120912312',
			golongan_ukt: '2',
			dokumen_ukt: 'details',
			gaji_ortu: '10000',
			dokumen_gaji: 'details',
			tanggungan_keluarga: '3',
			penilaian_esai: 'Baik',
			biaya_pengeluaran: '350000',
			biaya_transportasi: '350000',
			biaya_konsumsi: '350000',
			biaya_internet: '350000',
			biaya_kos: '350000',
		},
		{
			no: '10',
			nim: '191524024',
			nama: 'Hasbi',
			no_telepon: '08120912312',
			golongan_ukt: '2',
			dokumen_ukt: 'details',
			gaji_ortu: '10000',
			dokumen_gaji: 'details',
			tanggungan_keluarga: '3',
			penilaian_esai: 'Baik',
			biaya_pengeluaran: '350000',
			biaya_transportasi: '350000',
			biaya_konsumsi: '350000',
			biaya_internet: '350000',
			biaya_kos: '350000',
		},
		{
			no: '11',
			nim: '191524024',
			nama: 'Hasbi',
			no_telepon: '08120912312',
			golongan_ukt: '2',
			dokumen_ukt: 'details',
			gaji_ortu: '10000',
			dokumen_gaji: 'details',
			tanggungan_keluarga: '3',
			penilaian_esai: 'Baik',
			biaya_pengeluaran: '350000',
			biaya_transportasi: '350000',
			biaya_konsumsi: '350000',
			biaya_internet: '350000',
			biaya_kos: '350000',
		}
	]

	const style = {
		position: 'absolute',
		top: '50%',
		left: '50%',
		transform: 'translate(-50%, -50%)',
		bgcolor: 'background.paper',
		border: '2px solid #000',
		boxShadow: 24,
		p: 4,
	};
	const [page, setPage] = React.useState(0);
	const [rowsPerPage, setRowsPerPage] = React.useState(10);

	const handleChangePage = (event, newPage) => {
		setPage(newPage);
	};

	const handleChangeRowsPerPage = (event) => {
		setRowsPerPage(parseInt(event.target.value, 10));
		setPage(0);
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
	const [openModal, setOpenModal] = React.useState(false);
	const handleOpenModal = () => {
		setOpenModal(true);
	};
	const handleCloseModal = () => {
		setOpenModal(false);
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
				<PeopleAltIcon fontSize='small'></PeopleAltIcon>
				<Typography variant='h4' sx={{ ml: 1 }}>Daftar Calon Penerima Bantuan Dana Beasiswa</Typography>
			</Box>
			<Box sx={{ mt: 2, display: 'flex', justifyContent: 'space-between' }}>
				<div style={{ display: 'flex', alignItems: 'center' }}>
					<TextField search
						size='small'
						label="Search" type='search'
						sx={{ minWidth: 350 }}
					></TextField>
				</div>
				<div>
					<ButtonBase variant={'contained'} text={'Seleksi Beasiswa'}></ButtonBase>
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
							{
								rows
									.slice(page * rowsPerPage, (page * rowsPerPage) + rowsPerPage)
									.map((row) => (
										<StyledTableRow key={row.no}>
											{Object.entries(headers).map(([key, val]) => (
												<StyledTableCell sx={{ textAlign: 'center' }}>{
													val.id === 'dokumen_ukt' || val.id === 'dokumen_gaji' ?
														<Button onClick={handleOpenModal}>
															<u style={{ textTransform: "capitalize" }}>Details</u>
														</Button>
														: row[val.id]}
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
																asd
															</Box>
														</Box>
													</Modal>
												</StyledTableCell>
											)
											)}

											<StyledTableCell sx={{ display: 'flex' }}>
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
export default CalonPenerimaBeasiswa;