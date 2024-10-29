import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./src/**/*.{js,ts,jsx,tsx,mdx}"],
  theme: {
    extend: {
      colors: {
        primary: "white",
        secondary: "#EDEDED",
        secondaryHover: "#6F6F70",
        secondaryDisabled: "#C4C4C4",
        background: "#F3F3F3",
        foreground: "#404040",
      },
    },
  },
  plugins: [require("@tailwindcss/typography")],
};
export default config;
