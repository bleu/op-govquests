import { ResultOf } from "gql.tada";
import { TracksQuery } from "../graphql/tracksQuery";

export type Tracks = ResultOf<typeof TracksQuery>["tracks"];

export type Badge = {
  id: string;
  image: string;
  title: string;
  description?: string;
};
