"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchUserInfo } from "../services/userService";

export const useCompleteUserInfo = () => {
  return useQuery({
    queryKey: ["complete-user-info"],
    queryFn: () => fetchUserInfo(),
  });
};
