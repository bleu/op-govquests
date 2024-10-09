import { useMutation } from "@tanstack/react-query";
import { generateSiweMessage, signOut } from "./services/authService";
import { signInWithEthereum } from "./services/authService";
import { useQuery } from "@tanstack/react-query";
import { fetchCurrentUser } from "./services/authService";

export const useGenerateSiweMessage = () => {
  return useMutation({
    mutationFn: generateSiweMessage,
  });
};

export const useSignInWithEthereum = () => {
  return useMutation({
    mutationFn: signInWithEthereum,
  });
};

export const useSignOut = () => {
  return useMutation({
    mutationFn: signOut,
  });
};

export const useCurrentUser = () => {
  return useQuery({
    queryKey: ["currentUser"],
    queryFn: fetchCurrentUser,
  });
};
