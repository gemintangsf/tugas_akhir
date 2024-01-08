import { Typography, CardContent, Button, Container, Card } from "@mui/material";
import Diversity1OutlinedIcon from '@mui/icons-material/Diversity1Outlined';
import FundraiseImg from '../../../assets/image_beranda/fundraising_img.jpg'

function InfoCardGalangDana({ title, description, donaturs }) {
	return (
		<Card sx={{ mt: 2 }}>
			<CardContent sx={{ display: 'flex' }}>
				<div>
					<img src={FundraiseImg} alt="" style={{ borderRadius: '16px', height: '220px' }} />
				</div>
				<div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'space-between', width: '100%' }}>
					<div>
						<Typography variant='h3' sx={{ ml: 2 }}>{title}</Typography>
						<Typography variant='body2' sx={{ mt: 1, ml: 2, textAlign: 'justify' }}>{description}</Typography>
					</div>
					<div style={{ display: 'flex', justifyContent: 'space-between', marginLeft: '16px' }}>
						<div style={{ display: 'flex', alignItems: 'center' }}>
							<Diversity1OutlinedIcon fontSize="small" />
							<Typography variant='body2' color={'grey'} sx={{ ml: 0.5 }}>{donaturs} Donatur</Typography>
						</div>
						<div>
							<Button href='/penggalangan-dana' size='small' variant='outlined' color="success"><Typography sx={{ textTransform: 'capitalize' }}>Lihat Detail</Typography></Button>
						</div>
					</div>
				</div>
			</CardContent>
		</Card>
	)
}
export default InfoCardGalangDana;