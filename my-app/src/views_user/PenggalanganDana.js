import { Typography, Box, Card, CardContent, Button, Divider, Container } from "@mui/material";
import VolunteerActivismOutlinedIcon from '@mui/icons-material/VolunteerActivismOutlined';
import GalangImage from '../assets/image_beranda/carousel_img.jpg';
import PersonOutlineOutlinedIcon from '@mui/icons-material/PersonOutlineOutlined';
import ArrowForwardIcon from '@mui/icons-material/ArrowForward';

function PenggalanganDana() {
	return (
		<Container>
			<Box sx={{ mt: 2, mb: 2 }}>
				<Typography variant="h3">Judul Penggalangan Dana</Typography>
				<div style={{ display: 'flex', marginTop: '8px' }}>

					<Box sx={{ width: '75%', marginRight: '32px' }}>
						<img src={GalangImage} style={{ width: '100%', height: '350px' }}></img>
						<Typography variant="body1" sx={{ color: 'grey' }}>3 hari lagi</Typography>
						<Typography variant="body1" sx={{ mt: 2, textAlign: 'justify' }}>Lorem Ipsum is simply dummy text of the printing and typesetting industry.
							Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type
							and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic
							typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing
							Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
						</Typography>
						<Typography variant="h5" sx={{ mt: 4 }}>Penanggung Jawab dan Penerima Dana</Typography>
						<Box sx={{ display: 'flex', mt: 1 }}>
							<div style={{ display: 'flex' }}>
								<PersonOutlineOutlinedIcon />
								<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
									<Typography variant="body1">Gemintang</Typography>
									<Typography variant="body2" sx={{ color: 'grey' }}>Penanggung Jawab</Typography>
								</div>
							</div>
							<ArrowForwardIcon sx={{ ml: 6 }} />
							<div style={{ display: 'flex', marginLeft: '48px' }}>
								<PersonOutlineOutlinedIcon />
								<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
									<Typography variant="body1">Hasbi</Typography>
									<Typography variant="body2" sx={{ color: 'grey' }}>Penerima Dana</Typography>
								</div>
							</div>
						</Box>

					</Box>

					<Card sx={{ width: 360, height: '100%' }}>
						<CardContent>
							<Typography><b>Rp100.000</b> dari Rp170.000</Typography>
							<Typography sx={{ color: 'Grey', mt: 3 }}>150 donations</Typography>
							<Button href='/form-donasi' variant="contained" sx={{ mt: 2, width: '100%' }}><Typography sx={{ textTransform: 'capitalize' }}>Donasi Sekarang</Typography></Button>
							<div style={{ display: 'flex', marginTop: '16px' }}>
								<VolunteerActivismOutlinedIcon />
								<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
									<Typography>Nama Donatur</Typography>
									<Typography>Rp100.000</Typography>
								</div>
							</div>
							<div style={{ display: 'flex', marginTop: '8px' }}>
								<VolunteerActivismOutlinedIcon />
								<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
									<Typography>Nama Donatur</Typography>
									<Typography>Rp100.000</Typography>
								</div>
							</div>
							<div style={{ display: 'flex', marginTop: '8px' }}>
								<VolunteerActivismOutlinedIcon />
								<div style={{ display: 'flex', flexDirection: 'column', marginLeft: '8px' }}>
									<Typography>Nama Donatur</Typography>
									<Typography>Rp100.000</Typography>
								</div>
							</div>
							<div style={{ display: 'flex', marginTop: '24px' }}>
								<Button variant="outlined"><Typography sx={{ textTransform: 'capitalize' }}>Lihat Semua</Typography></Button>
								<Button variant="outlined" sx={{ ml: 2 }}><Typography sx={{ textTransform: 'capitalize' }}>Donasi Teratas</Typography></Button>
							</div>
						</CardContent>
					</Card>
				</div>
			</Box>

		</Container>
	)

}
export default PenggalanganDana;