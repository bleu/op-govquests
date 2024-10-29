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
    <div className={`border-t-2 mt-8 pt-3 ${className}`}>
      <h2 className="text-2xl font-medium mb-2">{title}</h2>

      <div
        className={cn(
          "prose prose-sm max-w-none",
          "prose-a:underline",
          "prose-strong:font-bold prose-strong:text-inherit",
          "prose-ul:list-disc prose-ul:pl-5 prose-ul:mt-0",
          "prose-li:pl-0 prose-li:my-0",
        )}
        dangerouslySetInnerHTML={{ __html: content }}
      />
    </div>
  );
};

export default QuestContentSection;
