import RewardIndicator from "@/components/RewardIndicator";
import ActionList from "@/domains/action_tracking/components/ActionList";
import type { Quest } from "@/domains/questing/types/questTypes";
import { useSIWE } from "connectkit";
import { ArrowLeft, MapIcon } from "lucide-react";
import Link from "next/link";
import type React from "react";
import { useAccount } from "wagmi";
import QuestButton from "./QuestButton";
import QuestContentSection from "./QuestContentSection";

interface QuestDetailsProps {
  quest: Quest;
}

const QuestDetails: React.FC<QuestDetailsProps> = ({ quest }) => {
  if (!quest) return null;

  const { isConnected } = useAccount();
  const { isSignedIn, signIn } = useSIWE();

  const status = quest.userQuests?.[0]?.status || "unstarted";

  return (
    <main className="flex justify-center h-full">
      <div className="flex flex-col w-[70%] mt-4">
        <Link href="/quests">
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
                {quest.rewardPools.map(({ rewardDefinition: reward }) => (
                  <RewardIndicator key={reward.type} reward={reward} />
                ))}
              </div>
            </div>
            <div className="flex flex-1 items-center">
              <h1 className="text-3xl flex-1 font-bold">
                {quest.displayData.title}
              </h1>
            </div>
            <QuestContentSection
              title="About this quest"
              content={quest.displayData.intro || ""}
            />
            {quest.displayData.requirements ? (
              <QuestContentSection
                title="Requirements"
                content={quest.displayData.requirements}
              />
            ) : null}
          </div>
        </div>
        <div className="flex flex-col justify-center bg-primary py-6 pr-8 rounded-lg">
          <div className="flex items-center">
            <h2 className="text-2xl font-bold self-center px-16 text-foreground/40">
              steps <br /> to earn
            </h2>
            <div className="flex-1">
              <ActionList questId={quest.id} actions={quest.actions} />
            </div>
          </div>
        </div>
        <QuestButton
          status={status}
          isSignedIn={isSignedIn && isConnected}
          onConnect={signIn}
          onClaim={() => alert("Coming soon")}
        />
      </div>
    </main>
  );
};

export default QuestDetails;
