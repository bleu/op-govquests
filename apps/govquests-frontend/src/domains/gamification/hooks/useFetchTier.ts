"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchTier } from "../services/tierService";

export const useFetchTier = (id: string) => {
  return useQuery({
    queryKey: ["tier", id],
    queryFn: () => fetchTier(id),
    enabled: !!id,
  });
};
