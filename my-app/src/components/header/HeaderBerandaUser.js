import * as React from 'react';
import Box from '@mui/material/Box';
import Divider from '@mui/material/Divider';
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import MenuItem from '@mui/material/MenuItem';
import Menu from '@mui/material/Menu';
import KeyboardArrowDownIcon from '@mui/icons-material/KeyboardArrowDown';
import { useNavigate, Link } from 'react-router-dom';

function HeaderBar(props) {
	const [kategori, setKategori] = React.useState('');
	const handleKategoriChange = (val) => {
		setKategori(val)
	}
	const navigate = useNavigate();
	const [anchorEl, setAnchorEl] = React.useState(null);
	const open = Boolean(anchorEl);
	const handleClick = (event) => {
		setAnchorEl(event.currentTarget);
	};
	const handleClose = () => {
		setAnchorEl(null);
	};
	return (
		<Box sx={{ backgroundColor: 'white', display: 'flex', justifyContent: 'space-between', py: 1, boxShadow: '0px 0px 2px 0px', position: 'fixed', width: '100%', zIndex: '999' }}>
			<Box sx={{ display: 'flex', alignItems: 'center', color: '#9E9E9E' }}>
				<MenuItem
					onClick={() => navigate('/beranda')}
				>
					<Typography>Home</Typography>
				</MenuItem>
				<Box sx={{ display: 'flex', alignItems: 'center' }}>
					<MenuItem
						id="basic-button"
						aria-controls={open ? 'basic-menu' : undefined}
						aria-haspopup="true"
						aria-expanded={open ? 'true' : undefined}
						onClick={handleClick}
					>
						<Typography>Mulai Berdonasi</Typography>
						<KeyboardArrowDownIcon fontSize='small' />
					</MenuItem>
				</Box>
				<Box sx={{ display: 'flex', alignItems: 'center', color: '#9E9E9E' }}>
					<MenuItem
						onClick={() => navigate('/rekapitulasi-dana-public')}
					>
						<Typography>Rekapitulasi Dana</Typography>
					</MenuItem>
				</Box>
			</Box>
			<Menu
				id="basic-menu"
				anchorEl={anchorEl}
				open={open}
				onClose={handleClose}
				MenuListProps={{
					'aria-labelledby': 'basic-button',
				}}
			>
				<Box sx={{ p: '8px 16px 8px 16px' }}>
					<Typography variant='h5'>Kategori Galang Dana</Typography>
				</Box>
				<Divider />
				<MenuItem><Link to='/daftar-penggalangan-dana' state={'Beasiswa'} style={{ textDecoration: 'none', color: '#616161' }}>Beasiswa</Link></MenuItem>
				<MenuItem><Link to='/daftar-penggalangan-dana' state={'Medis'} style={{ textDecoration: 'none', color: '#616161' }}>Medis</Link></MenuItem>
				<MenuItem ><Link to='/daftar-penggalangan-dana' state={'Bencana'} style={{ textDecoration: 'none', color: '#616161' }}>Bencana</Link></MenuItem>
			</Menu>
			<Box sx={{ pt: 1, mr: 18 }}>
				<Typography variant='h3' fontFamily={'sans-serif'}>
					JTK Berbagi
				</Typography>
			</Box>
			<Box >
				<Button onClick={() => navigate('/login-user')} color='success' sx={{ marginRight: 2 }}>
					Login
				</Button>
			</Box>
		</Box >
	);
}

export default HeaderBar;