"use client";

import SignInButton from "@/domains/authentication/components/SignInButton";
import { NotificationBell } from "@/domains/notifications/components/NotificationBell";
import { cn } from "@/lib/utils";
import { HomeIcon, MapIcon, StarIcon } from "lucide-react";
import Image from "next/image";
import Link from "next/link";
import { usePathname } from "next/navigation";
import type React from "react";

const Header: React.FC = () => {
  const currentPath = usePathname();

  return (
    <header className="p-8 pr-16">
      <div className="flex justify-between items-center">
        <Link href="/" className="text-foreground py-1 rounded-md">
          <Image src="/logo.svg" alt="logo" width={200} height={200} />
        </Link>

        <nav>
          <ul className="flex space-x-5 px-1 py-1">
            <li>
              <Link
                className={cn(
                  "flex items-center text-foreground/80 px-3 py-1 rounded-full transition hover:scale-110",
                  currentPath.startsWith("/quests") &&
                    "font-black text-foreground",
                )}
                href="/quests"
              >
                # Quests
              </Link>
            </li>
            <li>
              <Link
                className={cn(
                  "flex items-center text-foreground/80 px-3 py-1 rounded-full transition hover:scale-110",
                  currentPath === "/" && "font-black text-foreground",
                )}
                href="/"
              >
                # Achievements
              </Link>
            </li>
            <li>
              <Link
                className={cn(
                  "flex items-center text-foreground/80 px-3 py-1 rounded-full transition hover:scale-110",
                  currentPath.startsWith("/leaderboard") &&
                    "font-black text-foreground",
                )}
                href="/leaderboard"
              >
                # Leaderboard
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
