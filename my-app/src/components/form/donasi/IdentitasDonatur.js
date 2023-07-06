import { Typography, TextField, Container, Card, CardContent, Box, Button } from "@mui/material";
import Timeline from '@mui/lab/Timeline';
import TimelineItem, { timelineItemClasses } from '@mui/lab/TimelineItem';
import TimelineSeparator from '@mui/lab/TimelineSeparator';
import TimelineConnector from '@mui/lab/TimelineConnector';
import TimelineContent from '@mui/lab/TimelineContent';
import TimelineDot from '@mui/lab/TimelineDot';

function IdentitasDiri() {
	return (
		<Container sx={{ display: 'flex' }}>
			<Box sx={{ width: '35%', display: 'flex', justifyContent: 'space-between' }}>
				<Timeline
					sx={{
						[`& .${timelineItemClasses.root}:before`]: {
							flex: 0,
						},
					}}
				>
					<TimelineItem>
						<TimelineSeparator>
							<TimelineDot color="error" variant="outlined" />
							<TimelineConnector />
						</TimelineSeparator>
						<TimelineContent sx={{ width: 'max-content' }}><Typography variant='h3' sx={{ fontWeight: 'bold' }}>Donasi</Typography></TimelineContent>
					</TimelineItem>
					<TimelineItem>
						<TimelineSeparator>
							<TimelineDot />
							<TimelineConnector />
						</TimelineSeparator>
						<TimelineContent variant='h4' sx={{ width: 'max-content', fontWeight: '0' }}>Data Pribadi</TimelineContent>
					</TimelineItem>
					<TimelineItem>
						<TimelineSeparator>
							<TimelineDot />
						</TimelineSeparator>
						<TimelineContent variant='body1'>Upload Resi Transaksi</TimelineContent>
					</TimelineItem>
				</Timeline>
			</Box>
			<Box sx={{ display: 'flex', justifyContent: 'center' }}>
				<Card sx={{ width: 400, my: 3 }}>
					<CardContent sx={{ display: "flex", flexDirection: 'column' }}>
						<Typography variant='body1'>Data Donatur</Typography>
						<TextField variant="outlined" size="small" label='Nama Donatur' sx={{ mt: 1 }}></TextField>
						<TextField variant="outlined" size="small" label='No Telepon' sx={{ mt: 2 }}></TextField>
						<Typography variant="body1" sx={{ mt: 3 }}>Masukkan Nominal Donasi</Typography>
						<TextField variant="outlined" size="small" label='Rp' sx={{ mt: 1 }}></TextField>
						<Typography variant="body1" sx={{ mt: 3 }}>Pesan (Optional)</Typography>
						<TextField variant="outlined" size="large" label='Tulis doa atau harapan untuk penggalangan dana' sx={{ mt: 1 }}></TextField>
						<Button href='/form-donasi/upload-struk' size="medium" variant="contained" color="success" sx={{ mt: 4, textTransform: 'capitalize' }}>Lanjut Pembayaran</Button>
					</CardContent>
				</Card>
			</Box>
		</Container>

	)
}
export default IdentitasDiri