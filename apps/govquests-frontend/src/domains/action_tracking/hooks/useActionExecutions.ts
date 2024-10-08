import { useQuery } from "@tanstack/react-query";
import { fetchActionExecutions } from "../services/actionService";
import { ActionExecution } from "../types/actionTypes";

export const useActionExecutions = (actionId: string) => {
  return useQuery({
    queryKey: ["actionExecutions", actionId],
    queryFn: () => fetchActionExecutions(actionId),
    enabled: !!actionId,
  });
};
