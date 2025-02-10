import { useState, useEffect } from "react";

const breakpoints = {
  sm: 640,
  md: 768,
  lg: 1024,
  xl: 1280,
  "2xl": 1536,
};

export const useBreakpoints = () => {
  const [windowWidth, setWindowWidth] = useState(
    typeof window !== "undefined" ? window.innerWidth : 0,
  );

  useEffect(() => {
    const handleResize = () => {
      setWindowWidth(window.innerWidth);
    };

    window.addEventListener("resize", handleResize);

    return () => window.removeEventListener("resize", handleResize);
  }, []);

  return {
    isSmall: windowWidth >= breakpoints.sm && windowWidth < breakpoints.md,
    isMedium: windowWidth >= breakpoints.md && windowWidth < breakpoints.lg,
    isLarge: windowWidth >= breakpoints.lg && windowWidth < breakpoints.xl,
    isExtraLarge:
      windowWidth >= breakpoints.xl && windowWidth < breakpoints["2xl"],
    is2XL: windowWidth >= breakpoints["2xl"],
    isSmallerThan: {
      md: windowWidth < breakpoints.md,
      lg: windowWidth < breakpoints.lg,
      xl: windowWidth < breakpoints.xl,
    },
    isLargerThan: {
      md: windowWidth >= breakpoints.md,
      lg: windowWidth >= breakpoints.lg,
      xl: windowWidth >= breakpoints.lg,
    },
    width: windowWidth,
  };
};
