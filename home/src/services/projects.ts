export interface Project {
  type: 'npm' | 'go';
  name: string;
  shortName: string;
  description: string;
  homepage: string;
}

export default [
  //
] satisfies Project[] as readonly Project[];
