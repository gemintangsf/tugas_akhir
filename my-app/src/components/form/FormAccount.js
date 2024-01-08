
import { Typography, TextField, Container, MenuItem, Box, Button, Card, CardContent } from "@mui/material";
import { useState } from "react";
import Timeline from '@mui/lab/Timeline';
import TimelineItem, { timelineItemClasses } from '@mui/lab/TimelineItem';
import TimelineSeparator from '@mui/lab/TimelineSeparator';
import TimelineConnector from '@mui/lab/TimelineConnector';
import TimelineContent from '@mui/lab/TimelineContent';
import TimelineDot from '@mui/lab/TimelineDot';
function RegistrasiAccount () {
    const [nama, setNama] = useState('')
    const [role, setRole] = useState('')
    const [username, setUsername] = useState('')
    const [namaBank, setNamaBank] = useState('')
    const [nomorRekening, setNomorRekening] = useState('')
    const [namaPemilikRekening, setNamaPemilikRekening] = useState('')
    const [nomorTelepon, setNomorTelepon] = useState('')
    const [password, setPassword] = useState('')
    const [passwordConfirm, setPasswordConfirm] = useState('')

    const handleNamaChange = (val) => {
		setNama(val)
	}
    const handleRoleChange = (val) => {
		setRole(val)
	}
    const handleUsernameChange = (val) => {
		setUsername(val)
	}
    const handleNamaBankChange = (val) => {
		setNamaBank(val)
	}
    const handleNomorRekeningChange = (val) => {
		setNomorRekening(val)
	}
    const handleNamaPemilikRekeningChange = (val) => {
		setNamaPemilikRekening(val)
	}
    const handleNomorTeleponChange = (val) => {
        setNomorTelepon(val)
    }
    const handlePasswordChange = (val) => {
        setPassword(val)
    }
    const handlePasswordConfirmChange = (val) => {
		setPasswordConfirm(val)
	}
    
    const selectRole = [
        {
            label: 'Penanggung Jawab JTK Berbagi',
            value: 0,
        },
        {
            label: 'Penanggung Jawab Pihak Jurusan',
            value: 1
        },
    ];
    const daftarAkun = async () => {
        await fetch(
        'http://localhost:8000/v1/user/penanggung_jawab/createPenanggungJawab',
            {
                method: 'POST',
                headers: {
                    Accept: 'application/json',
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
                },
                body: JSON.stringify({
                    nama: nama,
                    role: role,
                    username: username,
                    nama_bank: namaBank,
                    nomor_rekening: nomorRekening,
                    nama_pemilik_rekening: namaPemilikRekening,
                    password: password,
                    password_confirmation: passwordConfirm,
                    nomor_telepon: nomorTelepon
                })
            })
            .then((response) => response.json())
            .then((data) => {
                console.log(data.data, 'test')
            })
    }
    return (
        <Container>
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
							<TimelineContent sx={{ width: 'max-content' }}><Typography variant='h3' sx={{ fontWeight: 'bold' }}>Daftar Akun Baru</Typography></TimelineContent>
						</TimelineItem>
						<TimelineItem>
							<TimelineSeparator>
								<TimelineDot />
							</TimelineSeparator>
							<TimelineContent variant='h4' sx={{ width: 'max-content', fontWeight: '0' }}>Data Pribadi</TimelineContent>
						</TimelineItem>
					</Timeline>
				</Box>
				<Box sx={{ display: 'flex', justifyContent: 'center' }}>
					<Card sx={{ width: 400, my: 3 }}>
						<CardContent sx={{ display: "flex", flexDirection: 'column' }}>
							<Typography variant='body1'>Nama </Typography>
							<TextField variant="outlined" size="small" label='cth: John Doe' onChange={(val) => { handleNamaChange(val.target.value) }} />
							<Typography variant="body1" sx={{ mt: 2 }}>Nomor Telepon</Typography>
							<TextField variant="outlined" size="small" label='cth: 082121445524' onChange={(val) => { handleNomorTeleponChange(val.target.value) }} />
							<Typography variant="body1" sx={{ mt: 2 }}>Nama Bank</Typography>
							<TextField variant="outlined" size="small" label='cth: Mandiri' onChange={(val) => handleNamaBankChange(val.target.value)} />
							<Typography variant="body1" sx={{ mt: 2 }}>Nomor Rekening</Typography>
							<TextField variant="outlined" size="small" label='cth: 1300046121001' onChange={(val) => handleNomorRekeningChange(val.target.value)} />
							<Typography variant="body1" sx={{ mt: 2 }}>Nama Pemilik Rekening</Typography>
							<TextField variant="outlined" size="small" label='cth: JOHN DOE' onChange={(val) => handleNamaPemilikRekeningChange(val.target.value)} />
                            <Typography variant="body1" sx={{ mt: 2 }}>Role</Typography>
                            <TextField select variant="outlined" size="small" label='Pilih Kategori' onChange={(val) => { handleRoleChange(val.target.value) }}>
                                {
                                    selectRole.map((option) => (
                                        <MenuItem key={option.value} value={option.value}>
                                            {option.label}
                                        </MenuItem>
                                    ))
                                }
                            </TextField>
                            <Typography variant="body1" sx={{ mt: 2 }}>Username</Typography>
							<TextField variant="outlined" size="small" label='cth: johndoe' onChange={(val) => handleUsernameChange(val.target.value)} />
                            <Typography variant="body1" sx={{ mt: 2 }}>Kata Sandi</Typography>
							<TextField variant="outlined" size="small" label='cth: j0hnd0e19' onChange={(val) => handlePasswordChange(val.target.value)} />
                            <Typography variant="body1" sx={{ mt: 2 }}>Ulangi Kata Sandi</Typography>
							<TextField variant="outlined" size="small" label='cth: j0hnd0e19' onChange={(val) => handlePasswordConfirmChange(val.target.value)} />
							<Button size="medium" variant="contained" color="success" onClick={daftarAkun} sx={{ mt: 4, textTransform: 'capitalize' }}>Submit</Button>
						</CardContent>
					</Card>
				</Box>
			</Box>
        </Container>
    )
}
export default RegistrasiAccount;