"use client";

import SignInButton from "@/domains/authentication/components/SignInButton";
import { NotificationBell } from "@/domains/notifications/components/NotificationBell";
import { cn, kdamThmorPro } from "@/lib/utils";
import { Book, Calendar, Home, List, MessageCircle } from "lucide-react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import type React from "react";
import {
  NavigationMenu,
  NavigationMenuContent,
  NavigationMenuItem,
  NavigationMenuList,
  NavigationMenuTrigger,
} from "./ui/navigation-menu";

const headerPages = [
  { href: "/", label: "Home" },
  { href: "/quests", label: "Quests" },
  { href: "/achievements", label: "Achievements" },
  { href: "/leaderboard", label: "Leaderboard" },
];

const tools = [
  {
    icon: Home,
    title: "Governance Forum",
    description: "Join discussions",
    href: "https://gov.optimism.io/",
  },
  {
    icon: List,
    title: "Agora",
    description: "Explore proposals",
    href: "https://agora.optimism.io/",
  },
  {
    icon: Book,
    title: "Gov Summarizer",
    description: "View summaries",
    href: "",
  },
  {
    icon: MessageCircle,
    title: "GovGPT",
    description: "Ask questions",
    href: "",
  },
  {
    icon: Calendar,
    title: "Governance Calendar",
    description: "Check events",
    href: "",
  },
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
          <ul className="flex space-x-5 px-1 py-1 items-center">
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

            <NavigationMenu className=" relative">
              <NavigationMenuList>
                <NavigationMenuItem className="group-hover:bg-background">
                  <NavigationMenuTrigger className="flex items-center text-foreground/80 font-normal group-hover:font-extrabold text-md rounded-full transition-all duration-300 group-hover:scale-110">
                    # Tools
                  </NavigationMenuTrigger>
                  <NavigationMenuContent className="hover:bg-background flex flex-col gap-4 p-4">
                    {tools.map(({ icon: Icon, title, description, href }) => (
                      <Link
                        key={title}
                        className="flex flex-col items-start gap-1 whitespace-nowrap group"
                        href={href}
                      >
                        <div className="flex items-center gap-2 group-hover:bg-white/5 transition-all duration-300 px-1 group-hover:sadow-2xl rounded-md">
                          <Icon className="size-3" />
                          <h3 className="text-foreground text-sm">{title}</h3>
                        </div>
                        <p className="text-xs text-foreground/60">
                          {description}
                        </p>
                      </Link>
                    ))}
                  </NavigationMenuContent>
                </NavigationMenuItem>
              </NavigationMenuList>
            </NavigationMenu>
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
