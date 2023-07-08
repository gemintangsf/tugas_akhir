import { Typography, TextField, Container, Card, CardContent, Box, Button } from "@mui/material";
import Autocomplete from "@mui/material/Autocomplete";
import TimerOutlinedIcon from '@mui/icons-material/TimerOutlined';
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
							<TimelineDot color="success" />
							<TimelineConnector />
						</TimelineSeparator>
						<TimelineContent variant='body1' sx={{ width: 'max-content', fontWeight: '0' }}>Data Pribadi</TimelineContent>
					</TimelineItem>
					<TimelineItem>
						<TimelineSeparator>
							<TimelineDot />
						</TimelineSeparator>
						<TimelineContent variant='h4'>Upload Resi Transaksi</TimelineContent>
					</TimelineItem>
				</Timeline>
			</Box>
			<Box sx={{ display: 'flex', justifyContent: 'center' }}>
				<Card sx={{ width: 400, my: 3 }}>
					<CardContent sx={{ display: "flex", flexDirection: 'column' }}>
						<Box sx={{ display: 'flex', flexDirection: 'column', backgroundColor: '#F2F2F2', p: 1, borderRadius: '8px' }}>
							<div>
								<Typography variant="body2" color={'grey'}>Batas waktu pembayaran</Typography>
								<Typography variant="body1" fontWeight={'bold'}>Senin, 12 Juni 2023 19.20 WIB</Typography>
							</div>
							<div style={{ display: "flex", justifyContent: 'space-between', marginTop: '16px' }}>
								<div style={{ display: 'flex', alignItems: 'center' }}>
									<Typography variant='body2' sx={{}}>Status :</Typography>
									<Box border={1} borderRadius={8} borderColor={'red'} px={1} sx={{ ml: 1 }}>
										<Typography variant='caption' sx={{ color: 'red' }}>Pending</Typography>
									</Box>
								</div>
								<div style={{ display: "flex", alignItems: 'center' }}>
									<TimerOutlinedIcon fontSize="small" />
									<Typography variant="body2" sx={{ ml: 0.5 }}>00:59:59</Typography>
								</div>
							</div>
						</Box>
						<Typography sx={{ mt: 2 }}>Nomor Rekening Tujuan</Typography>
						<Box sx={{ borderRadius: '8px', backgroundColor: '#F2F2F2', p: 1 }}>
							<Typography variant="body2" >Bank Mandiri</Typography>
							<Typography>130000461239010</Typography>
						</Box>
						<Typography sx={{ mt: 2 }}>Jumlah Donasi</Typography>
						<Box sx={{ borderRadius: '8px', backgroundColor: '#F2F2F2', p: 1 }}>
							<Typography variant="body1" fontWeight={'bold'} >Rp100.000</Typography>
						</Box>
						<Typography variant="caption" sx={{ color: '#D80000' }}>*Lakukan pembayaran pada nomor rekening diatas sesuai jumlah donasi</Typography>
						<Typography sx={{ mt: 2 }}>Bukti Transaksi</Typography>
						<TextField type="file"></TextField>
						<Button href='/form-donasi' size="medium" variant="outlined" color="success" sx={{ mt: 4, textTransform: 'capitalize' }}>Kembali</Button>
						<Button size="medium" variant="contained" color="success" sx={{ mt: 1, textTransform: 'capitalize' }}>Submit</Button>
						<Typography variant="body2" sx={{ mt: 1 }}></Typography>
					</CardContent>
				</Card>
			</Box>
		</Container>

	)
}
export default IdentitasDiri