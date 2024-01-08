import { Box, Grid, Stack, Typography, TextField, Button, CircularProgress } from "@mui/material";
import React from "react";
import { useNavigate } from 'react-router-dom';
function LoginUser() {
	const [showPassword, setShowPassword] = React.useState(false);
	const [nomorTelepon, setNomorTelepon] = React.useState('');
	const [password, setPassword] = React.useState('');
	const [nomorTeleponValidation, setNomorTeleponValidation] = React.useState('true')
	const [tokenAccess, setTokenAccess] = React.useState('')

	const handleNomorTelepon =(event) => {
		setNomorTelepon(event.target.value);
	}
	const handlePassword = (event) => {
		setPassword(event.target.value);
	}
	const handleClickShowPassword = () => setShowPassword((show) => !show);
	const [isLoading, setIsLoading] = React.useState(false);
	const handleLogin = (e) => {
		setIsLoading(true);
		console.log(nomorTelepon + password);
		e.preventDefault();
		tryLogin();
	};
	const navigate = useNavigate();
	const tryLogin = async () => {
		await fetch (
			'http://localhost:8000/v1/authentication/loginDonatur',
			{
				headers: {
					'Accept': 'application/json',
					'X-Requested-With': 'application/json',
					'Content-type': 'application/json; charset=UTF-8',
					'Access-Control-Allow-Origin': '*'
				},
				method: 'POST',
				body: JSON.stringify({
					nomor_telepon: nomorTelepon,
					password: password
				}),

			})
			.then((response) => response.json())
			.then((data) => {
				setIsLoading(false);
				if (data.response_code === 200) {
					setNomorTeleponValidation(true)
					console.log(data.data.token_access);
					setTokenAccess(data.data.token_access);
					navigate("/beranda")
				} else {
					setNomorTeleponValidation(false);
					console.log('token not found');
				}
			})
			.catch((err) => {
				console.log(err.message);
			});
			localStorage.getItem(tokenAccess)
	}
	return (
		<Box sx={{ width: '100%'}}>
			<Grid
			container
			rowSpacing={0}
			>
				<Grid item xs={6}>
				<Box
						sx={{
							height: '100vh',
							background: '#698D01',
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
								value={nomorTelepon}
								onChange={handleNomorTelepon}
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
								onChange={handlePassword}
							/>
							<Typography
								variant="caption"
								sx={{
									color: '#000000',
									textAlign: "left",
									display: nomorTeleponValidation ? "none" : "block"
								}}
							>
								Nomor Telepon/Password salah!
							</Typography>
							<Button
								variant="contained"
								fullWidth
								disableElevation
							
								sx={{backgroundColor: '#698D01'}}
								onClick={isLoading ? null : handleLogin}
							>
								<Typography variant="button">{isLoading ? <CircularProgress size={20} sx={{ color: "white" }} /> : "Login"}</Typography>
							</Button>
						</Stack>
					</Box>
				</Grid>
			</Grid>
		</Box>
	)
}
export default LoginUser;