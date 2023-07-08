import { Typography, TextField, Container, Card, CardContent, Box, Button } from "@mui/material";
import Timeline from '@mui/lab/Timeline';
import TimelineItem, { timelineItemClasses } from '@mui/lab/TimelineItem';
import TimelineSeparator from '@mui/lab/TimelineSeparator';
import TimelineConnector from '@mui/lab/TimelineConnector';
import TimelineContent from '@mui/lab/TimelineContent';
import TimelineDot from '@mui/lab/TimelineDot';

function GalangDana() {
	return (
		<Container sx={{ display: 'flex' }}>
			<Box sx={{ width: '70%', display: 'flex', justifyContent: 'space-between' }}>
				<Box sx={{ minWidth: '50%' }}>
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
							<TimelineContent sx={{ width: 'max-content' }}><Typography variant='h3' sx={{ fontWeight: 'bold' }}>Pengajuan Bantuan Dana</Typography></TimelineContent>
						</TimelineItem>
						<TimelineItem>
							<TimelineSeparator>
								<TimelineDot color="success" />
								<TimelineConnector />
							</TimelineSeparator>
							<TimelineContent variant='body1' sx={{ width: 'max-content', fontWeight: '0' }}>Calon Penerima Bantuan Dana</TimelineContent>
						</TimelineItem>
						<TimelineItem>
							<TimelineSeparator>
								<TimelineDot color="success" />
								<TimelineConnector />
							</TimelineSeparator>
							<TimelineContent variant='body1' sx={{ width: 'max-content', fontWeight: '0' }}>Penanggung Jawab</TimelineContent>
						</TimelineItem>
						<TimelineItem>
							<TimelineSeparator>
								<TimelineDot color="success" />
								<TimelineConnector />
							</TimelineSeparator>
							<TimelineContent variant='body1'>Persyaratan</TimelineContent>
						</TimelineItem>
						<TimelineItem>
							<TimelineSeparator>
								<TimelineDot />
							</TimelineSeparator>
							<TimelineContent variant='h4'>Informasi Lainnya</TimelineContent>
						</TimelineItem>
					</Timeline>
				</Box>
				<Box sx={{ minWidth: '50%', display: 'flex', flexDirection: 'column', mt: 4 }}>
					<Typography variant='h3' sx={{ fontWeight: 'bold' }}>Informasi Penggalangan dan Penyaluran Dana</Typography>
					<Typography variant='body1' sx={{ mt: 3, color: '#636E72', fontWeight: 'bold' }}>Nominal Galang Dana</Typography>
					<TextField variant="outlined" size="small" label='cth: 5000000'></TextField>
					<Typography variant="caption" sx={{ color: 'red' }}>*Nominal dana yang dibutuhkan</Typography>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Tanggal Berakhir Galang Dana</Typography>
					<TextField variant="outlined" size="small" type="date"></TextField>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Nama Pemilik Rekening Penerima Dana</Typography>
					<TextField variant="outlined" size="small" label='cth: JOHN DOE'></TextField>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Bank Rekening Penerima Dana</Typography>
					<TextField variant="outlined" size="small" label='cth: Bank Mandiri'></TextField>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Nomor Rekening Penerima Dana</Typography>
					<TextField variant="outlined" size="small" label='cth: 130004621001'></TextField>
					<Typography variant="caption" sx={{ color: 'red' }}>*Pastikan seluruh informasi diisi dengan benar!</Typography>
					<div>
						<Button href='/beranda' size="medium" variant="contained" sx={{ mt: 4, textTransform: 'capitalize' }}>Submit</Button>
						<Button href='/form-nonbeasiswa/penanggungjawab/persyaratan-medis' size="medium" variant="outlined" sx={{ mt: 4, ml: 2, textTransform: 'capitalize' }}>Sebelumnya</Button>
					</div>
				</Box>
			</Box>
		</Container>
	)
}
export default GalangDana;