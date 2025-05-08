import { useState } from "react";
import { Bell, Loader2 } from "lucide-react";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import { Button } from "@/components/ui/Button";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  useNotifications,
  useUnreadCount,
  useMarkNotificationAsRead,
  useMarkAllNotificationsAsRead,
} from "../hooks/useNotifications";
import { Badge } from "@/components/ui/badge";
import { cn } from "@/lib/utils";
import { useInView } from "react-intersection-observer";
import { useNotificationProcessor } from "../hooks/useNotificationProcessor";
import HtmlRender from "@/components/ui/HtmlRender";
import { NOTIFICATION_TITLES_MAP } from "../lib/constants";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { NotificationSettings } from "./NotificationSettings";

export const NotificationBell = () => {
  const { data: unreadCount } = useUnreadCount();
  const [isOpen, setIsOpen] = useState(false);
  useNotificationProcessor();

  return (
    <Popover open={isOpen} onOpenChange={setIsOpen}>
      <PopoverTrigger asChild>
        <Button
          variant="ghost"
          size="icon"
          className="relative w-8 h-8 rounded-full"
        >
          <Bell className="h-4 w-4" />
          {unreadCount !== undefined && unreadCount > 0 && (
            <Badge
              variant="destructive"
              className="absolute -top-1 -right-1 h-4 min-w-[16px] px-1 flex items-center justify-center text-[10px]"
            >
              {unreadCount > 99 ? "99+" : unreadCount}
            </Badge>
          )}
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-96 p-0" align="end" sideOffset={5}>
        <NotificationPanel onNotificationClick={() => setIsOpen(false)} />
      </PopoverContent>
    </Popover>
  );
};

const NotificationPanel = ({ onNotificationClick }) => {
  const {
    data,
    isError,
    isLoading,
    hasNextPage,
    fetchNextPage,
    isFetchingNextPage,
  } = useNotifications();

  const { mutate: markAllAsRead, isPending: isMarkingAllAsRead } =
    useMarkAllNotificationsAsRead();

  const { mutate: markAsRead } = useMarkNotificationAsRead();

  const { ref: loadMoreRef } = useInView({
    onChange: (inView) => {
      if (inView && hasNextPage) {
        fetchNextPage();
      }
    },
  });

  const handleMarkAllAsRead = () => {
    markAllAsRead("in_app", {
      onSuccess: () => {
        // Could add a toast notification here if desired
        console.log("All notifications marked as read");
      },
      onError: (error) => {
        console.error("Error marking all notifications as read:", error);
        // Could add error handling/toast here
      },
    });
  };

  if (isLoading) {
    return (
      <div className="py-8 text-center text-muted-foreground">
        <Loader2 className="h-4 w-4 animate-spin mx-auto" />
      </div>
    );
  }

  if (isError) {
    return (
      <div className="p-3 text-center text-destructive text-sm">
        Error loading notifications
      </div>
    );
  }

  const notifications =
    data?.pages.flatMap((page) => page.notifications.edges) ?? [];

  return (
    <>
      <div className="flex items-center justify-between">
        <Tabs defaultValue="notifications" className="w-full">
          <TabsList className="w-full justify-start flex bg-inherit border-b rounded-none py-6">
            <TabsTrigger value="notifications"># Notifications</TabsTrigger>
            <TabsTrigger value="settings"># Settings</TabsTrigger>
          </TabsList>
          <TabsContent value="notifications" className="w-full">
            <ScrollArea className="h-[300px] w-full">
              <div className="flex flex-col">
                {notifications.length === 0 ? (
                  <div className="py-8 text-center text-muted-foreground text-sm">
                    No notifications
                  </div>
                ) : (
                  notifications.map(({ node }) => (
                    <NotificationItem
                      key={node.id}
                      notification={node}
                      onClick={() => {
                        onNotificationClick();
                        if (node.status === "unread") {
                          markAsRead(node.id);
                        }
                      }}
                    />
                  ))
                )}
                {hasNextPage && (
                  <div ref={loadMoreRef} className="p-2 flex justify-center">
                    {isFetchingNextPage ? (
                      <Loader2 className="h-4 w-4 animate-spin" />
                    ) : (
                      <span className="text-xs text-muted-foreground">
                        Load more
                      </span>
                    )}
                  </div>
                )}
              </div>
            </ScrollArea>
            <div className="p-1 flex flex-row-reverse border-t">
              <Button
                variant="ghost"
                size="sm"
                className="h-7 text-xs hover:bg-background hover:text-foreground"
                onClick={handleMarkAllAsRead}
                disabled={isMarkingAllAsRead}
              >
                {isMarkingAllAsRead ? (
                  <Loader2 className="h-3 w-3 animate-spin mr-1" />
                ) : null}
                Mark all as read
              </Button>
            </div>
          </TabsContent>
          <TabsContent value="settings" className="w-full px-6 py-2.5">
            <NotificationSettings />
          </TabsContent>
        </Tabs>
      </div>
    </>
  );
};

const NotificationItem = ({ notification, onClick }) => {
  const { mutate: markAsRead } = useMarkNotificationAsRead();

  const handleClick = () => {
    onClick();
    if (notification.status === "unread") {
      markAsRead(notification.id);
    }
  };

  return (
    <button
      className={cn(
        "flex flex-col gap-0.5 p-3 text-left hover:bg-muted transition-colors w-full",
        "border-b last:border-b-0",
        notification.status === "read" && "text-foreground/60",
      )}
      onClick={handleClick}
      type="button"
    >
      <div className="flex flex-col justify-between items-start gap-2">
        <div className="flex flex-col">
          <p className="text-sm font-medium">
            {NOTIFICATION_TITLES_MAP[notification.notificationType]}
          </p>
          <p className="text-sm flex-1">
            <HtmlRender
              content={notification.content}
              className={cn(
                "text-foreground font-thin",
                notification.status === "read" && "opacity-60",
              )}
            />
          </p>
        </div>
        <time className="text-xs whitespace-nowrap">
          {formatDate(notification.createdAt)}
        </time>
      </div>
    </button>
  );
};

const formatDate = (dateString) => {
  const date = new Date(dateString);
  const now = new Date();
  const diff = now.getTime() - date.getTime();

  // Less than 24 hours ago
  if (diff < 24 * 60 * 60 * 1000) {
    return date.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
  }

  // Less than a week ago
  if (diff < 7 * 24 * 60 * 60 * 1000) {
    return date.toLocaleDateString([], { weekday: "short" });
  }

  // Otherwise show full date
  return date.toLocaleDateString();
};

export default NotificationBell;
