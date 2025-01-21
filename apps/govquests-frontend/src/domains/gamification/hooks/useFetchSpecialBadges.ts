"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchAllSpecialBadges } from "../services/specialBadgeService";

export const useFetchSpecialBadges = () => {
  return useQuery({
    queryKey: ["specialBadges"],
    queryFn: () => fetchAllSpecialBadges(),
  });
};
