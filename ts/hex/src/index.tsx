import '@fontsource-variable/fredoka';

import { createTheme, CssBaseline, GlobalStyles, ThemeProvider } from '@mui/material';
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';

import App from './app.tsx';

const theme = createTheme({
  palette: {
    mode: 'dark',
    primary: {
      main: 'hsla(216, 94%, 75%, 1.00)',
    },
    secondary: {
      main: 'hsla(6, 93%, 71%, 1.00)',
    },
    background: {
      default: 'hsla(216, 40%, 13%, 1.00)',
      paper: 'hsla(216, 40%, 18%, 1.00)',
    },
  },
  typography: {
    fontFamily: 'Fredoka, Arial, Helvetica, sans-serif',
  },
});

createRoot(document.querySelector('#app')!).render(
  <StrictMode>
    <ThemeProvider theme={theme}>
      <CssBaseline>
        <GlobalStyles styles={{
          'html, body': { height: '100%', overflow: 'hidden', margin: 0, padding: 0 },
          '#app': { display: 'contents' },
        }}
        />
        <App />
      </CssBaseline>
    </ThemeProvider>
  </StrictMode>,
);
