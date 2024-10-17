import React from "react";

interface QuestContentSectionProps {
  title: string;
  content: string;
  className?: string;
}

const QuestContentSection: React.FC<QuestContentSectionProps> = ({
  title,
  content,
  className,
}) => {
  return (
    <div className={`border-t-2 mt-8 pt-3 ${className}`}>
      <h2 className="text-2xl font-medium mb-2">{title}</h2>
      <p>{content}</p>
    </div>
  );
};

export default QuestContentSection;
