import Box from "@mui/material/Box"
import Typography from "@mui/material/Typography";
import ButtonBase from "../components/base/Button";
import { Button, Card, CardContent, Container, Link } from "@mui/material";
import InfoBeranda from "../components/molekul/beranda/BerandaInfo";
import InsertEmoticonOutlinedIcon from '@mui/icons-material/InsertEmoticonOutlined';
import InfoCarousel from "../components/molekul/beranda/CarouselInfo";
import HeaderBerandaUser from '../components/header/HeaderBerandaUser'
import ImageBerandaUser from '../assets/image_beranda/wisuda.jpg'
import { styled } from "@mui/material/styles";
import { useNavigate } from "react-router-dom";
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
			backgroundColor: '#9E9E9E',
		},
	}));

	const carouselInfo = [
		{ title: 'Judul Galang Dana', description: 'Deskripsi Galang Dana', dana_terkumpul: 'Rp1.000.000', dana_dibutuhkan: 'Rp1.700.000', durasi: '4 hari lagi', jumlah_donatur: '1.500', kategori: 'Medis', url: '/penggalangan-dana' },
		{ title: 'Judul Galang Dana', description: 'Deskripsi Galang Dana', dana_terkumpul: 'Rp1.000.000', dana_dibutuhkan: 'Rp1.700.000', durasi: '4 hari lagi', jumlah_donatur: '1.500', kategori: 'Medis', url: '/penggalangan-dana' },
		{ title: 'Judul Galang Dana', description: 'Deskripsi Galang Dana', dana_terkumpul: 'Rp1.000.000', dana_dibutuhkan: 'Rp1.700.000', durasi: '4 hari lagi', jumlah_donatur: '1.500', kategori: 'Medis', url: '/penggalangan-dana' },
	]
	const [jenisBeasiswa, setJenisBeasiswa] = useState('Beasiswa');
	const [jumlahPenerimaBantuan, setJumlahPenerimaBantuan] = useState('')
	const [jumlahDonatur, setJumlahDonatur] = useState('')
	const [jumlahGalangDana, setJumlahGalangDana] = useState('')
	const [jumlahDanaTerkumpul, setJumlahDanaTerkumpul] = useState('')
	const [penggalanganDana, setPenggalanganDana] = useState([])
	const handleJenisBeasiswa = (val) => {
		setJenisBeasiswa(val)
	}

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
				console.log(data.data)
				let arrayData = []
				for (let i = 0; i < data.data.length; i++) {
					arrayData.push(data.data[i])
				}
				setPenggalanganDana(arrayData)
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
				console.log(data)
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
				console.log(data)
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
				console.log(data)
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
				console.log(data.data + 'tes')
				setJumlahDonatur(data.data)
			})
	}
	useEffect(() => {
		getTotalDonatur()
		getTotalPenggalanganDana()
		getTotalPenerimaBantuan()
		getTotalDanaTerkumpul()
		getAllPenggalanganDana()
	}, [])

	const berandaListInfo = [
		{ title: 'Donatur', value: jumlahDonatur },
		{ title: 'Penggalangan Dana', value: jumlahGalangDana },
		{ title: 'Penerima Dana Bantuan', value: jumlahPenerimaBantuan },
		{ title: 'Dana Terkumpul', value: 'Rp' + jumlahDanaTerkumpul }
	]
	return (
		<Box >
			<Box sx={{ height: '424px' }}>
				<img src={ImageBerandaUser} alt="" style={{ alignItems: 'center', height: '424px', width: '100%', position: 'absolute' }} />
				<Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center', backgroundColor: 'black', height: '424px', opacity: 0.7, position: 'absolute', width: '100%', zIndex: '1' }}>
					<Typography variant='h2' sx={{ color: 'white', mt: 3 }}>Lorem Ipsum is simply </Typography>
					<Typography sx={{ fontSize: '20px', textAlign: 'center', width: '800px', mt: 3, color: 'white' }}>Lorem Ipsum is simply dummy text of the printing and typesetting industry.
						Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,
						when an unknown printer took a galley of type and scrambled it to make a type specimen book</Typography>
					<Box sx={{ display: 'flex', mt: 20 }}>
						<Button href='/form-nonbeasiswa' variant='contained' size="small" color="success"><Typography sx={{ textTransform: 'capitalize', px: 2, py: 1 }}>Mulai Pengajuan Dana</Typography></Button>
						<ColorButton variant="outlined" size="small" color="success" sx={{ ml: 2 }} href="/form-beasiswa"><Typography sx={{ textTransform: 'capitalize', px: 2, py: 1 }}>Daftar Beasiswa!</Typography></ColorButton>
					</Box>
				</Box>
			</Box>
			<Box sx={{ backgroundColor: '#698D01', mt: 2 }}>
				<Box sx={{ display: 'flex', color: 'white' }}>
					{berandaListInfo.map((info, index) =>
					(
						<InfoBeranda title={info.title} value={info.value} index={index} />
					)
					)}
				</Box>
			</Box>
			<Box sx={{ mx: 2, mb: 2 }} >
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
										<Button>
											<Card>
												<InfoCarousel
													title={info.pengajuan_bantuan_id.judul_galang_dana}
													description={info.pengajuan_bantuan_id.deskripsi}
													dana_terkumpul={info.total_nominal_terkumpul}
													dana_dibutuhkan={info.pengajuan_bantuan_id.dana_yang_dibutuhkan}
													durasi={info.durasi}
													jumlah_donatur={info.total_donatur}
													kategori={info.kategori}
													index={index}
												/>
											</Card>
										</Button>
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