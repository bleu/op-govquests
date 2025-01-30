"use client";

import { useQuery } from "@tanstack/react-query";
import { useState } from "react";
import { fetchTier } from "../services/tierService";

export const useFetchTier = (id: string) => {
  return useQuery({
    queryKey: ["tier", id],
    queryFn: () => fetchTier(id),
    enabled: !!id,
  });
};

export const usePaginatedTier = (id: string, initialLimit: number = 4) => {
  const [limit, setLimit] = useState(initialLimit);

  const { data, isLoading, isFetching } = useQuery({
    queryKey: ["tier", id, { limit, offset: 0 }],
    queryFn: () => fetchTier(id, { limit, offset: 0 }),
    enabled: !!id,
    placeholderData: (oldData) => oldData,
  });

  const handleLoadMore = () => {
    setLimit((prev) => prev + 4);
  };

  const hasMore = data?.tier.leaderboard.gameProfiles.length === limit;

  return {
    data,
    isLoading,
    isFetching,
    hasMore,
    handleLoadMore,
  };
};
