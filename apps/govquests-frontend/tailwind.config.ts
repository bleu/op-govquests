import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./src/**/*.{js,ts,jsx,tsx,mdx}"],
  theme: {
    extend: {
      colors: {
        primary: "white",
        primaryForeground: "#404040",
        background: "#F3F3F3",
        foreground: "#404040",
      },
    },
  },
  plugins: [],
};
export default config;
