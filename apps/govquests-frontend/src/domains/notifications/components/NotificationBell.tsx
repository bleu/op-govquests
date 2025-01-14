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
          className="relative w-8 h-8 rounded-full hover:bg-accent"
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
      <PopoverContent className="w-80 p-0" align="end" sideOffset={5}>
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

  if (!notifications.length) {
    return (
      <div className="py-8 text-center text-muted-foreground text-sm">
        No notifications
      </div>
    );
  }

  return (
    <>
      <div className="flex items-center justify-between p-2 border-b">
        <h4 className="text-sm font-medium">Notifications</h4>
        <Button
          variant="ghost"
          size="sm"
          className="h-7 text-xs"
          onClick={handleMarkAllAsRead}
          disabled={isMarkingAllAsRead}
        >
          {isMarkingAllAsRead ? (
            <Loader2 className="h-3 w-3 animate-spin mr-1" />
          ) : null}
          Mark all as read
        </Button>
      </div>
      <ScrollArea className="h-[300px]">
        <div className="flex flex-col">
          {notifications.map(({ node }) => (
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
          ))}
          {hasNextPage && (
            <div ref={loadMoreRef} className="p-2 flex justify-center">
              {isFetchingNextPage ? (
                <Loader2 className="h-4 w-4 animate-spin" />
              ) : (
                <span className="text-xs text-muted-foreground">Load more</span>
              )}
            </div>
          )}
        </div>
      </ScrollArea>
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
        notification.status === "unread" && "bg-muted/50",
      )}
      onClick={handleClick}
    >
      <div className="flex justify-between items-start gap-2">
        <p className="text-sm flex-1">{notification.content}</p>
        <time className="text-xs text-muted-foreground whitespace-nowrap">
          {formatDate(notification.createdAt)}
        </time>
      </div>
      <div className="flex gap-1">
        <Badge variant="outline" className="text-xs">
          {notification.notificationType}
        </Badge>
        {notification.status === "unread" && (
          <Badge variant="secondary" className="text-xs text-red-500">
            New
          </Badge>
        )}
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
