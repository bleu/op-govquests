"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchAllTracks } from "../services/trackService";

export const useFetchTracks = () => {
  return useQuery({ queryKey: ["tracks"], queryFn: fetchAllTracks });
};
