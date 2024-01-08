import { createTheme } from "@mui/material/styles";

var theme = createTheme({
	typography: {
		h1: {
			fontSize: '34px',
			fontFamily: 'Open Sans, sans-serif',
			fontWeight: 'bold',
		},
		h2: {
			fontSize: '24px',
			fontFamily: 'Open Sans, sans-serif',
			fontWeight: 'bold'
		},
		h3: {
			fontSize: '18px',
			fontFamily: 'Open Sans, sans-serif',
			fontWeight: '600'
		},
		h4: {
			fontSize: '16px',
			fontFamily: 'Open Sans, sans-serif',
		},
		h5: {
			fontSize: '14px',
			fontFamily: 'Open Sans, sans-serif',
			fontWeight: '600'
		},
		h6: {
			fontSize: '12px',
			fontFamily: 'Open Sans, sans-serif',
			fontWeight: '600'
		},
		body1: {
			fontSize: '14px'
		},
		caption: {
			fontSize: '12px',
			fontWeight: '300'
		},
		button: {
			fontSize: '14px',
			fontFamily: 'Open Sans, sans-serif',
			fontWeight: '600',
			textTransform: "none",
		}
	},
	palette: {
		themePrimary: {
			main: '#009B4C',
			darkest: '#007037',
		},
		themeSecondary: {
			main: '#1559E6',
			darkest: '#0F2C64',
			darker: '#0236A4',
			lighter: '#2E6BEB',
			lightest: '#6B9AF3',
		},
		themeGrey: {
			darkest: '#212121',
			darker: '#616161',
			main: '#757575',
			ligther: '#9E9E9E',
			lightest: '#E0E0E0'
		},
		themeWhite: {
			darkest: '#E5E5E5',
			darker: '#EEEEEE',
			lighter: '#FAFAFA',
			lightest: '#FFFFFF',
		},
		themeTable: {
			dark: '#AAC3F3',
			light: '#D9E6FF',
		}
	},
});

theme = createTheme(theme, {
	components: {
		MuiButton: {
			styleOverrides: {
				containedPrimary: {
					backgroundColor: 'theme.themeSecondary.main',
				},
				outlinedPrimary: {
					borderColor: 'theme.themeSecondary.main',
					color: 'theme.themeSecondary.darker'
				}
			},
		},
	},
})

export default theme;