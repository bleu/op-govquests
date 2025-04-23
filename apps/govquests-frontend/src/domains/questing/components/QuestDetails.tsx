import { IndicatorPill } from "@/components/IndicatorPill";
import RewardIndicator from "@/components/RewardIndicator";
import { Button } from "@/components/ui/Button";
import { DividerHeader } from "@/components/ui/DividerHeader";
import HtmlRender from "@/components/ui/HtmlRender";
import ActionList from "@/domains/action_tracking/components/ActionList";
import { BadgeDialog } from "@/domains/gamification/components/BadgeDialog";
import type { Quest } from "@/domains/questing/types/questTypes";
import { ArrowLeft } from "lucide-react";
import { redirect } from "next/navigation";
import { NormalBadgeCard } from "../../gamification/components/BadgeCard";
import QuestContentSection from "./QuestContentSection";
import { useBreakpoints } from "@/hooks/useBreakpoints";

interface QuestDetailsProps {
  quest: Quest;
}

const QuestDetails = ({ quest }: QuestDetailsProps) => {
  if (!quest) return null;

  const { isLargerThan, isSmallerThan } = useBreakpoints();

  const isCompleted = quest.userQuests?.[0]?.status === "completed";

  return (
    <main className="flex justify-center min-h-full">
      <div className="flex flex-col max-w-5xl py-8 gap-6 w-full mx-6">
        {/* Main content area */}
        <div className="border-primary/20 w-full border shadow-sm py-6 md:py-8 rounded-lg bg-background/60">
          <div className="flex-col">
            <div className="space-y-4 md:px-10 px-6">
              <Button
                variant="outline"
                size="sm"
                className="p-2 h-6 hover:bg-primary/10"
                onClick={() => redirect(`/quests?trackId=${quest.track.id}`)}
              >
                <ArrowLeft className="w-4 h-4 mr-2" />
                Back to Track
              </Button>
              <div className="flex justify-between items-center">
                <h1 className="text-2xl font-bold tracking-tight flex gap-x-3 gap-y-1 flex-col md:flex-row">
                  <span className="text-foreground/60">#QUEST</span>
                  {quest.displayData.title}
                </h1>
                {isLargerThan.md && (
                  <QuestIndicatorPills
                    isCompleted={isCompleted}
                    quest={quest}
                  />
                )}
              </div>
            </div>

            <div className="space-y-8 [&_div]:text-foreground [&_p]:font-bold [&_a]:text-foreground ">
              <div className="flex flex-col mt-8">
                <DividerHeader>About this quest</DividerHeader>

                <div className="items-center justify-center flex gap-x-12 gap-y-4 md:mx-20 mx-6 pt-8 md:flex-row flex-col">
                  {quest.badge.displayData.imageUrl && (
                    <BadgeDialog badgeId={quest.badge.id}>
                      <NormalBadgeCard
                        badgeId={quest.badge.id}
                        className="hover:scale-105 transition-all duration-300 min-w-52 h-60"
                      />
                    </BadgeDialog>
                  )}
                  {isSmallerThan.md && (
                    <QuestIndicatorPills
                      isCompleted={isCompleted}
                      quest={quest}
                    />
                  )}
                  <div className="font-thin flex flex-col gap-4 text-center md:text-left">
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

const QuestIndicatorPills = ({
  isCompleted,
  quest,
}: {
  isCompleted: boolean;
  quest: Quest;
}) => {
  return isCompleted ? (
    <IndicatorPill className="text-xs">Completed</IndicatorPill>
  ) : (
    <RewardIndicator
      reward={quest.rewardPools[0].rewardDefinition}
      className="text-xs"
    />
  );
};

export default QuestDetails;
