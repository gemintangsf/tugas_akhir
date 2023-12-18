import { Typography, TextField, Container, Card, CardContent, Box, Button } from "@mui/material";
import Autocomplete from "@mui/material/Autocomplete";
import TimerOutlinedIcon from '@mui/icons-material/TimerOutlined';
import Timeline from '@mui/lab/Timeline';
import TimelineItem, { timelineItemClasses } from '@mui/lab/TimelineItem';
import TimelineSeparator from '@mui/lab/TimelineSeparator';
import TimelineConnector from '@mui/lab/TimelineConnector';
import TimelineContent from '@mui/lab/TimelineContent';
import TimelineDot from '@mui/lab/TimelineDot';
import { useEffect, useState } from "react";
import { useLocation } from "react-router-dom";


function FormulirDonasi() {
	const { state } = useLocation()
	console.log(state)
	const [countTime, setCountTime] = useState('')

	// const countDownMinutes = () => {
	// 	var now = new Date().getTime()
	// 	var distance = countDownDate - now

	// 	var minutes = Math.floor((distance % (1000 * 60 * 60)) / 1000 * 60)
	// 	return (
	// 		{ minutes }
	// 	)
	// }
	const [namaDonatur, setNamaDonatur] = useState('')
	const [noTeleponDonatur, setNoTeleponDonatur] = useState('')
	const [nominalDonasi, setNominalDonasi] = useState('')
	const [nomorRekening, setNomorRekening] = useState('')
	const [namaBank, setNamaBank] = useState('')
	const [namaPemilikRekening, setNamaPemilikRekening] = useState('')
	const [strukPembayaran, setStrukPembayaran] = useState('')
	const [bankAdmin, setBankAdmin] = useState([])
	const [pendingDonasi, setPendingDonasi] = useState([])
	const [nomorReferensi, setNomorReferensi] = useState('')

	const [step, setStep] = useState(0);

	const handleNamaDonaturChange = (val) => {
		setNamaDonatur(val)
	}
	const handleNoTeleponDonaturChange = (val) => {
		setNoTeleponDonatur(val)
	}
	const handleNominalDonasiChange = (val) => {
		setNominalDonasi(val)
	}
	const handleNomorRekeningChange = (val) => {
		setNomorRekening(val)
	}
	const handleNamaBankChange = (val) => {
		setNamaBank(val)
	}
	const handleNamaPemilikRekeningChange = (val) => {
		setNamaPemilikRekening(val)
	}
	const handleStrukPembayaranChange = (val) => {
		setStrukPembayaran(val)
	}

	const createDonasi = async () => {
		await fetch('http://localhost:8000/v1/penggalangan/donasi/createDonasi',
			{
				mode: 'cors',
				method: 'POST',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
				body: JSON.stringify({
					"id": state,
					"nama": namaDonatur,
					"nomor_telepon": noTeleponDonatur,
					"nominal_donasi": nominalDonasi,
					"nomor_rekening": nomorRekening,
					"nama_pemilik_rekening": namaPemilikRekening,
					"nama_bank": namaBank
				}),
			})
			.then((response) => response.json())
			.then((data) => {
				console.log(data.data.donasi.nomor_referensi);
				setNomorReferensi(data.data.donasi.nomor_referensi)
			})
			.catch((err) => {
				console.log(err.message);
			})
		setStep(1)
	}


	useEffect(() => {
		const getPendingDonasi = async () => {
			await fetch('http://localhost:8000/v1/penggalangan/donasi/getPendingDonasi',
				{
					mode: 'cors',
					method: 'POST',
					headers: {
						Accept: 'application/json',
						'Content-Type': 'application/json',
						'Access-Control-Allow-Origin': '*',
					},
					body: JSON.stringify({
						nomor_referensi: nomorReferensi
					})
				})
				.then((response) => response.json())
				.then((data) => {
					console.log(data.data)
					let arrayData = []
					arrayData.push(data.data)
					setPendingDonasi(arrayData)
				})
		}
		if (step === 1) {
			getPendingDonasi()
		}
	}, [step])

	const uploadStrukPembayaran = async () => {
		await fetch('http://localhost:8000/v1/penggalangan/donasi/uploadStrukPembayaran',
			{
				mode: 'cors',
				method: 'POST',
				headers: {
					Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
				body: JSON.stringify({
					"nomor_referensi": nomorReferensi,
					"struk_pembayaran": strukPembayaran
				})
			})
			.then((response) => response.json())
			.then((data) => {
				console.log(data.data);

			})
	}
	const renderDataPribadiSection = () => {
		return (
			<Box sx={{ width: '70%', display: 'flex', justifyContent: 'space-between' }}>
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
							<Typography variant='body1'>Nama Donatur</Typography>
							<TextField variant="outlined" size="small" label='cth: John Doe' onChange={(val) => { handleNamaDonaturChange(val.target.value) }} />
							<Typography variant="body1" sx={{ mt: 2 }}>Nomor Telepon Donatur</Typography>
							<TextField variant="outlined" size="small" label='cth: 082121445524' onChange={(val) => { handleNoTeleponDonaturChange(val.target.value) }} />
							<Typography variant="body1" sx={{ mt: 2 }}>Nominal Donasi</Typography>
							<TextField variant="outlined" size="small" label='cth: 50000 (Rp)' onChange={(val) => handleNominalDonasiChange(val.target.value)} />
							<Typography variant="body1" sx={{ mt: 2 }}>Nama Bank</Typography>
							<TextField variant="outlined" size="small" label='cth: Mandiri' onChange={(val) => handleNamaBankChange(val.target.value)} />
							<Typography variant="body1" sx={{ mt: 2 }}>Nomor Rekening</Typography>
							<TextField variant="outlined" size="small" label='cth: 1300046121001' onChange={(val) => handleNomorRekeningChange(val.target.value)} />
							<Typography variant="body1" sx={{ mt: 2 }}>Nama Pemilik Rekening</Typography>
							<TextField variant="outlined" size="small" label='cth: HASBI' onChange={(val) => handleNamaPemilikRekeningChange(val.target.value)} />

							<Button size="medium" variant="contained" color="success" onClick={createDonasi} sx={{ mt: 4, textTransform: 'capitalize' }}>Lanjut Pembayaran</Button>
						</CardContent>
					</Card>
				</Box>
			</Box>
		)
	}

	const renderPersyaratanSection = () => {
		return (
			<Box sx={{ width: '70%', display: 'flex', justifyContent: 'space-between' }}>
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
							{
								pendingDonasi
									.map((info, index) => (
										<Box sx={{ display: 'flex', flexDirection: 'column', backgroundColor: '#F2F2F2', p: 1, borderRadius: '8px' }}>
											<div>
												<Typography variant="body2" color={'grey'}>Batas waktu pembayaran</Typography>
												<Typography variant="body1" fontWeight={'bold'}>{info.waktu_berakhir}</Typography>
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
													<Typography variant="body2" sx={{ ml: 0.5 }}>{ }</Typography>
												</div>
											</div>
										</Box>
									))
							}
							<Typography sx={{ mt: 2 }}>Nomor Rekening Tujuan</Typography>
							{
								pendingDonasi
									.map((info, index) => (
										<Box sx={{ borderRadius: '8px', backgroundColor: '#F2F2F2', p: 1 }}>
											<Typography variant="body2" >{info.rekening_bank.nama_bank}</Typography>
											<Typography>{info.rekening_bank.nomor_rekening}</Typography>
											<Typography>{info.rekening_bank.nama_pemilik_rekening}</Typography>
										</Box>
									))
							}

							<Typography sx={{ mt: 2 }}>Jumlah Donasi</Typography>
							<Box sx={{ borderRadius: '8px', backgroundColor: '#F2F2F2', p: 1 }}>
								<Typography variant="body1" fontWeight={'bold'} >{nominalDonasi}</Typography>
							</Box>
							<Typography variant="caption" sx={{ color: '#D80000' }}>*Lakukan pembayaran sesuai jumlah donasi</Typography>
							<Typography sx={{ mt: 2 }}>Bukti Transaksi</Typography>
							<TextField type="file" onChange={(val) => handleStrukPembayaranChange(val.target.value)}></TextField>
							<Button size="medium" variant="outlined" onClick={() => setStep(0)} color="success" sx={{ mt: 4, textTransform: 'capitalize' }}>Kembali</Button>
							<Button size="medium" variant="contained" color="success" sx={{ mt: 1, textTransform: 'capitalize' }} onClick={uploadStrukPembayaran}>Submit</Button>
							<Typography variant="body2" sx={{ mt: 1 }}></Typography>
						</CardContent>
					</Card>
				</Box>
			</Box>
		)
	}
	return (
		<Container sx={{ display: 'flex' }}>
			{
				step === 0 ? renderDataPribadiSection() : renderPersyaratanSection()
			}
		</Container>
	)
}
export default FormulirDonasi