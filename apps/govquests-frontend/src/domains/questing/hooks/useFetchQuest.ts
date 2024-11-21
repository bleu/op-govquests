"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchQuestById } from "../services/questService";
import { title } from "process";
import { useFetchQuests } from "./useFetchQuests";
import { titleToSlug } from "../lib/utils";

export const useFetchQuest = (id: string) => {
  return useQuery({
    queryKey: ["quest", id],
    queryFn: () => fetchQuestById(id),
    enabled: !!id,
  });
};

export const useFetchQuestByTitle = (slug: string) => {
  const { data } = useFetchQuests();

  const questId = data?.quests.find(
    (quest) => titleToSlug(quest.displayData.title) === slug,
  ).id;

  return useQuery({
    queryKey: ["quest", questId],
    queryFn: () => fetchQuestById(questId),
    enabled: !!title,
  });
};
