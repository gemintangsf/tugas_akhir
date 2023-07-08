import Box from "@mui/material/Box"
import Typography from "@mui/material/Typography";
import ButtonBase from "../components/base/Button";
import { Button, Card, CardContent, Container, Grid, Link } from "@mui/material";
import InfoBeranda from "../components/molekul/beranda/BerandaInfo";
import InsertEmoticonOutlinedIcon from '@mui/icons-material/InsertEmoticonOutlined';
import InfoCarousel from "../components/molekul/beranda/CarouselInfo";
import HeaderBerandaUser from '../components/header/HeaderBerandaUser'
import ImageBerandaUser from '../assets/image_beranda/wisuda.jpg'
import { styled } from "@mui/material/styles";
import { useNavigate } from "react-router-dom";


function Beranda() {
	const navigate = useNavigate();
	const ColorButton = styled(Button)(({ theme }) => ({
		color: theme.palette.getContrastText('#FFFFFF'),
		backgroundColor: '#FFFFFF',
		'&:hover': {
			backgroundColor: '#9E9E9E',
		},
	}));
	const berandaListInfo = [
		{ title: 'Donatur', value: '500+' },
		{ title: 'Penggalangan Dana', value: '20+' },
		{ title: 'Penerima Dana Bantuan', value: '5+' },
		{ title: 'Dana Terkumpul', value: 'Rp17000000' }
	]
	const carouselInfo = [
		{ title: 'Judul Galang Dana', description: 'Deskripsi Galang Dana', dana_terkumpul: 'Rp1.000.000', dana_dibutuhkan: 'Rp1.700.000', durasi: '4 hari lagi', jumlah_donatur: '1.500', kategori: 'Medis', url: '/penggalangan-dana' },
		{ title: 'Judul Galang Dana', description: 'Deskripsi Galang Dana', dana_terkumpul: 'Rp1.000.000', dana_dibutuhkan: 'Rp1.700.000', durasi: '4 hari lagi', jumlah_donatur: '1.500', kategori: 'Medis', url: '/penggalangan-dana' },
		{ title: 'Judul Galang Dana', description: 'Deskripsi Galang Dana', dana_terkumpul: 'Rp1.000.000', dana_dibutuhkan: 'Rp1.700.000', durasi: '4 hari lagi', jumlah_donatur: '1.500', kategori: 'Medis', url: '/penggalangan-dana' },
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

						<Button href='/form-nonbeasiswa' variant='contained' size="small" color="success"><Typography sx={{ textTransform: 'capitalize', px: 2, py: 1 }}>Mulai Galang Dana</Typography></Button>
						<ColorButton href='/form-beasiswa' variant="outlined" size="small" color="success" sx={{ ml: 2 }}><Typography sx={{ textTransform: 'capitalize', px: 2, py: 1 }}>Daftar Beasiswa!</Typography></ColorButton>
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
			<Typography sx={{ fontSize: '20px', ml: 4, mt: 2, mb: 1 }}>Daftar Penggalangan Dana</Typography>
			<Grid container spacing={3} sx={{ px: 4 }}>
				{carouselInfo.map((info, index) =>
				(
					<Grid item xs={4}>

						<Card onClick={() => {
							navigate(info.url)
						}} variant="outlined" sx={{ borderColor: '#698D01', backgroundColor: 'white', mb: 3 }}>
							<InfoCarousel title={info.title} description={info.description} dana_terkumpul={info.dana_terkumpul} dana_dibutuhkan={info.dana_dibutuhkan} durasi={info.durasi} jumlah_donatur={info.jumlah_donatur} kategori={info.kategori} index={index} />
						</Card>

					</Grid>
				)
				)}
			</Grid>
		</Box >
	)
}
export default Beranda;