import { Card, Typography } from "@mui/material";
import GroupIcon from "@mui/icons-material/Group";
import AutorenewIcon from "@mui/icons-material/Autorenew"
import FactCheckIcon from '@mui/icons-material/FactCheck';
import PostAddIcon from '@mui/icons-material/PostAdd';
import KeyboardArrowRightIcon from '@mui/icons-material/KeyboardArrowRight';

function InfoCard({ title, value, description, index }) {
	const getItemIcon = () => {
		let icon;
		switch (index) {
			case 0: icon = <GroupIcon sx={{ width: '56px', height: 'auto' }} />
				break;
			case 1: icon = <AutorenewIcon sx={{ width: '56px', height: 'auto' }} />
				break;
			case 2: icon = <FactCheckIcon sx={{ width: '56px', height: 'auto' }} />
				break;
			case 3: icon = <PostAddIcon sx={{ width: '56px', height: 'auto' }} />
				break;
			default: break;
		}
		return icon;
	}
	return (
		<Card sx={{ mt: 2 }}>
			<div style={{ minHeight: '60px', backgroundColor: '#1559E6', color: 'white', display: 'flex', alignItems: 'center' }}>
				<Typography variant="h4" sx={{ pl: 2 }}>{title}</Typography>
			</div>
			<div style={{ display: 'flex', flexDirection: 'column' }}>
				<div style={{ padding: '16px 0 16px 24px', display: 'flex' }}>
					{getItemIcon()}
					<div style={{ marginLeft: '8px', display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
						<Typography sx={{ fontSize: '16px' }}> {value}</Typography>
						<Typography sx={{ fontSize: '14px' }}>{description}</Typography>
					</div>
				</div>
				<div style={{ color: 'grey', padding: '16px 16px 16px 24px', boxShadow: '0px 0px 4px 0px rgba(0, 0, 0, 0.25) inset', display: 'flex', justifyContent: 'space-between' }}>
					<Typography sx={{ fontSize: '14px' }}>View more</Typography>
					<KeyboardArrowRightIcon />
				</div>
			</div>
		</Card>
	)
}

export default InfoCard;

