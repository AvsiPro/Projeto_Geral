import React, { createContext, useState, useEffect, ReactNode } from 'react';

interface WindowDimensions {
  width: number;
  height: number;
}

interface WindowDimensionsContextProps {
  windowDimensions: WindowDimensions;
}

interface WindowDimensionsProviderProps {
  children: ReactNode;
}

export const WindowDimensionsContext = createContext<WindowDimensionsContextProps>({
  windowDimensions: {
    width: window.innerWidth,
    height: window.innerHeight,
  },
});

export const WindowDimensionsProvider: React.FC<WindowDimensionsProviderProps> = ({ children }) => {
  const [windowDimensions, setWindowDimensions] = useState<WindowDimensions>({
    width: window.innerWidth,
    height: window.innerHeight,
  });

  const handleResize = () => {
    setWindowDimensions({
      width: window.innerWidth,
      height: window.innerHeight,
    });
  };

  useEffect(() => {
    window.addEventListener('resize', handleResize);

    return () => {
      window.removeEventListener('resize', handleResize);
    };
  }, []);

  return (
    <WindowDimensionsContext.Provider value={{ windowDimensions }}>
      {children}
    </WindowDimensionsContext.Provider>
  );
};
