"use client";

import SignInButton from "@/domains/authentication/components/SignInButton";
import { NotificationBell } from "@/domains/notifications/components/NotificationBell";
import { cn } from "@/lib/utils";
import { HomeIcon, MapIcon, StarIcon } from "lucide-react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import type React from "react";

const Header: React.FC = () => {
  const currentPath = usePathname();

  return (
    <header className="p-8">
      <div className="flex justify-between items-center">
        <Link
          href="/"
          className="bg-primary text-foreground px-12 py-1 rounded-md"
        >
          Logo
        </Link>

        <nav className="bg-primary rounded-lg">
          <ul className="flex space-x-5 px-1 py-1">
            <li>
              <Link
                className={cn(
                  "flex items-center text-foreground px-3 py-1 rounded-full hover:bg-primary/70 transition",
                  currentPath.startsWith("/quests") && "font-bold",
                )}
                href="/quests"
              >
                <MapIcon className="w-4 h-4 mr-1" />
                Quests
              </Link>
            </li>
            <li>
              <Link
                className={cn(
                  "flex items-center text-foreground px-3 py-1 rounded-full hover:bg-primary/70 transition",
                  currentPath === "/" && "font-bold",
                )}
                href="/"
              >
                <HomeIcon className="w-4 h-4 mr-1" />
                Home
              </Link>
            </li>
            <li>
              <Link
                className={cn(
                  "flex items-center text-foreground px-3 py-1 rounded-full hover:bg-primary/70 transition",
                  currentPath.startsWith("/leaderboard") && "font-bold",
                )}
                href="/leaderboard"
              >
                <StarIcon className="w-4 h-4 mr-1" />
                Leaderboard
              </Link>
            </li>
          </ul>
        </nav>

        <div className="flex items-center gap-4">
          <NotificationBell />
          <SignInButton />
        </div>
      </div>
    </header>
  );
};

export default Header;
