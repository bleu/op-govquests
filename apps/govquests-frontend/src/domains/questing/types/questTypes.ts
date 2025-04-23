import type { ResultOf } from "gql.tada";
import type { QuestQuery } from "../graphql/questQuery";
import type { QuestsQuery } from "../graphql/questsQuery";

export type Quests = ResultOf<typeof QuestsQuery>["quests"];

export type Quest = NonNullable<ResultOf<typeof QuestQuery>["quest"]>;
export type Action = Quest["actions"][number];
export type Rewards = Quest["rewardPools"];
export type ActionExecution = NonNullable<Action["actionExecutions"]>[number];
