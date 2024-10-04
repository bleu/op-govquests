import Button from "@/components/Button";
import Link from "next/link";

export default async function Home() {
  return (
    <main className="flex flex-1 flex-col h-full items-center justify-center">
      <h1 className="font-bold text-6xl text-center">Our value proposition</h1>
      <h2 className="font-medium text-4xl my-8">Brief description</h2>
      <Link
        className="bg-optimism text-optimismForeground px-4 py-2 rounded-md"
        href="quests"
      >
        Begin your journey
      </Link>
    </main>
  );
}
