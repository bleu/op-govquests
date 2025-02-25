import { cn } from "@/lib/utils";
import type React from "react";

interface HtmlRenderProps {
  content: string;
  className?: string;
}

const HtmlRender: React.FC<HtmlRenderProps> = ({ content, className }) => {
  return (
    <div
      className={cn(
        "prose prose-sm max-w-none font-thin text-foreground/80",
        "prose-a:underline prose-a:text-foreground/80",
        "prose-strong:font-bold prose-strong:text-inherit",
        "prose-ul:list-disc prose-ul:pl-5 prose-ul:mt-0",
        "prose-li:pl-0 prose-li:my-0",
        className,
      )}
      // biome-ignore lint/security/noDangerouslySetInnerHtml: <explanation>
      dangerouslySetInnerHTML={{
        __html: content || "",
      }}
    />
  );
};

export default HtmlRender;
