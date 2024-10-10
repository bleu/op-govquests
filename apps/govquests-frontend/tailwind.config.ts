import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./src/**/*.{js,ts,jsx,tsx,mdx}"],
  theme: {
    extend: {
      colors: {
        primary: "#EBE5E3",
        optimism: "#FF0421",
        optimismForeground: "#FFFFFF",
        background: "#F3F3F3",
        foreground: "#404040",
      },
    },
  },
  plugins: [],
};
export default config;
