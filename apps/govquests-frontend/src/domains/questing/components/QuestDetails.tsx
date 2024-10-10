import React from "react";
import RewardIndicator from "@/components/RewardIndicator";
import Button from "@/components/ui/Button";
import { MapIcon, RouteIcon } from "lucide-react";
import type { Quest } from "@/domains/questing/types/questTypes";
import ActionList from "@/domains/action_tracking/components/ActionList";

interface QuestDetailsProps {
  quest: Quest;
}

const QuestDetails: React.FC<QuestDetailsProps> = ({ quest }) => {
  if (!quest) return null;

  return (
    <main className="flex items-center justify-center h-full">
      <div className="flex flex-col max-w-[85%]">
        <div className="flex flex-1 items-center p-5 md:p-8 bg-black/60 text-optimismForeground rounded-lg mb-3">
          <MapIcon width={50} height={50} />
          <h1 className="text-3xl flex-1 ml-5">{quest.displayData.title}</h1>
          <div className="flex items-center">
            {quest.rewards.map((reward) => (
              <RewardIndicator key={reward.type} reward={reward} />
            ))}
          </div>
        </div>
        <div className="flex flex-col flex-1 justify-center bg-primary p-5 md:p-8 rounded-lg">
          <div className="flex items-center">
            <div className="w-24 h-24 bg-optimism" />
            <div className="ml-7">
              <h2 className="text-2xl font-medium mb-2">About this quest</h2>
              <p className="text-lg">{quest.displayData.intro}</p>
            </div>
          </div>
          <div className="flex items-center my-6">
            <RouteIcon width={30} height={30} />
            <h2 className="ml-4 text-xl font-bold">Steps to earn</h2>
          </div>
          <div className="flex flex-col md:flex-row">
            <div className="flex flex-col">
              <ActionList questId={quest.id} actions={quest.actions} />
            </div>
            <Button className="font-bold md:self-end md:ml-auto p-4">
              Complete quest
            </Button>
          </div>
        </div>
      </div>
    </main>
  );
};

export default QuestDetails;
