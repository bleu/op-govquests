"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchAllBadges } from "../services/badgeService";

export const useFetchBadges = (special) => {
  return useQuery({
    queryKey: ["badges", special],
    queryFn: () => fetchAllBadges(special),
  });
};
