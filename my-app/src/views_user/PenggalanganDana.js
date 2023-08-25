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
	const [identitas, setIdentitas] = useState('')
	const [jumlahDonatur, setJumlahDonatur] = useState([])
	const [penerima, setPenerima] = useState([])
	useEffect(() => {
		const getAllPenggalanganDana = async () => {
			await fetch(
				'http://localhost:8000/v1/penggalangan/penggalangan_dana/getAllPenggalanganDana',
				{
					method: 'GET',
					headers: {
						Accept: 'application/json',
						'Content-Type': 'application/json',
						'Access-Control-Allow-Origin': '*',
					}
				}
			)
				.then((response) => response.json())
				.then((data) => {
					setIdentitas(data.data[0]._id.$oid)
				}
				)
		}
		getAllPenggalanganDana()
	}, [])
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
					let arrayPenerima = []
					arrayData.push(data.data)
					console.log(data.data)
					arrayDonatur.push(data.data.data_donatur)
					for (let i; i < data.data.penerima_bantuan.length; i++) {
						arrayPenerima.push(data.data.penerima_bantuan[i])
					}
					console.log(data.data.penerima_bantuan)
					setInfo(arrayData)
					setJumlahDonatur(arrayDonatur)
					setPenerima(arrayPenerima)
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
						<Typography variant="h3">{data.penanggung_jawab.judul_galang_dana}</Typography>
						<div style={{ display: 'flex', marginTop: '8px' }}>

							<Box sx={{ width: '75%', marginRight: '32px' }}>
								<img src={GalangImage} style={{ width: '100%', height: '350px' }}></img>
								<Typography variant="body1" sx={{ color: 'grey' }}>{data.durasi + ' hari lagi'}</Typography>
								<Typography variant="body1" sx={{ mt: 2, textAlign: 'justify' }}>
									{data.penerima_bantuan.deskripsi}
								</Typography>
								<Typography variant="h5" sx={{ mt: 4 }}>Penanggung Jawab</Typography>
								<Box sx={{ display: 'flex' }}>
									<div style={{ display: 'flex' }}>
										<PersonOutlineOutlinedIcon />
										<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
											<Typography variant="body1">{data.penanggung_jawab.nama}</Typography>
											<Typography variant="body2" sx={{ color: 'grey' }}>Penanggung Jawab</Typography>
										</div>
									</div>
								</Box>
								<Typography variant="h5" sx={{ mt: 1 }}>Daftar Penerima Dana</Typography>
								<Box>
									<div style={{ display: 'flex' }}>
										<PersonOutlineOutlinedIcon />
										<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
											<Typography variant="body1">{data.penerima_bantuan[0].nama}</Typography>
											<Typography variant="body2" sx={{ color: 'grey' }}>Penerima Dana</Typography>
											<Typography>"{data.penerima_bantuan[0].deskripsi}"</Typography>
										</div>
									</div>
								</Box>
								<Box>
									<div style={{ display: 'flex' }}>
										<PersonOutlineOutlinedIcon />
										<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
											<Typography variant="body1">{data.penerima_bantuan[0].nama}</Typography>
											<Typography variant="body2" sx={{ color: 'grey' }}>Penerima Dana</Typography>
										</div>
									</div>
								</Box>
								<Box>
									<div style={{ display: 'flex' }}>
										<PersonOutlineOutlinedIcon />
										<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
											<Typography variant="body1">{data.penerima_bantuan[0].nama}</Typography>
											<Typography variant="body2" sx={{ color: 'grey' }}>Penerima Dana</Typography>
										</div>
									</div>
								</Box>
							</Box>
							<Card sx={{ width: 360, height: '100%' }}>
								<CardContent>
									<Typography><b>{'Rp' + data.total_nominal_terkumpul}</b> dari {data.penanggung_jawab.dana_yang_dibutuhkan}</Typography>
									<Typography sx={{ color: 'Grey', mt: 3 }}>{data.data_donatur[data.data_donatur.length - 1].total_donasi + ' Donations'}</Typography>
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
																	<Typography>{'Rp' + info.donasi_id}</Typography>
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