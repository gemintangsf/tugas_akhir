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
import { useState, useEffect } from 'react';
import TaskAltIcon from '@mui/icons-material/TaskAlt'
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { red } from '@mui/material/colors';
import MenuItem from '@mui/material/MenuItem';
import Modal from '@mui/material/Modal';
import ImgContoh from '../assets/image_beranda/carousel_img.jpg'

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
	const handleCloseModal = () => {
		setOpenModal(false);
	};
	const [jenisBantuan, setJenisBantuan] = useState('NonBeasiswa');
	const [kategori, setKategori] = useState('');
	const handleKategoriChange = (val) => {
		setKategori(val)
		console.log(val)
	}
	const [dataTable, setDataTable] = useState([]);
	const [status, setStatus] = useState('true')
	const [id, setId] = useState('')
	const [pengajuan, setPengajuan] = useState('true')
	const [open, setOpen] = useState(false);

	const handleStatusChange = (val) => {
		setStatus(val)
	}
	const handleOpen = () => {
		setOpen(true);
	};
	const handleClose = () => {
		setOpen(false);
	};
	const listKategori = [
		{
			label: 'Medis',
			value: 'Medis'
		},
		{
			label: 'Bencana',
			value: 'Bencana'
		},
	];
	useEffect(() => {
		const getPengajuanBantuan = async () => {
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
						jenis: jenisBantuan,
						is_pengajuan: pengajuan
					})
				}
			)
				.then((response) => response.json())
				.then((data) => {
					let arrayData = []
					for (let i = 0; i < data.data.length; i++) {
						arrayData.push(data.data[i])
					}
					setDataTable(arrayData)
					console.log(arrayData)
				})
				.catch((err) => {
					console.log(err.message);
				})
		}
		getPengajuanBantuan()
	}, [jenisBantuan])

	const getPengajuanNonBeasiswaByKategori = async () => {
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
			}
		)
		.then((response) => response.json())
		.then((data) => {
			let arrayData = []
			for (let i = 0; i < data.data.length; i++) {
				arrayData.push(data.data[i])
			}
			setDataTable(arrayData)
			console.log(arrayData)
		})
		.catch((err) => {
			console.log(err.message);
		})
	}
	const approvalPengajuanNonBeasiswa = async (id) => {
		await fetch(
			'http://localhost:8000/v1/pengajuan/pengajuan_bantuan/approvalPengajuanNonBeasiswa',
			{
				method: 'POST',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
				body: JSON.stringify({
					id: id,
					is_approve: status
				})
			}
		)
	}

	const headers = [
		{ title: 'NIM/NIP Penanggung Jawab', id: 'nomor_induk', parentId: 'penanggung_jawab_non_beasiswa_id' },
		{ title: 'Nama Penanggung Jawab', id: 'nama', parentId: 'penanggung_jawab_non_beasiswa_id' },
		{ title: 'No Telepon Penanggung Jawab', id: 'nomor_telepon', parentId: 'penanggung_jawab_non_beasiswa_id' },
		{ title: 'NIM/NIP Penerima Dana Bantuan', id: 'nomor_induk', parentId: 'penerima_non_beasiswa' },
		{ title: 'Nama Penerima Dana Bantuan', id: 'nama', parentId: 'penerima_non_beasiswa' },
		{ title: 'No Telepon Penerima Dana Bantuan', id: 'nomor_telepon', parentId: 'penerima_non_beasiswa' },
		{ title: 'Kategori', id: 'kategori'},
		{ title: 'Judul Bantuan', id: 'judul_galang_dana' },
		{ title: 'Dana yang Dibutuhkan', id: 'dana_yang_dibutuhkan' },
		{ title: 'Bukti Butuh Bantuan', id: 'bukti_butuh_bantuan' },
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
				<PeopleAltIcon fontSize='small'></PeopleAltIcon>
				<Typography variant='h4' sx={{ ml: 1 }}>Daftar Calon Penerima Bantuan Dana Non Beasiswa</Typography>
			</Box>
			<Box sx={{ mt: 2, display: 'flex', justifyContent: 'space-between' }}>
				<TextField search
					size='small'
					label="Search" type='search'
					sx={{ minWidth: 350 }}
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
							<StyledTableCell>Action</StyledTableCell>
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
														val.id === 'bukti_butuh_bantuan' ? <Button onClick={handleOpenModal}>
															<u style={{ textTransform: "capitalize" }}>Details</u>
														</Button>
															:
															<span>{val?.parentId ? row?.[val.parentId]?.[val.id] : row?.[val.id]}</span>
													}
												</StyledTableCell>


											))
											}
											{/* <span>{console.log(row.non_beasiswa_id.bukti_butuh_bantuan)}</span> */}
											<Modal
												open={openModal}
												onClose={handleCloseModal}
												aria-labelledby="modal-modal-title"
												aria-describedby="modal-modal-description"
											>
												<Box sx={styleBox}>
													<Box sx={{ backgroundColor: '#1559E6', borderRadius: '4px 4px 0 0', p: 2 }}>
													</Box>
													<Box>
														<img src={row.bukti_butuh_bantuan} alt="" style={{ width: '500px' }} />
													</Box>
												</Box>
											</Modal>
											<StyledTableCell sx={{ display: 'flex', py: 5 }}>
												<Button onClick={(val) => { approvalPengajuanNonBeasiswa(row.bantuan_dana_non_beasiswa_id, val.target.value) }}>
													<TaskAltIcon sx={{ mr: 1 }} color='primary' />
												</Button>
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
export default CalonPenerimaNonBeasiswa;