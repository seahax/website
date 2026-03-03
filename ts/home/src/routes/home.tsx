import { Masonry } from '@mui/lab';
import {
  Box,
  Card,
  CardActionArea,
  CardContent,
  CardHeader,
  Container,
  Typography,
} from '@mui/material';
import { IconBrandGolang, IconBrandNpm } from '@tabler/icons-react';
import { type JSX } from 'react';

import { AppPage } from '../components/app-page.tsx';
import ProjectBadge from '../components/project-badge.tsx';
import projects from '../services/projects.ts';
import HomeMdx from './home.mdx';
import defineRoute from './util/define-route.tsx';

export default defineRoute({
  Component: Home,
});

// TODO: Use the LinkedIn API to list work experience.

function Home(): JSX.Element {
  return (
    <>
      <AppPage zIndex={1}>
        <Container
          sx={(theme) => ({
            paddingBlock: 10,
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'center',
            gap: theme.spacing(4),
          })}
        >
          <Typography variant="h1" marginBlockEnd={(theme) => theme.spacing(3)} sx={{ textAlign: 'center' }}>
            Hello, I&apos;m&nbsp;Chris.
          </Typography>
          <Box
            display={'contents'}
            sx={{
              '& p': {
                fontSize: '1.25rem',
                fontWeight: 300,
                margin: 0,
              },
            }}
          >
            <HomeMdx />
          </Box>
        </Container>
      </AppPage>
      <Container id="projects" sx={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
        <Typography variant="h2">
          My Projects
        </Typography>
        <Masonry columns={{ xs: 1, sm: 2, md: 3 }} spacing={2}>
          {projects.map((project, i) => {
            return (
              <Card
                key={i}
                variant="outlined"
                sx={{
                  boxShadow: (theme) => theme.shadows[4],
                  transition: 'scale 0.25s, box-shadow 0.25s',
                  '&:hover': {
                    scale: 1.03,
                    boxShadow: (theme) => theme.shadows[8],
                  },
                }}
              >
                <CardActionArea
                  href={project.homepage}
                  target="_blank"
                  sx={{
                    minHeight: '100%',
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'stretch',
                  }}
                >
                  <CardHeader
                    sx={{
                      borderBlockEnd: (theme) => `1px solid ${theme.palette.divider}`,
                      paddingBlock: 1,
                      paddingInline: 1.5,
                    }}
                    disableTypography
                    slots={{
                      content: () => (
                        <Typography
                          display="flex"
                          gap={1.25}
                          alignItems="center"
                          fontSize={'1.125rem'}
                          fontWeight={500}
                        >
                          <Box
                            component={project.type === 'go' ? IconBrandGolang : IconBrandNpm}
                            size="2rem"
                            strokeWidth={1.25}
                            aria-label={project.type === 'go' ? 'Go' : 'TypeScript/NPM'}
                          />
                          <Box component="span" marginBlockEnd={0.6}>{project.shortName}</Box>
                        </Typography>
                      ),
                    }}
                  >
                    Test
                  </CardHeader>
                  <CardContent sx={{
                    display: 'flex',
                    flexDirection: 'column',
                    justifyContent: 'space-between',
                    flexGrow: 1,
                    gap: 2.5,
                  }}
                  >
                    <Typography variant="body1" color="textSecondary" flex={'auto'}>
                      {project.description}
                    </Typography>
                    <Box display="flex" justifyContent="flex-end">
                      <ProjectBadge projectName={project.name} type={project.type} />
                    </Box>
                  </CardContent>
                </CardActionArea>
              </Card>
            );
          })}
        </Masonry>
      </Container>
    </>
  );
}
