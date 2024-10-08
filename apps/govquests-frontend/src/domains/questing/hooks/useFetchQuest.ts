"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchQuestById } from "../services/questService";

export const useFetchQuest = (id: string) => {
  return useQuery({
    queryKey: ["quest", id],
    queryFn: () => fetchQuestById(id),
    enabled: !!id,
  });
};
