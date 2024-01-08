import { Typography, Box, Card, CardContent, Button, Divider, Container } from "@mui/material";
import VolunteerActivismOutlinedIcon from '@mui/icons-material/VolunteerActivismOutlined';
import GalangImage from '../assets/image_beranda/carousel_img.jpg';
import PersonOutlineOutlinedIcon from '@mui/icons-material/PersonOutlineOutlined';
import ArrowForwardIcon from '@mui/icons-material/ArrowForward';
import { json, useLocation, Link } from "react-router-dom";
import { useEffect, useState } from "react";


function PenggalanganDana() {
	const { state } = useLocation()
	const data = state || ''
	const [info, setInfo] = useState([])
	const [identitas, setIdentitas] = useState(data)
	const [jumlahDonatur, setJumlahDonatur] = useState([])
	const [jenis, setJenis] = useState('')
	const [penerimaDana, setPenerimaDana] = useState([])

	useEffect(() => {
		const selectPenggalanganDanaBeasiswa = async () => {
			await fetch('http://localhost:8000/v1/penggalangan/penggalangan_dana/selectPenggalanganDana',
				{
					method: 'POST',
					headers: {
						Accept: 'application/json',
						'Content-Type': 'application/json',
						'Access-Control-Allow-Origin': '*',
					},
					body: JSON.stringify({
						id: identitas
					})
				}
			)
			.then((response) => response.json())
			.then((data) => {
				let arrayData = []
				let arrayDonatur = []
				let arrayJenis = []
				let arrayPenerimaDana = []

				arrayData.push(data.data)
				arrayDonatur.push(data.data.data_donatur)
				arrayJenis.push(data.data.jenis)
				for (let i = 0; i < data.data.penerima_dana.length; i++) {
					arrayPenerimaDana.push(data.data.penerima_dana[i])
				}
				console.log(data.data.jenis + 'test')
				for (let i = 0; i < data.data.data_donatur.length; i++) {
					arrayDonatur.push(data.data.data_donatur[i])
				}
				setInfo(arrayData)
				setJumlahDonatur(arrayDonatur)
				setJenis(arrayJenis)
				setPenerimaDana(arrayPenerimaDana)
				console.log(arrayPenerimaDana)
			})
		}
		if (identitas) {
			selectPenggalanganDanaBeasiswa()
		}
	}, [identitas])
	return (
		<Container>
			{
				info.map((data, index) => (
					<Box sx={{ mt: 2, mb: 2 }} key={index}>
						<Typography variant="h3">{data.judul}</Typography>
						<div style={{ display: 'flex', marginTop: '8px' }}>

							<Box sx={{ width: '75%', marginRight: '32px' }}>
								<img src={GalangImage} style={{ width: '100%', height: '350px' }}></img>
								<Typography variant="body1" sx={{ color: 'grey' }}>{data.durasi + ' hari lagi'}</Typography>
								<Typography variant="body1" sx={{ textAlign: 'justify' }}>
									{data.deskripsi}
								</Typography>
								<Typography variant="h5" sx={{ mt: 4 }}>Penanggung Jawab</Typography>
								<Box sx={{ display: 'flex' }}>
									<div style={{ display: 'flex' }}>
										<PersonOutlineOutlinedIcon />
										{
											data.jenis === 'Beasiswa' ?
											<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
												<Typography variant="body1">{data.penanggung_jawab}</Typography>
												<Typography variant="body2" sx={{ color: 'grey' }}>Penanggung Jawab</Typography>
											</div>
											: 
											<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
												<Typography variant="body1">{data.penanggung_jawab.nama}</Typography>
												<Typography variant="body2" sx={{ color: 'grey' }}>Penanggung Jawab</Typography>
											</div>
										}	
									</div>
								</Box>
								<Typography variant="h5" sx={{ mt: 1 }}>Daftar Penerima Dana</Typography>
										{
											data.jenis === 'Beasiswa' ?
											<Box>
												{
													penerimaDana.map((val,index) => (
														<div style={{ display: 'flex' }}>
														<PersonOutlineOutlinedIcon />
															<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
																<Typography variant="body1">{val.mahasiswa_id.nama}</Typography>
																<Typography>{val.mahasiswa_id.nim}</Typography>
																<Typography variant="body2" sx={{ color: 'grey' }}>Penerima Dana</Typography>
															</div>
													
														</div>
													))
												}
											</Box>
											: 
											<Box>
												<div style={{ display: 'flex' }}>
													<PersonOutlineOutlinedIcon />
													
															<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
																<Typography variant="body1">{data.penerima_dana.nama}</Typography>
																<Typography>{data.penerima_dana.nomor_induk}</Typography>
																<Typography variant="body2" sx={{ color: 'grey' }}>Penerima Dana</Typography>
															</div>	
												</div>
											</Box>
										}
								</Box>
							<Card sx={{ width: 360, height: '100%' }}>
								<CardContent>
									<Box>
									{
										data.jenis === 'Beasiswa' ?
										<Typography><b>{'Rp' + data.total_nominal_terkumpul}</b> dari {data.target_dana}</Typography>
										:
										<Typography><b>{'Rp' + data.total_nominal_terkumpul}</b> dari {data.dana_yang_dibutuhkan}</Typography>
									}
									</Box>
									{
										data.data_donatur.length < 1 ?
											<Typography sx={{mt:1}}>0 Donations</Typography> :
											<Typography sx={{ color: 'Grey', mt: 1 }}>{data.data_donatur.length++ + ' Donations'}</Typography>
									}
									<Link to='/form-donasi' state={identitas}>
										<Button variant="contained" sx={{ mt: 2, width: '100%' }}><Typography sx={{ textTransform: 'capitalize' }}>Donasi Sekarang</Typography></Button>
									</Link>
									{
										jumlahDonatur[0]
										.map((info, index) => (
											<div>
												{index !== jumlahDonatur[0].length - 1 ?
													(
														<div style={{ display: 'flex', marginTop: '8px' }}>
															<VolunteerActivismOutlinedIcon />
															<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
																<Typography>{info.nama}</Typography>
																<Typography>{'Rp' + info.nominal_donasi}</Typography>
															</div>
														</div>
													)
													: null
												}
											</div>
										))
									}
									<div style={{ display: 'flex', marginTop: '24px' }}>
										<Button variant="outlined"><Typography sx={{ textTransform: 'capitalize' }}>Lihat Semua</Typography></Button>
										<Button variant="outlined" sx={{ ml: 2 }}><Typography sx={{ textTransform: 'capitalize' }}>Donasi Teratas</Typography></Button>
									</div>
								</CardContent>
							</Card>
						</div>
					</Box>
				))
			}
		</Container>
	)
}
export default PenggalanganDana;