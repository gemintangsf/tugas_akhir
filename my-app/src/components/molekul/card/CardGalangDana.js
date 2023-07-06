import { Typography, CardContent, Button, Container, Card } from "@mui/material";
import Diversity1OutlinedIcon from '@mui/icons-material/Diversity1Outlined';
import WisudaImg from '../../../assets/image_beranda/wisuda.jpg'

function InfoCardGalangDana({ title, description, donaturs }) {
	return (
		<Card sx={{ mt: 2 }}>
			<CardContent sx={{ display: 'flex' }}>
				<div>
					<img src={WisudaImg} alt="" style={{ borderRadius: '16px', height: '220px' }} />
				</div>
				<div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
					<div>
						<Typography variant='h6' sx={{ ml: 2 }}>{title}</Typography>
						<Typography variant='body2' sx={{ mt: 1, ml: 2, textAlign: 'justify' }}>{description}</Typography>
					</div>
					<div style={{ display: 'flex', justifyContent: 'space-between', marginLeft: '16px' }}>
						<div style={{ display: 'flex', alignItems: 'center' }}>
							<Diversity1OutlinedIcon fontSize="small" />
							<Typography variant='body2' color={'grey'} sx={{ ml: 0.5 }}>{donaturs} Donatur</Typography>
						</div>
						<div>
							<Button href='/form-donasi' size='small' variant='outlined'><Typography sx={{ textTransform: 'capitalize' }}>Donasi</Typography></Button>
						</div>
					</div>
				</div>
			</CardContent>
		</Card>
	)
}
export default InfoCardGalangDana;