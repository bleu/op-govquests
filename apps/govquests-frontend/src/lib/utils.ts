import { isServer } from "@tanstack/react-query";
import { clsx, type ClassValue } from "clsx";
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
