import { Box } from '@mui/material';
import { type JSX, type PropsWithChildren } from 'react';

export default function AppMain({ children }: PropsWithChildren = {}): JSX.Element {
  return (
    <Box
      position="relative"
      zIndex={0}
      minHeight="100lvh"
      paddingBlockEnd={{ xs: 12, sm: 16 }}
      flexGrow={1}
      display="flex"
      flexDirection="column"
      boxShadow={(theme) => theme.shadows[4]}
      sx={(theme) => {
        const { background } = theme.palette;
        const light = theme.lighten(background.paper, 0.15);
        const dark = theme.darken(background.default, 0.3);

        return ({
          backgroundColor: dark,
          backgroundImage: `
          linear-gradient(to bottom, transparent, 60vh, ${dark} 100vh),
          radial-gradient(max(100vw, 100vh) circle at 10% 0%, ${light}, ${dark})
          `,
        });
      }}
    >
      {children}
    </Box>
  );
}
