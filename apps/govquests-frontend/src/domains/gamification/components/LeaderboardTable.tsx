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

export const LeaderboardTable = ({
  leaderboard,
}: {
  leaderboard: ResultOf<typeof TIER_QUERY>["tier"]["leaderboard"];
}) => {
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
            <TableHead>#</TableHead>
            <TableHead>Address</TableHead>
            <TableHead>Points</TableHead>
            <TableHead>Voting Power</TableHead>
            <TableHead />
          </TableRow>
        </TableHeader>
        <TableBody className="text-sm font-bold">
          {leaderboard.gameProfiles.map((profile) => (
            <UserTableRow profile={profile} key={profile.profileId} />
          ))}
        </TableBody>
      </Table>
    </div>
  );
};

const UserTableRow = ({
  profile,
}: {
  profile: ResultOf<
    typeof TIER_QUERY
  >["tier"]["leaderboard"]["gameProfiles"][number];
}) => {
  const { data } = useUserProfile(profile.user.address as `0x${string}`);

  return (
    <TableRow
      key={profile.profileId}
      className="bg-background/50 hover:bg-background hover:shadow-[0_4px_6px_0_#00000040]"
    >
      <TableCell className="py-4 rounded-l-lg">{profile.rank}</TableCell>
      {data && <TableCell className="py-4 w-1/3">{data.name}</TableCell>}
      <TableCell className="py-4">{profile.score}</TableCell>
      <TableCell className="py-4">20,7K OP (3%)</TableCell>
      <TableCell className="rounded-r-lg flex justify-end items-center">
        <Dialog>
          <DialogTrigger asChild>
            <Button
              variant="outline"
              size="sm"
              className="px-2 py-1 mt-[2px] mr-2"
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
