"use client";

import SignInButton from "@/domains/authentication/components/SignInButton";
import { NotificationBell } from "@/domains/notifications/components/NotificationBell";
import { cn, kdamThmorPro } from "@/lib/utils";
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
    <header className="w-full max-w-[1200px] mx-auto py-4 px-4 z-50">
      <div className="flex justify-between items-center align-middle w-full">
        <Link
          href="/"
          className={cn(
            "text-foreground rounded-md font-normal text-3xl [text-shadow:2px_4px_0_rgb(0,0,0)]",
            kdamThmorPro.className,
          )}
        >
          govquests
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

        <div className="flex items-center gap-4 min-w-[300px] justify-end">
          <NotificationBell />
          <SignInButton />
        </div>
      </div>
    </header>
  );
};

export default Header;
