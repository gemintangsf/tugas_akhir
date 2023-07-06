import { Typography, CardContent } from "@mui/material";
import CarouselImage from "../../../assets/image_beranda/carousel_img.jpg"
import InsertEmoticonOutlinedIcon from '@mui/icons-material/InsertEmoticonOutlined';;

function InfoCarousel({ title, description, dana_terkumpul, dana_dibutuhkan, durasi, jumlah_donatur, kategori, index }) {
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
		<CardContent>
			<img src={CarouselImage} style={{ width: '100%', height: '300px' }} />
			<Typography sx={{ fontSize: '20px' }}>{title}</Typography>
			<Typography sx={{ fontSize: '14px', color: '#616161', mt: 1 }}>{description}
			</Typography>
			<div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '16px' }}>
				<div style={{ display: 'flex' }}>
					<Typography><b>{dana_terkumpul}</b></Typography>
					<Typography sx={{ color: '#616161', ml: 1 }}>{dana_dibutuhkan}</Typography>
				</div>
				<Typography>{durasi}</Typography>
			</div>
			<div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '50px' }}>
				<div style={{ display: 'flex' }}>
					{getItemIcon()}
					<Typography sx={{ color: '#616161', ml: 0.5 }}>{jumlah_donatur} Donatur</Typography>
				</div>
				<Typography sx={{ color: '#616161' }}>{kategori}</Typography>
			</div>
		</CardContent>
	)
}
export default InfoCarousel;