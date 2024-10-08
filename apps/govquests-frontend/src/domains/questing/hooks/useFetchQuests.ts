"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchAllQuests } from "../services/questService";

export const useFetchQuests = () => {
  return useQuery({ queryKey: ["quests"], queryFn: fetchAllQuests });
};
