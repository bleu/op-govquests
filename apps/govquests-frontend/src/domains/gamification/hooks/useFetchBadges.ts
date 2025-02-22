"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchAllBadges } from "../services/badgeService";

export const useFetchBadges = () => {
  return useQuery({
    queryKey: ["badges"],
    queryFn: () => fetchAllBadges(),
    select: (data) => {
      data.badges.sort(
        (a, b) => Number(b.earnedByCurrentUser) - Number(a.earnedByCurrentUser),
      );
      return data;
    },
  });
};
