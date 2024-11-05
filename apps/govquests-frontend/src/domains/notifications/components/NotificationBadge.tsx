import { Badge } from "@/components/ui/badge";
import { useUnreadCount } from "../hooks/useNotifications";

export const NotificationBadge = () => {
  const { data: unreadCount } = useUnreadCount();

  if (!unreadCount) return null;

  return (
    <Badge
      variant="destructive"
      className="flex items-center justify-center w-5 h-5 rounded-full text-xs"
    >
      {unreadCount > 99 ? "99+" : unreadCount}
    </Badge>
  );
};
