import { useUnreadCount } from "../hooks/useNotifications";

export const NotificationBadge = () => {
  const { data: unreadCount } = useUnreadCount();

  if (!unreadCount) return null;

  return (
    <div className="inline-flex items-center justify-center w-6 h-6 text-xs text-white bg-red-500 rounded-full">
      {unreadCount}
    </div>
  );
};
