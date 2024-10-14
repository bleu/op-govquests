import { ResultOf } from "gql.tada";
import { QuestQuery } from "../graphql/questQuery";
import { QuestsQuery } from "../graphql/questsQuery";

export type Quests = ResultOf<typeof QuestsQuery>["quests"];

export type Quest = NonNullable<ResultOf<typeof QuestQuery>["quest"]>;
export type Action = Quest["actions"][number];
export type Rewards = Quest["rewards"];
export type ActionExecution = NonNullable<Action["actionExecutions"]>[number];
