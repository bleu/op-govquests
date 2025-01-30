"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchTiers } from "../services/tierService";

export const useFetchTiers = () => {
  return useQuery({
    queryKey: ["tiers"],
    queryFn: () => fetchTiers(),
  });
};
