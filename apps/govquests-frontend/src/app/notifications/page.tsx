"use client";

import { NotificationsList } from "@/domains/notifications/components/NotificationList";

export default function NotificationsPage() {
  return (
    <div className="max-w-2xl mx-auto p-4">
      <h1 className="text-2xl font-bold mb-4">Notifications</h1>
      <NotificationsList />
    </div>
  );
}
