import { DividerHeader } from "@/components/ui/DividerHeader";
import HtmlRender from "@/components/ui/HtmlRender";
import { cn } from "@/lib/utils";
import type React from "react";

interface QuestContentSectionProps {
  title: string;
  content: string;
  className?: string;
}

const QuestContentSection: React.FC<QuestContentSectionProps> = ({
  title,
  className,
  content,
}) => {
  return (
    <div className={cn("mt-8", className)}>
      <h1 className="flex items-center gap-3 justify-center">
        <DividerHeader>{title}</DividerHeader>
      </h1>
      <div className="m-9 px-20 font-thin">
        <HtmlRender content={content} />
      </div>
    </div>
  );
};

export default QuestContentSection;
