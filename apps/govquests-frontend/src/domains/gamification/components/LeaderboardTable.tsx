import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { ResultOf } from "gql.tada";
import { TIER_QUERY } from "../graphql/tierQuery";
import { useUserProfile } from "@/hooks/useUserProfile";
import { TrophyIcon } from "./PodiumCard";
import { Button } from "@/components/ui/Button";
import { Dialog, DialogTrigger } from "@/components/ui/dialog";
import { ProfileDialogContent } from "./ProfileDialogContent";
import { useEffect, useMemo, useRef } from "react";
import { useSearchParams } from "next/navigation";
import { cn } from "@/lib/utils";

export const LeaderboardTable = ({
  leaderboard,
}: {
  leaderboard: ResultOf<typeof TIER_QUERY>["tier"]["leaderboard"];
}) => {
  const searchParams = useSearchParams();
  const targetRank: number = useMemo(() => {
    return Number(searchParams.get("rank"));
  }, [searchParams]);

  return (
    <div className="flex gap-4">
      <div className=" mt-16 flex flex-col gap-3">
        {[1, 2, 3].map(
          (value) =>
            leaderboard.gameProfiles.length >= value && (
              <TrophyIcon rank={value} size={22} className="my-4" key={value} />
            ),
        )}
      </div>
      <Table className="border-separate border-spacing-y-3">
        <TableHeader className="text-sm font-bold">
          <TableRow className="hover:bg-inherit">
            <TableHead className="px-4 w-fit">#</TableHead>
            <TableHead>Address</TableHead>
            <TableHead>Points</TableHead>
            <TableHead>Voting Power</TableHead>
            <TableHead />
          </TableRow>
        </TableHeader>
        <TableBody className="text-sm font-bold">
          {leaderboard.gameProfiles.map((profile) => (
            <UserTableRow
              profile={profile}
              key={profile.profileId}
              isTarget={profile.rank === targetRank}
            />
          ))}
        </TableBody>
      </Table>
    </div>
  );
};

interface UserTableRowProps {
  profile: ResultOf<
    typeof TIER_QUERY
  >["tier"]["leaderboard"]["gameProfiles"][number];
  isTarget?: boolean;
}

const UserTableRow = ({ profile, isTarget }: UserTableRowProps) => {
  const { data } = useUserProfile(profile.user.address as `0x${string}`);

  const rowRef = useRef<HTMLTableRowElement>(null);

  useEffect(() => {
    if (isTarget && rowRef.current) {
      rowRef.current.scrollIntoView({
        behavior: "smooth",
        block: "center",
      });
    }
  }, [isTarget]);

  return (
    <TableRow
      key={profile.profileId}
      className={cn(
        "bg-background/50 hover:bg-background transition-all hover:shadow-[0_4px_6px_0_#00000040] duration-300 overflow-hidden rounded-lg",
        isTarget && "bg-background shadow-[0_4px_6px_0_#00000040]",
      )}
      ref={rowRef}
    >
      <TableCell className="py-4 rounded-l-lg w-fit px-4">
        {profile.rank}
      </TableCell>
      {data && <TableCell className="py-4 w-1/3">{data.name}</TableCell>}
      <TableCell className="py-4 w-1/4">{profile.score}</TableCell>
      <TableCell className="py-4 w-1/4">20,7K OP (3%)</TableCell>
      <TableCell className="rounded-r-lg w-fit self-end">
        <Dialog>
          <DialogTrigger asChild>
            <Button
              variant="outline"
              size="sm"
              className="px-2 py-1 mt-[2px] mr-2 hover:bg-inherit"
            >
              See profile
            </Button>
          </DialogTrigger>
          <ProfileDialogContent userId={profile.user.id} />
        </Dialog>
      </TableCell>
    </TableRow>
  );
};
