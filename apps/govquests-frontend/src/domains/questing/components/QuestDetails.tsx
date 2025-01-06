import { DividerHeader } from "@/components/ui/DividerHeader";
import { Button } from "@/components/ui/shadcn-button";
import ActionList from "@/domains/action_tracking/components/ActionList";
import type { Quest } from "@/domains/questing/types/questTypes";
import { ArrowLeft } from "lucide-react";
import { redirect } from "next/navigation";
import QuestContentSection from "./QuestContentSection";
import { QuestPeels } from "./QuestPeels";

interface QuestDetailsProps {
  quest: Quest;
}

const QuestDetails = ({ quest }: QuestDetailsProps) => {
  if (!quest) return null;

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
                <QuestPeels quest={quest} variant="ghost" />
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
        <div className="border-primary/20 border shadow-sm rounded-lg overflow-hidden pt-10">
          <DividerHeader className="text-black/70">Steps to earn</DividerHeader>
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
