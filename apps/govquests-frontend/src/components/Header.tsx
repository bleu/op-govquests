"use client";

import SignInButton from "@/domains/authentication/components/SignInButton";
import { NotificationBell } from "@/domains/notifications/components/NotificationBell";
import { cn, kdamThmorPro } from "@/lib/utils";
import {
  Book,
  Calendar,
  ChevronDown,
  Home,
  List,
  MessageCircle,
  Sidebar,
} from "lucide-react";
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
import { useBreakpoints } from "@/hooks/useBreakpoints";
import { HamburgerMenuIcon } from "@radix-ui/react-icons";
import { useState } from "react";
import { Button } from "./ui/Button";

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
    href: "https://op-chat.bleu.builders/forum",
  },
  {
    icon: MessageCircle,
    title: "GovGPT",
    description: "Ask questions",
    href: "https://op-chat.bleu.builders/chat",
  },
  {
    icon: Calendar,
    title: "Governance Calendar",
    description: "Check events",
    href: "https://calendar.google.com/calendar/embed?src=c_fnmtguh6noo6qgbni2gperid4k%40group.calendar.google.com&ctz=Europe%2FBerlin",
  },
];

const Header: React.FC = () => {
  const currentPath = usePathname();
  const { isSmallerThan, isLargerThan, isMedium } = useBreakpoints();

  return (
    <header className="w-full max-w-[1200px] mx-auto py-4 px-4 z-50 bg-background/70">
      <div className="flex justify-between items-center align-middle w-full">
        {isSmallerThan.lg && <SideMenu />}

        {isLargerThan.md && (
          <Link
            href="/"
            className={cn(
              "text-foreground rounded-md font-normal text-3xl [text-shadow:2px_4px_0_rgb(0,0,0)] w-36",
              isMedium &&
                "absolute left-1/2 transform -translate-x-1/2 text-center",
              kdamThmorPro.className,
            )}
          >
            govquests
          </Link>
        )}

        {isLargerThan.lg && (
          <nav>
            <ul className="flex space-x-5 px-1 py-1 items-center">
              {headerPages.map(({ href, label }) => (
                <li key={href}>
                  <Link
                    className={cn(
                      "flex items-center text-foreground/80 px-3 py-1 rounded-full transition hover:scale-110 w-fit",
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
                    <NavigationMenuTrigger className="flex items-center text-foreground/80 font-normal group-hover:font-extrabold focus:outline-none active:outline-none text-md rounded-full transition-transform duration-300 group-hover:scale-110">
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
        )}

        <div className="flex items-center gap-4 justify-end">
          <NotificationBell />
          <SignInButton />
        </div>
      </div>
    </header>
  );
};

const SideMenu = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [isExpanded, setIsExpanded] = useState(false);
  const currentPath = usePathname();

  const toggleSideBar = () => setIsOpen((state) => !state);

  return (
    <div className="flex items-center gap-4">
      <HamburgerMenuIcon onClick={toggleSideBar} className="size-4" />
      <div
        className={cn(
          "fixed left-0 top-0 h-full min-w-52 bg-background rounded-r-xl border-r border-foreground/10 shadow-2xl z-30 py-4 px-2 flex flex-col items-center",
          "transform -translate-x-full transition-transform duration-300 ease-in-out",
          isOpen && "translate-x-0",
        )}
      >
        <span
          className={cn(
            "text-foreground rounded-md font-normal text-3xl [text-shadow:2px_4px_0_rgb(0,0,0)] w-36",
            kdamThmorPro.className,
          )}
        >
          govquests
        </span>
        <ul className="flex flex-col space-y-4 py-1 items-left w-full mt-8">
          {headerPages.map(({ href, label }) => (
            <li key={href}>
              <Link
                className={cn(
                  "flex items-center text-foreground/80 px-3 py-1 rounded-full transition w-fit",
                  (currentPath === href ||
                    (href !== "/" && currentPath.startsWith(href))) &&
                    "font-black text-foreground",
                )}
                href={href}
                onClick={() => {
                  setTimeout(toggleSideBar, 150);
                }}
              >
                # {label}
              </Link>
            </li>
          ))}
          <div className="w-full">
            {/* Tools Header/Trigger */}
            <button
              type="button"
              onClick={() => setIsExpanded(!isExpanded)}
              className="flex items-center justify-between w-full px-3 py-1 text-foreground/80"
            >
              <span># Tools</span>
              <ChevronDown
                className={cn(
                  "size-4 transition-transform duration-200",
                  isExpanded && "transform rotate-180",
                )}
              />
            </button>

            {/* Tools Content */}
            <div
              className={cn(
                "overflow-hidden transition-all duration-300 ease-in-out",
                isExpanded ? "max-h-[500px] opacity-100" : "max-h-0 opacity-0",
              )}
            >
              <div className="px-3 py-2 space-y-1">
                {tools.map(({ icon: Icon, title, description, href }) => (
                  <Link
                    key={title}
                    href={href}
                    onClick={() => {
                      setTimeout(toggleSideBar, 150);
                    }}
                    className="block group"
                  >
                    <div className="flex items-center gap-2 p-2 rounded-md transition-colors hover:bg-white/5">
                      <Icon className="size-3 text-foreground/70" />
                      <div>
                        <h3 className="text-sm text-foreground">{title}</h3>
                        <p className="text-xs text-foreground/60 mt-0.5">
                          {description}
                        </p>
                      </div>
                    </div>
                  </Link>
                ))}
              </div>
            </div>
          </div>
        </ul>
      </div>
      <div
        className={cn(
          "bg-background/50 w-full absolute top-0 left-0 right-0 bottom-0 opacity-0 transition-opacity duration-300 -z-10 pointer-events-none",
          isOpen && "z-20 opacity-100 pointer-events-auto",
        )}
        onClick={toggleSideBar}
        onKeyUp={(e) => {
          if (e.key === "Enter" || e.key === " ") {
            toggleSideBar();
          }
        }}
        tabIndex={0}
        role="button"
        aria-label="Close sidebar"
      />
    </div>
  );
};

export default Header;
