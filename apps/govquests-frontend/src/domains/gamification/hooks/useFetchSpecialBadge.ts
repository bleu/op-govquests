"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchSpecialBadge } from "../services/specialBadgeService";

export const useFetchSpecialBadge = (id: string) => {
  return useQuery({
    queryKey: ["specialBadge", id],
    queryFn: () => fetchSpecialBadge(id),
    enabled: !!id,
  });
};
