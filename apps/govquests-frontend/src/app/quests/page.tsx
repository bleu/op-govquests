"use client";

import React from "react";

import LoadingIndicator from "@/components/ui/LoadingIndicator";
import { TrackList } from "@/domains/tracking/components/TrackList";
import { useFetchQuests } from "@/domains/questing/hooks/useFetchQuests";

const QuestsPage: React.FC = () => {
  const { data, isLoading, isError } = useFetchQuests();

  if (isLoading) {
    return <LoadingIndicator />;
  }

  if (isError || !data) {
    return <p>Error loading quests.</p>;
  }

  return (
    <div className="p-8">
      <TrackList />
    </div>
  );
};

export default QuestsPage;
