export interface NotificationNode {
  id: string;
  content: string;
  notificationType: string;
}

export interface NotificationEdge {
  node: NotificationNode;
}
