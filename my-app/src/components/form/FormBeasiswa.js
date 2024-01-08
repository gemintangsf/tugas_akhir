import { Typography, TextField, Container, Card, CardContent, Box, Button, MenuItem } from "@mui/material";
import Timeline from '@mui/lab/Timeline';
import TimelineItem, { timelineItemClasses } from '@mui/lab/TimelineItem';
import TimelineSeparator from '@mui/lab/TimelineSeparator';
import TimelineConnector from '@mui/lab/TimelineConnector';
import TimelineContent from '@mui/lab/TimelineContent';
import TimelineDot from '@mui/lab/TimelineDot';
import { useState } from "react";

function FormulirBeasiswa() {
	const [namaMahasiswa, setNamaMahasiswa] = useState('');
	const handleNamaMahasiswaChange = (val) => {
		setNamaMahasiswa(val)
	}
	const [nimMahasiswa, setNimMahasiswa] = useState('');
	const handleNimMahasiswaChange = (val) => {
		setNimMahasiswa(val)
	}
	const [noTelepon, setNoTelepon] = useState('');
	const handleNoTeleponChange = (val) => {
		setNoTelepon(val)
	}
	const [noRekening, setNoRekening] = useState('');
	const handleNoRekeningChange = (val) => {
		setNoRekening(val)
	}
	const [pemilikRekening, setPemilikRekening] = useState('');
	const handlePemilikRekeningChange = (val) => {
		setPemilikRekening(val)
	}
	const [bankRekening, setBankRekening] = useState('');
	const handleBankRekeningChange = (val) => {
		setBankRekening(val)
	}
	const [deskripsi, setDeskripsi] = useState('');
	const handleDeskripsi = (val) => {
		setDeskripsi(val)
	}
	const [golUkt, setGolUkt] = useState('');
	const handleGolUkt = (val) => {
		setGolUkt(val)
	}
	const [kuitansiPembayaranUkt, setKuitansiPembayaranUkt] = useState('');
	const handleKuitansiPembayaranUkt = (val) => {
		setKuitansiPembayaranUkt(val)
	}
	const [nominalPenghasilan, setNominalPenghasilan] = useState('');
	const handleNominalPenghasilan = (val) => {
		setNominalPenghasilan(val)
	}
	const [slipGaji, setSlipGaji] = useState('');
	const handleSlipGaji = (val) => {
		setSlipGaji(val)
	}
	const [dokumenEsai, setDokumenEsai] = useState('');
	const handleDokumenEsai = (val) => {
		setDokumenEsai(val)
	}
	const [jumlahTanggungan, setJumlahTanggungan] = useState('');
	const handleJumlahTanggungan = (val) => {
		setJumlahTanggungan(val)
		console.log(val)
	}
	const [biayaTransportasi, setBiayaTransportasi] = useState('');
	const handleBiayaTransportasi = (val) => {
		setBiayaTransportasi(val)
	}
	const [biayaKonsumsi, setBiayaKonsumsi] = useState('');
	const handleBiayaKonsumsi = (val) => {
		setBiayaKonsumsi(val)
	}
	const [biayaInternet, setBiayaInternet] = useState('');
	const handleBiayaInternet = (val) => {
		setBiayaInternet(val)
	}
	const [biayaKos, setBiayaKos] = useState('');
	const handleBiayaKos = (val) => {
		setBiayaKos(val)
	}
	const [biayaPengeluaran, setBiayaPengeluaran] = useState('');
	const handleBiayaPengeluaran = (val) => {
		setBiayaPengeluaran(val)
	}
	const [namaBank, setNamaBank] = useState('');
	const handleNamaBankChange = (val) => {
		setNamaBank(val)
	}
	const createPengajuanBeasiswa = async () => {
		await fetch('http://localhost:8000/v1/pengajuan/pengajuan_bantuan/createPengajuanBeasiswa',
			{
				mode: 'cors',
				method: 'POST',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
				body: JSON.stringify({
					"nama": namaMahasiswa,
					"nim": nimMahasiswa,
					"nomor_telepon": noTelepon,
					"nomor_rekening": noRekening,
					"nama_pemilik_rekening": pemilikRekening,
					"nama_bank": namaBank,
					"alasan_butuh_bantuan": deskripsi,
					"golongan_ukt": golUkt,
					"kuitansi_pembayaran_ukt": kuitansiPembayaranUkt,
					"gaji_orang_tua": nominalPenghasilan,
					"bukti_slip_gaji_orang_tua": slipGaji,
					"esai": dokumenEsai,
					"jumlah_tanggungan_keluarga": jumlahTanggungan,
					"biaya_transportasi": biayaTransportasi,
					"biaya_konsumsi": biayaKonsumsi,
					"biaya_internet": biayaInternet,
					"biaya_kos": biayaKos,
					"total_pengeluaran_keluarga": biayaPengeluaran
				}),
			})
			.then((response) => response.json())
			.then((data) => {
				console.log(data.id, 'test id');
			})
			.catch((err) => {
				console.log(err.message);
			})
	}
	const golonganUKT = [
		{
			value: '1',
			label: 'Golongan 1',
		},
		{
			value: '2',
			label: 'Golongan 2',
		},
		{
			value: '3',
			label: 'Golongan 3',
		},
		{
			value: '4',
			label: 'Golongan 4',
		},
		{
			value: '5',
			label: 'Golongan 5',
		},
		{
			value: '6',
			label: 'Golongan 6',
		},
		{
			value: '7',
			label: 'Golongan 7',
		},
		{
			value: '8',
			label: 'Golongan 8',
		},
	]
	const tanggunganKeluarga = [
		{
			value: '1',
			label: '1 Tanggungan'
		},
		{
			value: '2',
			label: '2 Tanggungan'
		},
		{
			value: '3',
			label: '3 Tanggungan'
		},
		{
			value: '4',
			label: '4 Tanggungan'
		},
		{
			value: '5',
			label: '>4 Tanggungan'
		},
	]
	const renderDataPribadiSection = () => {
		return (
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
					<Typography variant='body1' nama='nama' sx={{ mt: 3, color: '#636E72', fontWeight: 'bold' }}>Nama Mahasiswa</Typography>
					<TextField variant="outlined" size="small" label='cth: John Doe' onChange={(val) => { handleNamaMahasiswaChange(val.target.value) }}></TextField>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Nomor Induk Mahasiswa</Typography>
					<TextField variant="outlined" size="small" label='Pilih NIM' onChange={(val) => { handleNimMahasiswaChange(val.target.value) }}></TextField>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Nomor Telepon</Typography>
					<TextField variant="outlined" size="small" label='cth: 082121445524' onChange={(val) => { handleNoTeleponChange(val.target.value) }}></TextField>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Nama Pemilik Rekening</Typography>
					<TextField variant="outlined" size="small" label='cth: JOHN DOE' onChange={(val) => { handlePemilikRekeningChange(val.target.value) }}></TextField>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Nama Bank</Typography>
					<TextField variant="outlined" size="small" label='cth: Mandiri' onChange={(val) => { handleNamaBankChange(val.target.value) }}></TextField>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Nomor Rekening</Typography>
					<TextField variant="outlined" size="small" label='cth: 1300046201001' onChange={(val) => { handleNoRekeningChange(val.target.value) }}></TextField>
					<div>
						<Button size="medium" variant="contained" sx={{ mt: 4, textTransform: 'capitalize' }} onClick={() => setStep(1)}>Selanjutnya</Button>
					</div>
				</Box>
			</Box>
		)
	}
	const renderPersyaratanSection = () => {
		return (
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
					<Typography variant='body1' sx={{ mt: 3, color: '#636E72', fontWeight: 'bold' }}>Deksripsi Ajakan Galang Dana</Typography>
					<TextField variant="outlined" size="small" label='cth: Alasan membutuhkan biaya bantuan' onChange={(val) => { handleDeskripsi(val.target.value) }} />
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Golongan UKT</Typography>
					<TextField select variant="outlined" size="small" label='Pilih Golongan UKT' onChange={(val) => { handleGolUkt(val.target.value) }}>
						{
							golonganUKT.map((option) => (
								<MenuItem key={option.value} value={option.value}>
									{option.label}
								</MenuItem>
							))
						}
					</TextField>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Bukti Dokumen Golongan UKT</Typography>
					<TextField type="file" onChange={(val) => { handleKuitansiPembayaranUkt(val.target.value) }} />
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Biaya Penghasilan Orang Tua /Bulan</Typography>
					<TextField variant="outlined" size="small" label='Gaji Orangtua / bulan (Rp)' onChange={(val) => { handleNominalPenghasilan(val.target.value) }} />
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }} >Bukti Dokumen Penghasilan Orang Tua</Typography>
					<TextField type="file" onChange={(val) => { handleSlipGaji(val.target.value) }} />
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }} >Jumlah Tanggungan Anggota Keluarga</Typography>
					<TextField select variant="outlined" size="small" label='Pilih Jumlah' onChange={(val) => { handleJumlahTanggungan(val.target.value) }}>
						{
							tanggunganKeluarga.map((option) => (
								<MenuItem key={option.value} value={option.value} >
									{option.label}
								</MenuItem>
							))
						}
					</TextField>
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Biaya Kebutuhan Perkuliahan</Typography>
					<TextField variant="outlined" size="small" label='Biaya Kos / bulan (Rp)' onChange={(val) => { handleBiayaKos(val.target.value) }} />
					<TextField variant="outlined" size="small" label='Biaya Internet / bulan (Rp)' sx={{ mt: 1 }} onChange={(val) => { handleBiayaInternet(val.target.value) }} />
					<TextField variant="outlined" size="small" label='Biaya Pangan / bulan (Rp)' sx={{ mt: 1 }} onChange={(val) => { handleBiayaKonsumsi(val.target.value) }} />
					<TextField variant="outlined" size="small" label='Biaya Transportasi / bulan (Rp)' sx={{ mt: 1 }} onChange={(val) => { handleBiayaTransportasi(val.target.value) }} />
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Biaya Pengeluaran Keluarga</Typography>
					<TextField variant="outlined" size="small" label='Biaya Pengeluaran / bulan (Rp)' sx={{ mt: 1 }} onChange={(val) => { handleBiayaPengeluaran(val.target.value) }} />
					<Typography variant='body1' sx={{ mt: 2, color: '#636E72', fontWeight: 'bold' }}>Dokumen Esai</Typography>
					<TextField type="file" onChange={(val) => { handleDokumenEsai(val.target.value) }} />
					<div>
						<Button size="medium" variant="contained" sx={{ mt: 4, textTransform: 'capitalize' }} onClick={createPengajuanBeasiswa}>Submit</Button>
						<Button href="/form-beasiswa" size="medium" variant="outlined" sx={{ mt: 4, ml: 1, textTransform: 'capitalize' }}>Sebelumnya</Button>
					</div>
				</Box>
			</Box>
		)
	}
	const [step, setStep] = useState(0);
	return (
		<Container sx={{ display: 'flex' }}>
			{
				step === 0 ? renderDataPribadiSection() : renderPersyaratanSection()
			}

		</Container>

	)
}
export default FormulirBeasiswa