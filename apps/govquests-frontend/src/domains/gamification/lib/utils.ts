export const sortBadges = (data) => {
  data.badges.sort(
    (a, b) => Number(b.earnedByCurrentUser) - Number(a.earnedByCurrentUser),
  );
  return data;
};
