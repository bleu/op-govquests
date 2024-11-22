"use client";

import { useQuery } from "@tanstack/react-query";
import { title } from "process";
import { fetchQuestBySlug } from "../services/questService";

export const useFetchQuest = (slug: string) => {
  return useQuery({
    queryKey: ["quest", slug],
    queryFn: () => fetchQuestBySlug(slug),
    enabled: !!title,
  });
};
