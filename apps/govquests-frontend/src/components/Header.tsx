"use client";

import SignInButton from "@/domains/authentication/components/SignInButton";
import { NotificationBell } from "@/domains/notifications/components/NotificationBell";
import { cn } from "@/lib/utils";
import { HomeIcon, MapIcon, StarIcon } from "lucide-react";
import Image from "next/image";
import Link from "next/link";
import { usePathname } from "next/navigation";
import type React from "react";

const headerPages = [
  { href: "/", label: "Home" },
  { href: "/quests", label: "Quests" },
  { href: "/achievements", label: "Achievements" },
  { href: "/leaderboard", label: "Leaderboard" },
];

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
            {headerPages.map(({ href, label }) => (
              <li key={href}>
                <Link
                  className={cn(
                    "flex items-center text-foreground/80 px-3 py-1 rounded-full transition hover:scale-110",
                    (currentPath === href ||
                      (href !== "/" && currentPath.startsWith(href))) &&
                      "font-black text-foreground",
                  )}
                  href={href}
                >
                  # {label}
                </Link>
              </li>
            ))}
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
