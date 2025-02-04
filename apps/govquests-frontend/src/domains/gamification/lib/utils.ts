export const formatVotingPower = (votingPower: number) => {
  if (votingPower < 1000) {
    return votingPower.toLocaleString();
  }

  if (votingPower < 1000000) {
    const thousands = (votingPower / 1000).toFixed(1);
    return thousands.replace(/\.0$/, "") + "K";
  }

  const millions = (votingPower / 1000000).toFixed(1);
  return millions.replace(/\.0$/, "") + "M";
};

export const sortBadges = (data) => {
  data.badges.sort(
    (a, b) => Number(b.earnedByCurrentUser) - Number(a.earnedByCurrentUser),
  );
  return data;
};
