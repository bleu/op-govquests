export const titleToSlug = (title: string) => {
  return title.toLowerCase().replace(/\s/g, "-");
};
