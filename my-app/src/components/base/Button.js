import { Typography, Button } from "@mui/material";

function ButtonBase({ text, variant }) {
	return (
		<Button variant={variant} size='medium' sx={{ height: '100%' }}>
			<Typography variant='body1' sx={{ textTransform: 'capitalize' }}>{text}</Typography>
		</Button>
	);
}

export default ButtonBase;
