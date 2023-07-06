import Container from '@mui/material/Container'
import Typography from '@mui/material/Typography';
import InfoCardGalangDana from "../components/molekul/card/CardGalangDana";

function DaftarPenggalanganDanaMedis() {
	const cardList = [
		{ title: 'Judul Galang Dana', description: 'Lorem Ipsum has been the industrys standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', donaturs: '1500' },
		{ title: 'Judul Galang Dana', description: 'Lorem Ipsum has been the industrys standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', donaturs: '200' },
		{ title: 'Judul Galang Dana', description: 'Lorem Ipsum has been the industrys standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', donaturs: '500' },
		{ title: 'Judul Galang Dana', description: 'Lorem Ipsum has been the industrys standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', donaturs: '1700' },
		{ title: 'Judul Galang Dana', description: 'Lorem Ipsum has been the industrys standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', donaturs: '100' }
	]
	return (
		<Container>
			<Typography fontWeight='bold' variant='h3' sx={{ mt: 2, color: '#212121' }}>Daftar Penggalangan Dana Medis</Typography>
			{cardList.map((info, index) =>
			(
				<InfoCardGalangDana title={info.title} description={info.description} donaturs={info.donaturs} />
			))}
		</Container>
	)
}
export default DaftarPenggalanganDanaMedis;