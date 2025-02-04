"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchAllBadges } from "../services/badgeService";
import { sortBadges } from "../lib/utils";

export const useFetchBadges = () => {
  return useQuery({
    queryKey: ["badges"],
    queryFn: () => fetchAllBadges(),
    select: sortBadges,
  });
};
