"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchUserById, fetchUserInfo } from "../services/userService";

export const useCurrentUserInfo = () => {
  return useQuery({
    queryKey: ["current-user-info"],
    queryFn: () => fetchUserInfo(),
    retry: false,
  });
};

export const useUserInfo = (id: string) => {
  return useQuery({
    queryKey: ["user-info", id],
    queryFn: () => fetchUserById(id),
  });
};
