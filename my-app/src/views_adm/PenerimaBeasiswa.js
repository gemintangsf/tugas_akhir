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
import { Box, Container, Typography, Modal, MenuItem } from '@mui/material'
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
	const [dataTable, setDataTable] = useState([])
	const [page, setPage] = useState(0);
	const [rowsPerPage, setRowsPerPage] = useState(10);
	const [idPenerima, setIdPenerima] = useState('')
	const [dokumenKehadiran, setDokumenKehadiran] = useState('')
	const [statusKehadiran, setStatusKehadiran] = useState('')
	const [open, setOpen] = useState(false);
	const [openModal, setOpenModal] = useState(false);
	const [openModalDataPerkuliahan, setOpenModalDataPerkuliahan] = useState(false)
	const handleOpen = () => {
		setOpen(true);
	};
	const handleClose = () => {
		setOpen(false);
	};
	const handleOpenModal = () => {
		setOpenModal(true)
	}
	const handleCloseModal = () => {
		setOpenModal(false)
	}
	const handleOpenModalDataPerkuliahan = () => {
		setOpenModalDataPerkuliahan(true)
	}
	const handleCloseModalDataPerkuliahan = () => {
		setOpenModalDataPerkuliahan(false)
	}
	const handleDokumenKehadiranChange = (val) => {
		setDokumenKehadiran(val)
	}
	const handleStatusKehadiranChange = (val) => {
		setStatusKehadiran(val)
	}
	const handleChangePage = (event, newPage) => {
		setPage(newPage);
	};
	const handleChangeRowsPerPage = (event) => {
		setRowsPerPage(parseInt(event.target.value, 10));
		setPage(0);
	};

	const selectStatusKehadiran = [
        {
            label: 'Bebas SP',
            value: 'TanpaSP'
        },
        {
            label: 'SP 1',
            value: 'SP1'
        },
        {
            label: 'SP 2',
            value: 'SP2'
        },
        {
            label: 'SP 3',
            value: 'SP3'
        },
    ]
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

	const createKehadiranPerkuliahan = async (idPenerima) => {
		await fetch (
			'http://localhost:8000/v1/pengajuan/pengajuan_bantuan/createKehadiranPerkuliahan',
			{
				method: 'POST',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
				body: JSON.stringify({
					id: idPenerima,
					dokumen_kehadiran_perkuliahan: dokumenKehadiran,
					status_kehadiran_perkuliahan: statusKehadiran 
				})
			})
			.then((response) => response.json())
			.then((data) => {
				console.log(data.data)
			})
	}
	const selectLanjutBeasiswa = async (id) => {
		await fetch (
			'http://localhost:8000/v1/pengajuan/pengajuan_bantuan/selectLanjutBeasiswa',
			{
				method: 'POST',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
				body: JSON.stringify({
					id: id
				})
			})
			.then((response) => response.json())
			.then((data) => {
				console.log(data.data)
			})
	}
	const styleBox = {
		position: 'absolute',
		top: '50%',
		left: '50%',
		transform: 'translate(-50%, -50%)',
		width: 500,
		bgcolor: 'background.paper',
		boxShadow: 24,
		borderRadius: '4px 4px 4px 4px',
	
	}
	const headers = [
		{ title: 'NIM', id: 'nim', parentId: 'mahasiswa' },
		{ title: 'Nama', id: 'nama', parentId: 'mahasiswa' },
		{ title: 'No Telepon Mahasiswa', id: 'nomor_telepon', parentId: 'mahasiswa' },
		{ title: 'Status Kehadiran Perkuliahan', id: 'status_kehadiran_perkuliahan' },
		{ title: 'Dokumen Kehadiran Perkuliahan', id: 'dokumen_kehadiran_perkuliahan' },
		{ title: 'Status Pengajuan', id: 'status_pengajuan' }
	];

	const statusKehadiranPerkuliahan = [
        {
            label: 'Bebas SP',
            value: 0
        },
        {
            label: 'SP 1',
            value: 1
        },
        {
            label: 'SP 2',
            value: 2
        },
        {
            label: 'SP 3',
            value: 3
        },
    ];
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
							<StyledTableCell sx={{textAlign: 'center'}}>Action</StyledTableCell>
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
													: val.id === 'status_pengajuan' ?
													<Button size='small' variant='outlined' color='success' sx={{ backgroundColor: '#EBF9F1' }}>
														<Typography style={{ textTransform: "capitalize", color: '#1F9254', fontSize: '12px' }}>Approved!</Typography>
													</Button> 
													: 
													val.id === 'dokumen_kehadiran_perkuliahan' ?
													<Box>
														<Button  onClick={handleOpenModalDataPerkuliahan}>Open</Button>
														<Modal
														open={openModalDataPerkuliahan}
														onClose={handleCloseModalDataPerkuliahan}
														>
															<Box sx={styleBox}>
																{row.dokumen_kehadiran_perkuliahan}
															</Box>
														</Modal>
													</Box>
													// : val.id === 'status_kehadiran_perkuliahan' ?
													// <Typography>{statusKehadiranPerkuliahan.find((val) => val.value === val.status_kehadiran_perkuliahan).label}</Typography>
													:
													<span>{val?.parentId ? row?.[val.parentId]?.[val.id] : row?.[val.id]}</span>
													}
													</StyledTableCell>
												))
											}
											<StyledTableCell>
												<Box sx={{display:'flex'}}>
													{
														row.status_kehadiran_perkuliahan === null ?
														<Button onClick={handleOpen}><AddIcon></AddIcon></Button>
														:
														<Button onClick={handleOpenModal}><AddIcon></AddIcon></Button>
													}								
													<Button onClick={(val) => selectLanjutBeasiswa(row.bantuan_dana_beasiswa_id, val.target.value)}><TaskAltIcon></TaskAltIcon></Button>
												</Box>
												<Modal
												open={openModal}
												onClose={handleCloseModal}
												>
													<Box sx={styleBox}>
														<Box sx={{p: 2}}>
															<Typography>Dokumen kehadiran sudah tersedia, silahkan cek kembali!</Typography>
														</Box>
													</Box>
												</Modal>
												<Modal
													open={open}
													onClose={handleClose}
													>		
														<Box sx={styleBox}>
															<Box sx={{ backgroundColor: '#1559E6', borderRadius: '4px 4px 0 0', p: 2 }}>
																<Typography sx={{color: 'white'}}>Formulir Kehadiran Perkuliahan Penerima Beasiswa</Typography>
															</Box>
															<Box sx={{p: 2, display: 'flex'}}>
																<Box sx={{width: '100%'}}>
																	<Typography variant="body1">Status Kehadiran</Typography>
																	<TextField select variant='outlined' label='Pilih Status' sx={{width: '100%'}} onChange={(val) => {handleStatusKehadiranChange(val.target.value)}}>
																		{
																			selectStatusKehadiran
																			.map((option) => (
																				<MenuItem key={option.value} value={option.value}>
																					{option.label}
																				</MenuItem>
																			))
																		}
																	</TextField>
																</Box>
																<Box sx={{width: '100%', ml: 2}}>
																	<Typography variant="body1">Dokumen Kehadiran</Typography>
																	<TextField type='file' sx={{width: '100%'}} onChange={(val) => {handleDokumenKehadiranChange(val.target.value)}}/>
																</Box>
															</Box>
															<Box sx={{display: 'flex', justifyContent: 'flex-end', mr: 2, mb: 2, mt: 4}}>
																<Button variant='contained' onClick={(val) => {createKehadiranPerkuliahan(row.bantuan_dana_beasiswa_id, val.target.value)}}>Submit</Button>
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