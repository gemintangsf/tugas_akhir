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
							<TimelineContent sx={{ width: 'max-content' }}><Typography variant='h3' sx={{ fontWeight: 'bold' }}>Daftar Beasiswa</Typography></TimelineContent>
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
							<TimelineContent variant='body1'>Persyaratan</TimelineContent>
						</TimelineItem>
					</Timeline>
				</Box>
				<Box sx={{ display: 'flex', flexDirection: 'column', mt: 4 }}>
					<Typography variant='h3' sx={{ fontWeight: 'bold' }}>Identitas Calon Penerima Beasiswa</Typography>
					<Typography variant='body1' sx={{ mt: 3, color: '#636E72', fontWeight: 'bold' }}>Nama Mahasiswa</Typography>
					<TextField variant="outlined" size="small" label='cth: John Doe'></TextField>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Nomor Induk Mahasiswa</Typography>
					<TextField select variant="outlined" size="small" label='Pilih NIM'></TextField>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Nomor Telepon</Typography>
					<TextField variant="outlined" size="small" label='cth: 082121445524'></TextField>
					<div>
						<Button href='/form-beasiswa/persyaratan' size="medium" variant="contained" sx={{ mt: 4, textTransform: 'capitalize' }}>Selanjutnya</Button>
					</div>
				</Box>
			</Box>
		</Container>

	)
}
export default IdentitasDiri