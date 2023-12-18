import Box from '@mui/material/Box';
import IconButton from '@mui/material/IconButton';
import OutlinedInput from '@mui/material/OutlinedInput';
import * as React from 'react'
import TextField from '@mui/material/TextField';
import Typography from '@mui/material/Typography';
import Grid from '@mui/material/Grid';
import Stack from '@mui/material/Stack'
import CircularProgress from '@mui/material/CircularProgress';
import Button from '@mui/material/Button';
import { red } from '@mui/material/colors'
import { useNavigate } from 'react-router-dom';

function Login() {
	const [showPassword, setShowPassword] = React.useState(false);
	const [username, setUsername] = React.useState('')
	const handleUsernameChange = (event) => {
		setUsername(event.target.value);
	};
	const [password, setPassword] = React.useState('');
	const handlePasswordChange = (event) => {
		setPassword(event.target.value);
	};
	const [emailPasswordValidation, setEmailPasswordValidation] = React.useState(true);
	const handleClickShowPassword = () => setShowPassword((show) => !show);
	const [isLoading, setIsLoading] = React.useState(false);
	const handleMouseDownPassword = (event) => {
		event.preventDefault();
	};

	// const tryLogin = () => {
	// 	if (username === 'hasbiishlahyazm') {
	// 		navigate('/Dashboard')
	// 	}
	// 	else {
	// 		setEmailPasswordValidation(false)
	// 	}
	// }
	const handleLogin = (e) => {
		setIsLoading(true);
		console.log(username + password);
		e.preventDefault();
		tryLogin();
	};
	const navigate = useNavigate();

	const tryLogin = async () => {
		await fetch(
			'http://localhost:8000/v1/authentication/loginPenanggungJawab',
			{
				headers: {
					'Accept': 'application/json',
					'X-Requested-With': 'application/json',
					'Content-type': 'application/json; charset=UTF-8',
					'Access-Control-Allow-Origin': '*'
				},
				method: 'POST',
				body: JSON.stringify({
					username: username,
					password: password
				}),
				
			})
			.then((response) => response.json())
			.then((data) => {
				setIsLoading(false);
				if (data.response_code === 200) {
					setEmailPasswordValidation(true)
					localStorage.setItem("token", data.data.token_access);
                    localStorage.setItem("username", data.data.admin.username);
                    localStorage.setItem("name", data.data.admin.nama);
                    localStorage.setItem("role", data.data.admin.role);
					console.log(data.data);
					if (data.data != undefined) {
						if (data.data.admin.role === 0) {
							navigate("/")
						} else {
							navigate("/penerima-dana")
						}
					} else {
						setEmailPasswordValidation(false);
						console.log('token not found!')
					}
				} else {
					setEmailPasswordValidation(false);
					console.log('token not found');
				}
			})
			.catch((err) => {
				console.log(err.message);
			});
	}
	return (
		<Box sx={{ width: '100%' }}>
			<Grid
				container
				rowSpacing={0}
			>
				<Grid item xs={6}>
					<Box
						sx={{
							height: '100vh',
							background: '#1559E6',
							position: 'relative',
							display: 'flex',
							alignItems: 'center',
							justifyContent: 'center'
						}}
					>
						<Stack
							component='logo'
						>
							<Typography
								variant='h1'
								color={'white'}
								fontWeight={'bold'}
								fontFamily={'Arial'}
							>
								JTK Berbagi
							</Typography>
						</Stack>
					</Box>
				</Grid>
				<Grid item xs={6}>
					<Box
						sx={{
							height: "100vh",
							px: "16px",
							position: "relative",
							display: 'flex',
							alignItems: 'center'
						}}
					>
						<Stack
							component='form'
							className='login-section'
							no-validate
							autoComplete='off'
							spacing={1}
						>
							<Typography variant='h4' sx={{ fontWeight: 700 }}>Login</Typography>
							<TextField
								sx={{ width: '550px' }}
								label="Username"
								variant="filled"
								type="username"
								InputProps={{
									disableUnderline: true
								}}
								className="TextField"
								value={username}
								onChange={handleUsernameChange}
							/>
							<TextField
								fullWidth
								label="Password"
								variant="filled"
								type="password"
								InputProps={{
									disableUnderline: true
								}}
								className="TextField"
								value={password}
								onChange={handlePasswordChange}
							/>
							<Typography
								variant="caption"
								sx={{
									color: red[800],
									textAlign: "left",
									display: emailPasswordValidation ? "none" : "block"
								}}
							>
								Username/Password salah!
							</Typography>
							<Button
								variant="contained"
								fullWidth
								disableElevation
								onClick={isLoading ? null : handleLogin}
							>
								<Typography variant="button">{isLoading ? <CircularProgress size={20} sx={{ color: "white" }} /> : "Login"}</Typography>
							</Button>
							<Button
								variant="outlined"
								fullWidth
								disableElevation
								href='/registration'
							>
								<Typography variant="button">{isLoading ? <CircularProgress size={20} sx={{ color: "white" }} /> : "Daftar Akun Baru"}</Typography>
							</Button>
						</Stack>
					</Box>
				</Grid>
			</Grid>
		</Box>
	)
}
export default Login;