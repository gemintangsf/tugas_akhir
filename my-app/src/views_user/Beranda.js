import Box from "@mui/material/Box"
import Typography from "@mui/material/Typography";
import ButtonBase from "../components/base/Button";
import { Button, Card, Modal, CardContent, Container } from "@mui/material";
import InfoBeranda from "../components/molekul/beranda/BerandaInfo";
import InsertEmoticonOutlinedIcon from '@mui/icons-material/InsertEmoticonOutlined';
import InfoCarousel from "../components/molekul/beranda/CarouselInfo";
import HeaderBerandaUser from '../components/header/HeaderBerandaUser'
import ImageBerandaUser from '../assets/image_beranda/background.jpeg'
import { styled } from "@mui/material/styles";
import { useNavigate, Link } from "react-router-dom";
import { useEffect, useState } from "react";
import { Swiper, SwiperSlide } from 'swiper/react';
import { Navigation, Pagination } from 'swiper/modules';
import 'swiper/css';
import 'swiper/css/pagination';
import 'swiper/css/navigation';

function Beranda() {
	const navigate = useNavigate();
	const ColorButton = styled(Button)(({ theme }) => ({
		color: theme.palette.getContrastText('#FFFFFF'),
		backgroundColor: '#FFFFFF',
		'&:hover': {
			backgroundColor: '#E0E0E0',
		},
	}));

	const carouselInfo = [
		{ title: 'Judul Galang Dana', description: 'Deskripsi Galang Dana', dana_terkumpul: 'Rp1.000.000', dana_dibutuhkan: 'Rp1.700.000', durasi: '4 hari lagi', jumlah_donatur: '1.500', kategori: 'Medis', url: '/penggalangan-dana' },
		{ title: 'Judul Galang Dana', description: 'Deskripsi Galang Dana', dana_terkumpul: 'Rp1.000.000', dana_dibutuhkan: 'Rp1.700.000', durasi: '4 hari lagi', jumlah_donatur: '1.500', kategori: 'Medis', url: '/penggalangan-dana' },
		{ title: 'Judul Galang Dana', description: 'Deskripsi Galang Dana', dana_terkumpul: 'Rp1.000.000', dana_dibutuhkan: 'Rp1.700.000', durasi: '4 hari lagi', jumlah_donatur: '1.500', kategori: 'Medis', url: '/penggalangan-dana' },
	]
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
	const [jenisBeasiswa, setJenisBeasiswa] = useState('Beasiswa');
	const [jumlahPenerimaBantuan, setJumlahPenerimaBantuan] = useState('')
	const [jumlahDonatur, setJumlahDonatur] = useState('')
	const [jumlahGalangDana, setJumlahGalangDana] = useState('')
	const [jumlahDanaTerkumpul, setJumlahDanaTerkumpul] = useState('')
	const [durasi, setDurasi] = useState('')
	const [penggalanganDana, setPenggalanganDana] = useState([])
	const [id, setId] = useState([])
	const handleJenisBeasiswa = (val) => {
		setJenisBeasiswa(val)
	}

	const [openModalBeasiswa, setOpenModalBeasiswa] = useState(false)
	const handleOpenBeasiswa = () => {
		setOpenModalBeasiswa(true);
	}
	const handleCloseModal = () => setOpenModalBeasiswa(false);
	const getAllPenggalanganDana = async () => {
		await fetch(
			'http://localhost:8000/v1/penggalangan/penggalangan_dana/getAllPenggalanganDana',
			{
				method: 'GET',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
			}
		)
			.then((response) => response.json())
			.then((data) => {
				let arrayData = []
				let arrayId = []
				for (let i = 0; i < data.data.length; i++) {
					arrayData.push(data.data[i])
				}
				for (let i = 0; i < data.data.length; i++) {
					arrayId.push(data.data[i])
					console.log(data.data[i])
				}
				setPenggalanganDana(arrayData)
				setId(arrayId)

			})
	}
	const getTotalDanaTerkumpul = async () => {
		await fetch(
			'http://localhost:8000/v1/penggalangan/donasi/getTotalAllDonasi',
			{
				method: 'GET',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
			}
		)
			.then((response) => response.json())
			.then((data) => {
				setJumlahDanaTerkumpul(data.data)
			})
	}
	const getTotalPenerimaBantuan = async () => {
		await fetch(
			'http://localhost:8000/v1/pengajuan/pengajuan_bantuan/getTotalPenerimaBantuan',
			{
				method: 'GET',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
			}
		)
			.then((response) => response.json())
			.then((data) => {
				setJumlahPenerimaBantuan(data.data.penerima_bantuan_penggalangan_dana)
				console.log(setJumlahPenerimaBantuan)
			})
	}
	const getTotalPenggalanganDana = async () => {
		await fetch(
			'http://localhost:8000/v1/penggalangan/penggalangan_dana/getTotalPenggalanganDana',
			{
				method: 'GET',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
			})
			.then((response) => response.json())
			.then((data) => {
				setJumlahGalangDana(data.data)
			})
	}
	const getTotalDonatur = async () => {
		await fetch(
			'http://localhost:8000/v1/user/donatur/getTotalDonatur',
			{
				method: 'GET',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
			})
			.then((response) => response.json())
			.then((data) => {
				setJumlahDonatur(data.data)
			})
	}
	useEffect(() => {
		getTotalDonatur()
		getTotalPenggalanganDana()
		getTotalPenerimaBantuan()
		getTotalDanaTerkumpul()
		getAllPenggalanganDana()
		getDurasiPengajuanBeasiswa()
	}, [])

	const getDurasiPengajuanBeasiswa = async () => {
		await fetch(
			'http://localhost:8000/v1/pengajuan/pengajuan_bantuan/getDurasiPengajuanBeasiswa',
			{
				method: 'GET',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
			}
		)
			.then((response) => response.json())
			.then((data) => {
				if (data.response_code === 200) {
					let arrayData = []
					arrayData.push(data.data)
					setDurasi('Waktu pendaftaran beasiswa tersisa ' + arrayData + ' hari lagi')
				}
				else {
					let arrayData = []
					arrayData.push(data.response_message)
					setDurasi(arrayData)
				}
			})
	}
	const berandaListInfo = [
		{ title: 'Donatur', value: jumlahDonatur },
		{ title: 'Penggalangan Dana', value: jumlahGalangDana },
		{ title: 'Penerima Dana Bantuan', value: jumlahPenerimaBantuan },
		{ title: 'Dana Terkumpul', value: 'Rp' + jumlahDanaTerkumpul }
	]
	return (
		<Box >
			<Box sx={{ height: '424px', position: 'relative' }}>
				<img src={ImageBerandaUser} alt="" style={{ alignItems: 'center', height: '424px', width: '100%', position: 'absolute', zIndex: 9 }} />
				<Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center', backgroundColor: 'rgba(0,0,0,0.7)', height: '424px', position: 'absolute', width: '100%', zIndex: 99 }}>
					<Typography variant='h2' sx={{ color: 'white', mt: 18 }}>Your home for help</Typography>
					<Typography sx={{ fontSize: '20px', textAlign: 'center', width: '800px', color: 'white', mt: 2 }}>Fundraising on JTK Berbagi takes just a few minutes.
						Give your support today!</Typography>
				</Box>
			</Box>
			<Box sx={{ display: 'flex', mt: 2, justifyContent: 'center' }}>
				<Button href='/form-nonbeasiswa' variant='contained' size="small" color="success"><Typography sx={{ textTransform: 'capitalize', px: 2, py: 1 }}>Mulai Pengajuan Dana</Typography></Button>
				<Button variant="outlined" size="small" color="success" sx={{ ml: 2 }} onClick={handleOpenBeasiswa}><Typography sx={{ textTransform: 'capitalize', px: 2, py: 1 }}>Daftar Beasiswa!</Typography></Button>
			</Box>
			<Modal
				open={openModalBeasiswa}
				onClose={handleCloseModal}
			>
				<Box sx={styleBox}>
					{
						<Box sx={{ p: 2, display: 'flex', flexDirection: 'column' }}>
							<Box>
								<Typography sx={{ mb: 2 }}> {durasi} </Typography>
								{
									durasi === 'Pengajuan Bantuan Dana Beasiswa sudah ditutup!' ?
										<Button variant="contained" onClick={handleCloseModal}><Typography>OK</Typography></Button>
										:
										<Button variant="contained" href="/form-beasiswa"><Typography>OK</Typography></Button>
								}
							</Box>
						</Box>
					}
				</Box>
			</Modal>
			<Box sx={{ backgroundColor: '#405600', mt: 2 }}>
				<Box sx={{ display: 'flex', color: 'white' }}>
					{berandaListInfo.map((info, index) =>
					(
						<InfoBeranda title={info.title} value={info.value} index={index} />
					)
					)}
				</Box>
			</Box>
			<Box sx={{ mx: 2, mb: 4 }} >
				<Typography variant='h3' sx={{ ml: 2, mt: 2, mb: 1 }}>Daftar Penggalangan Dana</Typography>
				{
					<Swiper
						slidesPerView={3}
						grid={{
							rows: 1,
						}}
						spaceBetween={10}
						loop={true}
						pagination={{
							clickable: true,
						}}
						navigation={true}
						modules={[Navigation, Pagination]}
						className="mySwiper"
					>
						{
							penggalanganDana.map((info, index) => {
								return (
									<SwiperSlide >
										<Link to="/penggalangan-dana" state={info.penggalangan_dana_id} style={{ textDecoration: 'none' }}>
											<Card>
												<InfoCarousel
													title={info.judul}
													description={info.deskripsi}
													dana_terkumpul={info.total_nominal_terkumpul}
													dana_dibutuhkan={info.dana_yang_dibutuhkan}
													durasi={info.durasi}
													jumlah_donatur={info.total_donatur}
													kategori={info.kategori}
													index={index}
												/>
											</Card>
										</Link>
									</SwiperSlide>
								)
							})
						}
					</Swiper>
				}
			</Box>
		</Box >
	)
}
export default Beranda;