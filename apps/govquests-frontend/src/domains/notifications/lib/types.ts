export interface NotificationNode {
  id: string;
  content: string;
  notificationType: string;
  title: string;
}

export interface NotificationEdge {
  node: NotificationNode;
}
