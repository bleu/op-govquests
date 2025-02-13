import { Button } from "@/components/ui/Button";
import { ThirdUserAchievementPanel } from "@/domains/gamification/components/UserAchievementPanel";
import { UserBadgesCollection } from "@/domains/gamification/components/UserBadgesCollection";
import { ArrowLeft } from "lucide-react";
import Link from "next/link";
import { use } from "react";

interface UserPageProps {
  params: Promise<{
    userId: string;
  }>;
}

export default function Page(props: UserPageProps) {
  const params = use(props.params);

  return (
    <div className="flex flex-col gap-9 py-8 px-6">
      <div className="space-y-3">
        <Link href="/leaderboard">
          <Button
            variant="outline"
            className="w-fit hover:bg-background/90"
            size="sm"
          >
            <ArrowLeft />
            Back to leaderboard
          </Button>
        </Link>
        <ThirdUserAchievementPanel userId={params.userId} />
      </div>
      <UserBadgesCollection
        userId={params.userId}
        className="gap-4 lg:grid-cols-5 px-0 mx-0 h-full"
      />
    </div>
  );
}
