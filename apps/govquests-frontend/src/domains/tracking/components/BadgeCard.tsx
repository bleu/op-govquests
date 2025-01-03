import Image from "next/image";

export const BadgeCard = () => {
  return (
    <div className="items-center justify-center min-w-52 h-60 border col-span-2">
      <Image
        src={"https://placehold.co/400"}
        alt="badge_image"
        width={100}
        height={100}
        className="object-cover w-full h-full"
        unoptimized
      />
    </div>
  );
};
