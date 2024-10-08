import {
  HomeIcon,
  MapIcon,
  SmileIcon,
  StarIcon,
  TrophyIcon,
} from "lucide-react";
import Link from "next/link";
import type React from "react";
import Button from "./ui/Button";
import SignInButton from "@/domains/authentication/components/SignInButton";

const Header: React.FC = () => {
  return (
    <header className="p-8">
      <div className="flex justify-between items-center">
        <Link
          href="/"
          className="bg-optimism text-optimismForeground px-12 py-1 rounded-md"
        >
          Logo
        </Link>

        <nav className="bg-optimism rounded-lg">
          <ul className="flex space-x-5 px-1 py-1">
            <li>
              <Link
                href="/quests"
                className="flex items-center text-optimismForeground px-3 py-1 rounded-full hover:bg-optimism/70 transition"
              >
                <MapIcon className="w-4 h-4 mr-1" />
                Quests
              </Link>
            </li>
            <li>
              <Link
                href="/"
                className="flex items-center text-optimismForeground px-3 py-1 rounded-full hover:bg-optimism/70 transition"
              >
                <HomeIcon className="w-4 h-4 mr-1" />
                Home
              </Link>
            </li>
            <li>
              <Link
                href="/leaderboard"
                className="flex items-center text-optimismForeground px-3 py-1 rounded-full hover:bg-optimism/70 transition"
              >
                <StarIcon className="w-4 h-4 mr-1" />
                Leaderboard
              </Link>
            </li>
          </ul>
        </nav>

        <SignInButton />
      </div>
    </header>
  );
};

export default Header;
