import HtmlRender from "@/components/ui/HtmlRender";
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

      <HtmlRender content={content} />
    </div>
  );
};

export default QuestContentSection;
