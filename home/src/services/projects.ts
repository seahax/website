export interface Project {
  type: 'npm' | 'go';
  name: string;
  shortName: string;
  description: string;
  homepage: string;
}

const projects: readonly Project[] = [
  {
    type: 'npm',
    name: '@seahax/background',
    shortName: 'background',
    description: `
    Run an async task without waiting for it to return, the responsible
    way.`,
    homepage: 'https://www.npmjs.com/package/@seahax/background',
  },
  {
    type: 'npm',
    name: '@seahax/deep-copy',
    shortName: 'deep-copy',
    description: `
    Make a recursive deep copy, treating functions and class
    instances as atomic values.`,
    homepage: 'https://www.npmjs.com/package/@seahax/deep-copy',
  },
  {
    type: 'go',
    name: 'go/env',
    shortName: 'env',
    description: 'Parse and validate environment variables.',
    homepage: 'https://pkg.go.dev/seahax.com/go/env',
  },
  {
    type: 'npm',
    name: '@seahax/eslint-plugin-wrap',
    shortName: 'eslint-plugin-wrap',
    description: 'ESLint plugin with wrapping fixes for long lines.',
    homepage: 'https://www.npmjs.com/package/@seahax/eslint-plugin-wrap',
  },
  {
    type: 'npm',
    name: '@seahax/eslint-progress',
    shortName: 'eslint-progress',
    description: 'ESLint plugin that prints filenames as they are linted.',
    homepage: 'https://www.npmjs.com/package/@seahax/eslint-progress',
  },
  {
    type: 'npm',
    name: '@seahax/glimmer',
    shortName: 'glimmer',
    description: `
    Just a fun visual effects project using particles on a canvas.`,
    homepage: 'https://www.npmjs.com/package/@seahax/glimmer',
  },
  {
    type: 'npm',
    name: '@seahax/interval',
    shortName: 'interval',
    description: 'Convert units of time to other units of time.',
    homepage: 'https://www.npmjs.com/package/@seahax/interval',
  },
  {
    type: 'npm',
    name: '@seahax/run-all',
    shortName: 'run-all',
    description: `
    Because life's too short to type 'npm run test:unit && npm run
    test:integration && npm run test:e2e' when you could just say 'run-all
    test'.`,
    homepage: 'https://www.npmjs.com/package/@seahax/run-all',
  },
  {
    type: 'npm',
    name: '@seahax/semaphore',
    shortName: 'semaphore',
    description: 'An asynchronous semaphore.',
    homepage: 'https://www.npmjs.com/package/@seahax/semaphore',
  },
  {
    type: 'go',
    name: 'go/serve',
    shortName: 'serve',
    description: 'A simple production ready static HTTP server.',
    homepage: 'https://pkg.go.dev/seahax.com/go/serve',
  },
  {
    type: 'npm',
    name: '@seahax/service',
    shortName: 'service',
    description: 'Dependency injection done light.',
    homepage: 'https://www.npmjs.com/package/@seahax/service',
  },
  {
    type: 'go',
    name: 'go/shorthand',
    shortName: 'shorthand',
    description: `
    Utilities for simple things that are unnecessarily verbose or missing
    from the standard library. I miss ternary operators and null (nil)
    coalescing.`,
    homepage: 'https://pkg.go.dev/seahax.com/go/shorthand',
  },
  {
    type: 'npm',
    name: '@seahax/store',
    shortName: 'store',
    description: 'Really simple Redux-like store.',
    homepage: 'https://www.npmjs.com/package/@seahax/store',
  },
  {
    type: 'npm',
    name: '@seahax/vite-plugin-lib',
    shortName: 'vite-plugin-lib',
    description: `
    Use Vite to just build a library. It's not that hard. Why are there so
    many settings!?`,
    homepage: 'https://www.npmjs.com/package/@seahax/vite-plugin-lib',
  },
  {
    type: 'npm',
    name: '@seahax/vite-plugin-preview',
    shortName: 'vite-plugin-preview',
    description: `
    Vite plugin that starts a preview server when the build command is run
    with the \`--watch\` option.`,
    homepage: 'https://www.npmjs.com/package/@seahax/vite-plugin-preview',
  },
  {
    type: 'npm',
    name: '@seahax/vite-plugin-zip',
    shortName: 'vite-plugin-zip',
    description: 'Vite plugin that zips up the build output.',
    homepage: 'https://www.npmjs.com/package/@seahax/vite-plugin-zip',
  },
  {
    type: 'go',
    name: 'go/xhttp',
    shortName: 'xhttp',
    description: `
    A collection of lightweight and opinionated utilities to make working
    with the net/http package a little easier.`,
    homepage: 'https://pkg.go.dev/seahax.com/go/xhttp',
  },
  {
    type: 'npm',
    name: '@seahax/yaml-vars',
    shortName: 'yaml-vars',
    description: 'Utility that enables Terraform style input variables in any YAML file.',
    homepage: 'https://www.npmjs.com/package/@seahax/yaml-vars',
  },
  {
    type: 'npm',
    name: '@seahax/cli',
    shortName: 'cli',
    description: `
    Small quality-of-life enhancements to the Node built-in parseArgs
    utility, and a simple command/sub-command framework.`,
    homepage: 'https://www.npmjs.com/package/@seahax/cli',
  },
] as const;

export default [...projects].sort((a, b) => a.shortName.localeCompare(b.shortName)) as readonly Project[];
