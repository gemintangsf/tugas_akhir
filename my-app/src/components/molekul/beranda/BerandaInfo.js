import { Box, Typography } from "@mui/material";
import BloodtypeOutlinedIcon from '@mui/icons-material/BloodtypeOutlined';
import HealthAndSafetyOutlinedIcon from '@mui/icons-material/HealthAndSafetyOutlined';
import HandshakeOutlinedIcon from '@mui/icons-material/HandshakeOutlined';
import VolunteerActivismOutlinedIcon from '@mui/icons-material/VolunteerActivismOutlined';

function InfoBeranda({ title, value, index }) {
	const getItemIcon = () => {
		let icon;
		switch (index) {
			case 0: icon = <BloodtypeOutlinedIcon sx={{ fontSize: 56 }} />
				break;
			case 1: icon = <HealthAndSafetyOutlinedIcon sx={{ fontSize: 56 }} />
				break;
			case 2: icon = <HandshakeOutlinedIcon sx={{ fontSize: 56 }} />
				break;
			case 3: icon = <VolunteerActivismOutlinedIcon sx={{ fontSize: 56 }} />
				break;
			default: break;
		}
		return icon;
	}
	return (
		<Box sx={{ backgroundColor: '#698D01', width: '100%' }}>
			<Box sx={{ display: 'flex', color: 'white', justifyContent: 'center', py: 6 }}>
				{getItemIcon()}
				<div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
					<Typography>{value}</Typography>
					<Typography>{title}</Typography>
				</div>
			</Box>
		</Box>
	)
}

export default InfoBeranda;

