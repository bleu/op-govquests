import { cn } from "@/lib/utils";
import type React from "react";

interface HtmlRenderProps {
  content: string;
}

const HtmlRender: React.FC<HtmlRenderProps> = ({ content }) => {
  return (
    <div
      className={cn(
        "prose prose-sm max-w-none",
        "prose-a:underline",
        "prose-strong:font-bold prose-strong:text-inherit",
        "prose-ul:list-disc prose-ul:pl-5 prose-ul:mt-0",
        "prose-li:pl-0 prose-li:my-0",
      )}
      // biome-ignore lint/security/noDangerouslySetInnerHtml: <explanation>
      dangerouslySetInnerHTML={{
        __html: content || "",
      }}
    />
  );
};

export default HtmlRender;
