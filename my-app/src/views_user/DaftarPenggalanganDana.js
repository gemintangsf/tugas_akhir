import Container from '@mui/material/Container'
import Typography from '@mui/material/Typography';
import InfoCardGalangDana from "../components/molekul/card/CardGalangDana";
import { useEffect, useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import Button from '@mui/material/Button'
import Box from '@mui/material/Box'
import Card from '@mui/material/Card'
import { CardContent } from '@mui/material';
import PersonOutlineIcon from '@mui/icons-material/PersonOutline';
import VolunteerActivismIcon from '@mui/icons-material/VolunteerActivism';
import ArrowForwardIcon from '@mui/icons-material/ArrowForward';
import GalangImage from '../assets/image_beranda/carousel_img.jpg';


function DaftarPenggalanganDana() {
	const { state } = useLocation()
	const [kategori, setKategori] = useState([])
	const [statusPengajuan, setStatusPengajuan] = useState('false')
	const [step, setStep] = useState(0);
	const data = state || ''

	useEffect(() => {
		const getPenggalanganDanaNonBeasiswa = async () => {
			await fetch('http://localhost:8000/v1/pengajuan/pengajuan_bantuan/getNonBeasiswaByKategori',
				{
					mode: 'cors',
					method: 'POST',
					headers: {
						Accept: 'application/json',
						'Content-Type': 'application/json',
						'Access-Control-Allow-Origin': '*',
					},
					body: JSON.stringify({
						kategori: state,
						is_pengajuan: statusPengajuan
					})
				})
				.then((response) => response.json())
				.then((data) => {
					let arrayData = []
					let arrayId = []
					for (let i = 0; i < data.data.length; i++) {
						arrayData.push(data.data[i])
					}
					setKategori(arrayData)

					console.log(data.data)
				})
		}
		getPenggalanganDanaNonBeasiswa()
		
	}, [])

	// const selectPenggalanganDanaNonBeasiswa = async (id) => {
	// 	await fetch(
	// 		'http://localhost:8000/v1/penggalangan/penggalangan_dana/selectPenggalanganDana',
	// 		{
	// 			method: 'POST',
	// 			headers: {
	// 				Accept: 'application/json',
	// 				'Content-Type': 'application/json',
	// 				'Access-Control-Allow-Origin': '*',
	// 			},
	// 			body: JSON.stringify({
	// 				id: id
	// 			})
	// 		})
	// }

	// const renderPenggalanganDanaDetail = () => {
	// 	return (
	// 		<Box sx={{ mt: 2, mb: 2 }}>
	// 			<Typography variant="h3">Judul Penggalangan Dana</Typography>
	// 			<div style={{ display: 'flex', marginTop: '8px' }}>
	// 				<Box sx={{ width: '75%', marginRight: '32px' }}>
	// 					<img src={GalangImage} style={{ width: '100%', height: '350px' }}></img>
	// 					<Typography variant="body1" sx={{ color: 'grey' }}>3 hari lagi</Typography>
	// 					<Typography variant="body1" sx={{ mt: 2, textAlign: 'justify' }}>Lorem Ipsum is simply dummy text of the printing and typesetting industry.
	// 						Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type
	// 						and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic
	// 						typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing
	// 						Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
	// 					</Typography>
	// 					<Typography variant="h5" sx={{ mt: 4 }}>Penanggung Jawab dan Penerima Dana</Typography>
	// 					<Box sx={{ display: 'flex', mt: 1 }}>
	// 						<div style={{ display: 'flex' }}>
	// 							<PersonOutlineIcon />
	// 							<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
	// 								<Typography variant="body1">Gemintang</Typography>
	// 								<Typography variant="body2" sx={{ color: 'grey' }}>Penanggung Jawab</Typography>
	// 							</div>
	// 						</div>
	// 						<ArrowForwardIcon sx={{ ml: 6 }} />
	// 						<div style={{ display: 'flex', marginLeft: '48px' }}>
	// 							<PersonOutlineIcon />
	// 							<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
	// 								<Typography variant="body1">Hasbi</Typography>
	// 								<Typography variant="body2" sx={{ color: 'grey' }}>Penerima Dana</Typography>
	// 							</div>
	// 						</div>
	// 					</Box>
	// 				</Box>
	// 				<Card sx={{ width: 360, height: '100%' }}>
	// 					<CardContent>
	// 						<Typography><b>Rp100.000</b> dari Rp170.000</Typography>
	// 						<Typography sx={{ color: 'Grey', mt: 3 }}>150 donations</Typography>
	// 						<Button href='/form-donasi' variant="contained" sx={{ mt: 2, width: '100%' }}><Typography sx={{ textTransform: 'capitalize' }}>Donasi Sekarang</Typography></Button>
	// 						<div style={{ display: 'flex', marginTop: '16px' }}>
	// 							<VolunteerActivismIcon />
	// 							<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
	// 								<Typography>Nama Donatur</Typography>
	// 								<Typography>Rp100.000</Typography>
	// 							</div>
	// 						</div>
	// 						<div style={{ display: 'flex', marginTop: '8px' }}>
	// 							<VolunteerActivismIcon />
	// 							<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
	// 								<Typography>Nama Donatur</Typography>
	// 								<Typography>Rp100.000</Typography>
	// 							</div>
	// 						</div>
	// 						<div style={{ display: 'flex', marginTop: '8px' }}>
	// 							<VolunteerActivismIcon />
	// 							<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
	// 								<Typography>Nama Donatur</Typography>
	// 								<Typography>Rp100.000</Typography>
	// 							</div>
	// 						</div>
	// 						<div style={{ display: 'flex', marginTop: '24px' }}>
	// 							<Button variant="outlined"><Typography sx={{ textTransform: 'capitalize' }}>Lihat Semua</Typography></Button>
	// 							<Button variant="outlined" sx={{ ml: 2 }}><Typography sx={{ textTransform: 'capitalize' }}>Donasi Teratas</Typography></Button>
	// 						</div>
	// 					</CardContent>
	// 				</Card>
	// 			</div>
	// 		</Box>
	// 	)
	// }
	return (
		<Container>
			<Typography fontWeight='bold' variant='h3' sx={{ mt: 2, color: '#212121' }}>Daftar Penggalangan Dana {state === 'Medis' ? 'Medis' : 'Bencana'}</Typography>
			<Box>
				{
					kategori.map((info, index) =>
					(
						<Link to='/penggalangan-dana' state={info.bantuan_dana_non_beasiswa_id} style={{ textDecoration: 'none' }}>
							<InfoCardGalangDana title={info.judul_galang_dana} description={info.deskripsi_galang_dana} donaturs={info.total_donatur} key={index} />
						</Link>
					))
				}
			</Box>
		</Container>
	)
}
export default DaftarPenggalanganDana;