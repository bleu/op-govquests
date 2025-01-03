import RewardIndicator from "@/components/RewardIndicator";
import { Button } from "@/components/ui/shadcn-button";
import ActionList from "@/domains/action_tracking/components/ActionList";
import type { Quest } from "@/domains/questing/types/questTypes";
import { useSIWE } from "connectkit";
import { ArrowLeft, MapIcon } from "lucide-react";
import { redirect } from "next/navigation";
import { useAccount } from "wagmi";
import QuestButton from "./QuestButton";
import QuestContentSection from "./QuestContentSection";

interface QuestDetailsProps {
  quest: Quest;
}

const QuestDetails = ({ quest }: QuestDetailsProps) => {
  if (!quest) return null;

  const { isConnected } = useAccount();
  const { isSignedIn, signIn } = useSIWE();
  const status = quest.userQuests?.[0]?.status || "unstarted";

  return (
    <main className="flex justify-center min-h-full bg-background/50">
      <div className="flex flex-col w-[70%] max-w-5xl py-8 gap-6">
        {/* Main content area */}
        <div className="border-primary/20 border shadow-sm py-6 md:py-8 rounded-lg">
          <div className="flex-col">
            <div className="space-y-4 px-10">
              <Button
                variant="outline"
                size="sm"
                className="p-2 h-6"
                onClick={() => redirect("/quests")}
              >
                <ArrowLeft className="w-4 h-4 mr-2" />
                Back to Tracks
              </Button>
              <div className="flex justify-between items-center">
                <h1 className="text-2xl font-bold tracking-tight text-foreground/80 flex gap-2">
                  <span className="text-foreground/50"># QUEST</span>
                  {quest.displayData.title}
                </h1>
                <div className="flex items-center gap-2">
                  {quest.rewardPools.map(({ rewardDefinition: reward }) => (
                    <RewardIndicator key={reward.type} reward={reward} />
                  ))}
                </div>
              </div>
            </div>

            <div className="space-y-8 [&_p]:text-foreground/70">
              <QuestContentSection
                title="About this quest"
                content={quest.displayData.intro || ""}
              />

              {quest.displayData.requirements && (
                <QuestContentSection
                  title="Requirements"
                  content={quest.displayData.requirements}
                />
              )}
            </div>
          </div>
        </div>

        {/* Steps section */}
        <div className="border-primary/20 border shadow-sm rounded-lg overflow-hidden">
          <div className="flex items-center">
            <div className="shrink-0 p-8  border-r border-primary/20">
              <h2 className="text-xl font-bold text-primary/70">
                Steps to
                <br />
                complete
              </h2>
            </div>
            <div className="flex-1 p-8">
              <ActionList
                questSlug={quest.slug as string}
                actions={quest.actions}
              />
            </div>
          </div>
        </div>

        {/* Action button */}
        <div className="flex justify-center pt-4">
          <QuestButton
            status={status}
            isSignedIn={isSignedIn && isConnected}
            onConnect={signIn}
            onClaim={() => alert("Coming soon")}
          />
        </div>
      </div>
    </main>
  );
};

export default QuestDetails;
