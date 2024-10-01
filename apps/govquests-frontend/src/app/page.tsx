"use client";

import Quest from "@/components/Quest";
import type { Quest as QuestType } from "@/types/quest";
import { getQuests } from "@/utils/api";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";

export default function Home() {
  const [quests, setQuests] = useState<QuestType[]>([]);
  const [loading, setLoading] = useState(true);

  const router = useRouter();

  useEffect(() => {
    const fetchQuests = async () => {
      try {
        const data = await getQuests();
        setQuests(data);
        setLoading(false);
        console.log(data);
      } catch (err) {
        setLoading(false);
      }
    };

    fetchQuests();
  }, []);

  if (loading) return <div>Loading...</div>;
  return (
    <main className="p-6 flex-1">
      <h2 className="text-2xl">Here's some quests for you!</h2>
      <span className="text-lg bg-green mb-4">
        We selected them based on your profile
      </span>
      <div className="mt-6 grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 2xl:grid-cols-5 gap-5">
        {quests.map((quest) => (
          <Quest
            key={quest.title}
            title={quest.title}
            altText={quest.title}
            imageSrc={quest.img_url}
            rewards={quest.rewards}
            status={quest.status}
            onClick={() => router.push("1")}
          />
        ))}
      </div>
    </main>
  );
}
