"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchBadge } from "../services/badgeService";

export const useFetchBadge = (id: string) => {
  return useQuery({
    queryKey: ["badge", id],
    queryFn: () => fetchBadge(id),
    enabled: !!id,
  });
};
