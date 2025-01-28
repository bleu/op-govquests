import { useAccount, useEnsAvatar, useEnsName } from "wagmi";

export const useUserProfile = () => {
  const { address } = useAccount();

  const {
    data: ensName,
    isLoading: isNameLoading,
    isSuccess: isNameSuccess,
  } = useEnsName({
    address,
    chainId: 1,
  });

  const {
    data: avatarUrl,
    isLoading: isAvatarLoading,
    isSuccess: isAvatarSuccess,
  } = useEnsAvatar({
    name: ensName,
    chainId: 1,
  });

  const getDisplayAddress = () => {
    if (!address) return "";
    if (ensName) return ensName;
    return `${address.slice(0, 6)}...${address.slice(-4)}`;
  };

  const getAvatarUrl = () => {
    if (avatarUrl) return avatarUrl;
    if (address) return `https://effigy.im/a/${address}`;
    return "";
  };

  return {
    isLoading: isNameLoading || isAvatarLoading,
    isSuccess: isNameSuccess && isAvatarSuccess,
    data: {
      avatarUrl: getAvatarUrl(),
      name: getDisplayAddress(),
    },
  };
};
