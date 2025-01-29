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
              <TrophyIcon rank={value} size={22} className="my-4" />
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
          </TableRow>
        </TableHeader>
        <TableBody className="text-sm font-bold">
          {leaderboard.gameProfiles.map((profile, index) => (
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
      {data && <TableCell className="py-4">{data.name}</TableCell>}
      <TableCell className="py-4">{profile.score}</TableCell>
      <TableCell className="py-4 rounded-r-lg">20,7K OP (3%)</TableCell>
    </TableRow>
  );
};
