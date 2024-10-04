import type { Step } from "@/types/quest";
import { ExternalLink } from "lucide-react";
import Link from "next/link";
import type React from "react";

interface Quest {
  title: string;
  intro: string;
  steps: Step[];
}

interface QuestDetailsProps {
  quest: Quest;
}

const QuestDetails: React.FC<QuestDetailsProps> = ({ quest }) => {
  return (
    <main className="flex flex-1 items-center justify-center bg-zinc-100">
      <div className="flex flex-col flex-1">
        <div className="flex flex-1 items-center mx-32 p-8 bg-red-300 rounded-lg mb-3">
          <div className="w-16 h-16 bg-red-200" />
          <h1 className="text-3xl flex-1 ml-5">{quest.title}</h1>
          <div className="flex items-center">
            <div className="w-4 h-4 bg-red-200" />
            <span>+ 1234</span>
          </div>
        </div>
        <div className="flex flex-col flex-1 mx-32 justify-center bg-white p-8">
          <div className="flex items-center">
            <div className="w-16 h-16 bg-green-100" />
            <div className="ml-7">
              <h2 className="text-2xl font-medium mb-2">About this quest</h2>
              <p className="text-lg">{quest.intro}</p>
            </div>
          </div>
          <div className="flex items-center my-6">
            <div className="w-4 h-4 bg-zinc-300" />
            <h2 className="ml-4 text-xl font-medium">Steps to earn</h2>
          </div>
          {quest.steps.map((step) => (
            <div
              className="flex flex-1 justify-between items-center mt-3"
              key={step.content}
            >
              <span className="flex items-center gap-1">
                {step.content}
                <Link href="https://www.google.com.br">
                  <ExternalLink />
                </Link>
              </span>
              <div className="flex items-center">
                <span>{step.duration} minute read</span>
                <div className="w-4 h-4 bg-white border border-black ml-3" />
              </div>
            </div>
          ))}
          <button
            type="button"
            className="bg-red-400 hover:bg-red-300 text-white font-bold p-4 rounded-lg self-end mt-8"
          >
            Complete quest
          </button>
        </div>
      </div>
    </main>
  );
};

export default QuestDetails;
