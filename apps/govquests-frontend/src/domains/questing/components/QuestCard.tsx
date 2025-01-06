import Link from "next/link";
import type React from "react";

import Image from "@/components/ui/Image";
import { Quests } from "../types/questTypes";
import { QuestPeels } from "./QuestPeels";

interface QuestProps {
  quest: Quests[number];
}

const QuestCard: React.FC<QuestProps> = ({ quest }) => {
  return (
    <Link
      href={`/quests/${quest.slug}`}
      className="group flex flex-col bg-primary/10 border border-primary/20 rounded-lg overflow-hidden transition-all duration-200 hover:shadow-md hover:bg-primary/15"
    >
      <div className="relative w-full h-48 overflow-hidden">
        <div className="absolute w-21 flex left-0 right-0 top-0 z-10 p-3 justify-between items-start">
          <QuestPeels
            quest={quest}
            variant="primary"
            className="flex flex-col gap-3"
          />
        </div>
        {quest.displayData.imageUrl ? (
          <Image
            src={quest.displayData.imageUrl}
            alt={`QuestCard ${quest.displayData.title} image`}
            className="object-cover w-full h-full transition-transform duration-200 group-hover:scale-105"
          />
        ) : (
          <div className="w-full h-full bg-primary/5" />
        )}
      </div>
      <div className="flex flex-col p-7 gap-4">
        <h3 className="font-semibold text-lg leading-tight line-clamp-2 group-hover:text-primary/90 transition-colors flex gap-2">
          {quest.displayData.title}
        </h3>
        <p className="text-sm text-foreground/70 line-clamp-3">
          <span
            dangerouslySetInnerHTML={{
              __html: quest.displayData.intro || "",
            }}
          />
        </p>
      </div>
    </Link>
  );
};

export default QuestCard;
