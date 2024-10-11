import RewardIndicator from "@/components/RewardIndicator";
import Button from "@/components/ui/Button";
import ActionList from "@/domains/action_tracking/components/ActionList";
import type { Quest } from "@/domains/questing/types/questTypes";
import { ArrowLeft, ArrowLeftFromLine, MapIcon, RouteIcon } from "lucide-react";
import Link from "next/link";
import React from "react";

interface QuestDetailsProps {
  quest: Quest;
}

const QuestDetails: React.FC<QuestDetailsProps> = ({ quest }) => {
  if (!quest) return null;

  const status = quest.userQuests?.[0]?.status || "unstarted";

  return (
    <main className="flex items-center justify-center h-full">
      <div className="flex flex-col w-[70%]">
        <Link
          href="#"
          onClick={(e) => {
            e.preventDefault();
            window.history.back();
          }}
        >
          <ArrowLeft onClick={() => window.history.back()} />
        </Link>
        <div className="p-5 md:p-8 mb-3 mt-2 bg-primary  rounded-lg">
          <div className="flex-col">
            <div className="flex justify-between">
              <span className="flex gap-2 font-bold text-foreground/50">
                <MapIcon width={25} height={25} />
                QUEST
              </span>
              <div className="flex items-center">
                {quest.rewards.map((reward) => (
                  <RewardIndicator key={reward.type} reward={reward} />
                ))}
              </div>
            </div>
            <div className="flex flex-1 items-center">
              <h1 className="text-3xl flex-1">{quest.displayData.title}</h1>
            </div>
            <div className="flex items-center">
              <div className="border-t-2 mt-8 pt-3">
                <h2 className="text-2xl font-medium mb-2">About this quest</h2>
                <p>{quest.displayData.intro}</p>
              </div>
            </div>
          </div>
        </div>
        <div className="flex flex-col flex-1 justify-center bg-primary pb-3 pr-8 pt-8  rounded-lg">
          <div className="flex ">
            <h2 className="text-2xl font-bold self-center px-16">
              steps <br /> to earn
            </h2>
            <div className="flex-1">
              <ActionList questId={quest.id} actions={quest.actions} />
            </div>
          </div>
          {/* <div className="flex items-center my-6">
            <RouteIcon width={30} height={30} />
            <h2 className="ml-4 text-xl font-bold">Steps to earn</h2>
          </div>
          <div className="flex flex-col md:flex-row">
            <div className="flex flex-col">
              <ActionList questId={quest.id} actions={quest.actions} />
            </div>
            <Button className="font-bold md:self-end md:ml-auto p-4">
              {status}
            </Button>
          </div> */}
        </div>
      </div>
    </main>
  );
};

export default QuestDetails;
