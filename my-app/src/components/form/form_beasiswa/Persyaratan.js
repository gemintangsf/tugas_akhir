import { Typography, TextField, Container, Card, CardContent, Box, Button } from "@mui/material";
import Timeline from '@mui/lab/Timeline';
import TimelineItem, { timelineItemClasses } from '@mui/lab/TimelineItem';
import TimelineSeparator from '@mui/lab/TimelineSeparator';
import TimelineConnector from '@mui/lab/TimelineConnector';
import TimelineContent from '@mui/lab/TimelineContent';
import TimelineDot from '@mui/lab/TimelineDot';

function Persyaratan() {
	return (
		<Container sx={{ display: 'flex' }}>
			<Box sx={{ width: '70%', display: 'flex', justifyContent: 'space-between' }}>
				<Box>
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
							<TimelineContent sx={{ width: 'max-content' }}><Typography variant='h4' sx={{ fontWeight: 'bold' }}>Daftar Beasiswa</Typography></TimelineContent>
						</TimelineItem>
						<TimelineItem>
							<TimelineSeparator>
								<TimelineDot color="success" />
								<TimelineConnector />
							</TimelineSeparator>
							<TimelineContent variant='body1' sx={{ width: 'max-content' }}>Data Pribadi</TimelineContent>
						</TimelineItem>
						<TimelineItem>
							<TimelineSeparator>
								<TimelineDot />
							</TimelineSeparator>
							<TimelineContent variant='h4'>Persyaratan</TimelineContent>
						</TimelineItem>
					</Timeline>
				</Box>
				<Box sx={{ display: 'flex', flexDirection: 'column', mt: 4 }}>
					<Typography variant='h4' sx={{ fontWeight: 'bold' }}>Persyaratan Calon Penerima Beasiswa</Typography>
					<Typography variant='body1' sx={{ mt: 3, color: '#636E72', fontWeight: 'bold' }}>Golongan UKT</Typography>
					<TextField select variant="outlined" size="small" label='Pilih Golongan UKT'></TextField>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Bukti Dokumen Golongan UKT</Typography>
					<TextField type="file">Bukti Golongan UKT</TextField>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Biaya Penghasilan Orang Tua /Bulan</Typography>
					<TextField select variant="outlined" size="small" label='Pilih Nominal (Rp)'></TextField>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Bukti Dokumen Penghasilan Orang Tua</Typography>
					<TextField type="file">Bukti Golongan UKT</TextField>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Jumlah Tanggungan Anggota Keluarga</Typography>
					<TextField select variant="outlined" size="small" label='Pilih Jumlah'></TextField>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Biaya Kebutuhan Perkuliahan</Typography>
					<TextField variant="outlined" size="small" label='Biaya Pangan (optional)'></TextField>
					<TextField variant="outlined" size="small" label='Biaya Transportasi (optional)' sx={{ mt: 1 }}></TextField>
					<TextField variant="outlined" size="small" label='Biaya Kuota Internet (optional)' sx={{ mt: 1 }}></TextField>
					<TextField variant="outlined" size="small" label='Biaya Kos (optional)' sx={{ mt: 1 }}></TextField>
					<div>
						<Button size="medium" variant="contained" sx={{ mt: 4, textTransform: 'capitalize' }}>Submit</Button>
						<Button href="/form-beasiswa" size="medium" variant="outlined" sx={{ mt: 4, ml: 1, textTransform: 'capitalize' }}>Sebelumnya</Button>
					</div>
				</Box>
			</Box>
		</Container>

	)
}
export default Persyaratan;