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
    <div className={cn(`mt-8`, className)}>
      <div className="flex items-center gap-3 justify-center">
        <div className="flex items-center justify-center w-full gap-9">
          <div className="border-b h-0 w-full" />
          <div className="text-xl font-medium text-foreground/50 whitespace-nowrap">
            {title}
          </div>
          <div className="border-b h-0 w-full" />
        </div>
      </div>
      <div className="m-9 px-20">
        <HtmlRender content={content} />
      </div>
    </div>
  );
};

export default QuestContentSection;
