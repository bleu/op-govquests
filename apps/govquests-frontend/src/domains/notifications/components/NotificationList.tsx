import {
  useNotifications,
  useMarkNotificationAsRead,
} from "../hooks/useNotifications";
import { Fragment } from "react";

export const NotificationsList = () => {
  const { data, fetchNextPage, hasNextPage, isFetchingNextPage, status } =
    useNotifications();

  const { mutate: markAsRead } = useMarkNotificationAsRead();

  if (status === "pending") return <div>Loading...</div>;
  if (status === "error") return <div>Error loading notifications</div>;

  return (
    <div className="space-y-4">
      {data.pages.map((page, i) => (
        <Fragment key={i}>
          {page.notifications.edges?.map((value) => {
            if (!value?.node) return null;
            const { node: notification } = value;

            return (
              <div
                key={notification.id}
                className="p-4 bg-white rounded-lg shadow"
              >
                <div className="flex justify-between items-start">
                  <div>
                    <p className="font-medium">{notification.content}</p>
                    <p className="text-sm text-gray-500">
                      {new Date(notification.createdAt).toLocaleDateString()}
                    </p>
                  </div>
                  {notification.status !== "read" && (
                    <button
                      onClick={() => markAsRead(notification.id)}
                      className="text-sm text-blue-500 hover:text-blue-700"
                    >
                      Mark as read
                    </button>
                  )}
                </div>
                <div className="mt-2 space-y-1">
                  {notification.deliveries.map((delivery, index) => (
                    <div key={index} className="text-sm text-gray-600">
                      {delivery.deliveryMethod}: {delivery.status}
                      {delivery.deliveredAt &&
                        ` (${new Date(delivery.deliveredAt).toLocaleTimeString()})`}
                    </div>
                  ))}
                </div>
              </div>
            );
          })}
        </Fragment>
      ))}

      {hasNextPage && (
        <button
          onClick={() => fetchNextPage()}
          disabled={isFetchingNextPage}
          className="w-full p-2 text-center text-blue-500 hover:text-blue-700"
        >
          {isFetchingNextPage ? "Loading more..." : "Load more"}
        </button>
      )}
    </div>
  );
};
