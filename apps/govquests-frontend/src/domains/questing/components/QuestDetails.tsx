import { DividerHeader } from "@/components/ui/DividerHeader";
import { Button } from "@/components/ui/Button";
import ActionList from "@/domains/action_tracking/components/ActionList";
import type { Quest } from "@/domains/questing/types/questTypes";
import { ArrowLeft } from "lucide-react";
import { redirect } from "next/navigation";
import QuestContentSection from "./QuestContentSection";
import { BadgeCard } from "../../gamification/components/BadgeCard";
import HtmlRender from "@/components/ui/HtmlRender";
import { IndicatorPill } from "@/components/IndicatorPill";
import RewardIndicator from "@/components/RewardIndicator";

interface QuestDetailsProps {
  quest: Quest;
}

const QuestDetails = ({ quest }: QuestDetailsProps) => {
  if (!quest) return null;

  const isCompleted = quest.userQuests?.[0]?.status == "completed";

  return (
    <main className="flex justify-center min-h-full">
      <div className="flex flex-col w-[70%] max-w-5xl py-8 gap-6">
        {/* Main content area */}
        <div className="border-primary/20 border shadow-sm py-6 md:py-8 rounded-lg bg-background/60">
          <div className="flex-col">
            <div className="space-y-4 px-10">
              <Button
                variant="outline"
                size="sm"
                className="p-2 h-6 hover:bg-primary/10"
                onClick={() => redirect("/quests")}
              >
                <ArrowLeft className="w-4 h-4 mr-2" />
                Back to Tracks
              </Button>
              <div className="flex justify-between items-center">
                <h1 className="text-2xl font-bold tracking-tight flex gap-3">
                  <span className="text-foreground/60">#QUEST</span>
                  {quest.displayData.title}
                </h1>
                {isCompleted ? (
                  <IndicatorPill className="text-xs">Completed</IndicatorPill>
                ) : (
                  <RewardIndicator
                    reward={quest.rewardPools[0].rewardDefinition}
                    className="text-xs"
                  />
                )}
              </div>
            </div>

            <div className="space-y-8 [&_div]:text-foreground [&_p]:font-bold [&_a]:text-foreground ">
              <div className="flex flex-col mt-8">
                <DividerHeader>About this quest</DividerHeader>

                <div className="items-center justify-center flex gap-12 mx-20 pt-8">
                  <BadgeCard
                    badgeId={quest.badge.id}
                    isCompleted={isCompleted}
                  />
                  <div className="font-thin flex flex-col gap-4">
                    <HtmlRender content={quest.displayData.intro} />
                    <span className="font-black">
                      {isCompleted
                        ? `Quest completed — ${quest.badge.displayData.title} unlocked.`
                        : "Complete this quest to unlock a new Badge."}
                    </span>
                  </div>
                </div>
              </div>

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
        <div className="border-primary/20 border shadow-sm rounded-lg overflow-hidden pt-10 bg-background/60">
          <DividerHeader className="text-foreground">
            Steps to earn
          </DividerHeader>
          <div className="flex-1 p-8">
            <ActionList
              questSlug={quest.slug as string}
              actions={quest.actions}
            />
          </div>
        </div>
      </div>
    </main>
  );
};

export default QuestDetails;
