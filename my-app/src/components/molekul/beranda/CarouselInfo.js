import { Typography, CardContent, Box } from "@mui/material";
import CarouselImage from "../../../assets/image_beranda/carousel_img.jpg"
import InsertEmoticonOutlinedIcon from '@mui/icons-material/InsertEmoticonOutlined'; import { useEffect, useState } from "react";
import KeyboardArrowRightIcon from '@mui/icons-material/KeyboardArrowRight';

function InfoCarousel({ image, title, description, dana_terkumpul, dana_dibutuhkan, durasi, jumlah_donatur, kategori, index, state }) {
	const [galangDana, setGalangDana] = useState([])

	useEffect(() => {
		const getAllPenggalanganDana = async () => {
			await fetch('http://localhost:8000/v1/penggalangan/penggalangan_dana/getAllPenggalanganDana',
				{
					method: 'GET',
					headers: {
						'Accept': 'application/json',
						'X-Requested-With': 'application/json',
						'Content-type': 'application/json; charset=UTF-8',
						'Access-Control-Allow-Origin': '*',
					},
				}
			)
				.then((response) => response.json())
				.then((data) => {
					setGalangDana(data)
					console.log(data)
				})
		}
		getAllPenggalanganDana()
	}, [])

	const getItemIcon = () => {
		let icon;
		switch (index) {
			case 0: icon = <InsertEmoticonOutlinedIcon />
				break;
			case 1: icon = <InsertEmoticonOutlinedIcon />
				break;
			case 2: icon = <InsertEmoticonOutlinedIcon />
				break;
			default: break;
		}
		return icon;
	}
	return (
		<Box>
			<CardContent>
				<img src={CarouselImage} style={{ width: '100%', height: '300px' }} />
				<Typography variant="h4">{title}</Typography>
				<Typography variant="caption" sx={{ color: '#616161', mt: 1 }}>{description}
				</Typography>
				<div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '16px' }}>
					<div style={{ display: 'flex' }}>
						<Typography sx={{ mr: 0.5 }}><b>{dana_terkumpul}</b></Typography>
						<Typography>dari</Typography>
						<Typography sx={{ color: '#616161', ml: 0.5 }}>{dana_dibutuhkan}</Typography>
					</div>
					<Typography>{durasi} hari lagi</Typography>
				</div>
				<div style={{ width: '100%', height: '16px', backgroundColor: '#D9D9D9', borderRadius: '2px', position: 'relative', marginTop: 2 }}>
					<div style={{ width: `calc(${dana_terkumpul / dana_dibutuhkan * 100}%)`, height: '16px', backgroundColor: '#8EC002', borderRadius: '2px', position: 'absolute', top: 0 }}>
					</div>
				</div>
				<div style={{ display: 'flex', flexDirection: 'row', justifyContent: 'space-between', marginTop: '50px' }}>
					<div style={{ display: 'flex' }}>
						{getItemIcon()}
						<Typography sx={{ color: '#616161', ml: 0.5 }}>{jumlah_donatur} Donatur</Typography>
					</div>
					<Typography sx={{ color: '#616161' }}>{kategori}</Typography>
					<div style={{ color: 'grey', display: 'flex', justifyContent: 'space-between' }} >
						<Typography sx={{ fontSize: '14px' }}>View more</Typography>
						<KeyboardArrowRightIcon />
					</div>
				</div>
			</CardContent>
		</Box>
	)
}
export default InfoCarousel;