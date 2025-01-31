import { isServer } from "@tanstack/react-query";
import { clsx, type ClassValue } from "clsx";
import { Koulen, Redacted_Script, Kdam_Thmor_Pro } from "next/font/google";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export const API_URL =
  process.env.NODE_ENV === "development"
    ? "http://localhost:3000/graphql"
    : isServer
      ? process.env.NEXT_PUBLIC_API_URL!
      : window.location.origin + "/graphql";

export const koulen = Koulen({ weight: "400", subsets: ["latin"] });

export const redactedScript = Redacted_Script({
  weight: "400",
  subsets: ["latin"],
});

export const kdamThmorPro = Kdam_Thmor_Pro({
  weight: "400",
  subsets: ["latin"],
});
