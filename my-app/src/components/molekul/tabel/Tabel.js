import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell, { tableCellClasses } from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';
import { styled } from '@mui/material/styles';

const StyledTableCell = styled(TableCell)(({ theme }) => ({
	[`&.${tableCellClasses.head}`]: {
		backgroundColor: theme.palette.common.white,
		color: theme.palette.common.black,
	},
	[`&.${tableCellClasses.body}`]: {
		fontSize: 14,
	},
}));

const StyledTableRow = styled(TableRow)(({ theme }) => ({
	'&:nth-of-type(odd)': {
		backgroundColor: theme.palette.action.hover,
	},
	// hide last border
	'&:last-child td, &:last-child th': {
		border: 0,
	},
}));

function TableAdmin({ title, id }) {
	<TableContainer component={Paper}>
		<Table sx={{ minWidth: 700 }} aria-label="customized table">
			<TableHead>

				<StyledTableCell>{title}</StyledTableCell>

			</TableHead>
			<TableBody>

				<StyledTableRow >

					<StyledTableCell>{id}</StyledTableCell>

				</StyledTableRow>

			</TableBody>
		</Table>
	</TableContainer>
}
export default TableAdmin;
