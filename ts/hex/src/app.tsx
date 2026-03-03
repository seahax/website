import { Engine } from '@babylonjs/core';
import { type ComponentProps, type ReactNode, useEffect, useRef } from 'react';

import Canvas from './components/canvas.tsx';
import Root from './components/root.tsx';

type Props = Pick<ComponentProps<typeof Root>, 'id' | 'className'>;

export default function App({ id, className }: Props): ReactNode {
  const ref = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    if (ref.current == null) return;

    const engine = new Engine(ref.current, true);
    const onResize = (): void => {
      engine.resize();
    };

    window.addEventListener('resize', onResize);

    return () => {
      window.removeEventListener('resize', onResize);
      engine.dispose();
    };
  }, []);

  return (
    <Root id={id} className={className}>
      <Canvas ref={ref} />
    </Root>
  );
}
