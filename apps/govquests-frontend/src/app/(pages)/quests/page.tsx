"use client";

import type React from "react";

import LoadingIndicator from "@/components/ui/LoadingIndicator";
import { TrackList } from "@/domains/questing/components/track/TrackList";
import { useFetchQuests } from "@/domains/questing/hooks/useFetchQuests";
import { OptimismSeasonBanner } from "@/components/OptimismSeasonBanner";

const QuestsPage: React.FC = () => {
  const { data, isLoading, isError } = useFetchQuests();

  if (isLoading) {
    return <LoadingIndicator />;
  }

  if (isError || !data) {
    return <p>Error loading quests.</p>;
  }

  return (
    <div className="py-8 px-6 gap-9 flex flex-col">
      <OptimismSeasonBanner />
      <TrackList />
    </div>
  );
};

export default QuestsPage;
