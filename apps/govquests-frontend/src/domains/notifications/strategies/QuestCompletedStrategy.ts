import { NotificationStrategyProps } from "./NotificationStrategy";

export const QuestCompletedStrategy = (props: NotificationStrategyProps) => {
  const { notification, toast } = props;

  const handleToast = () => {
    toast({ title: notification.content });
  };

  return { handleToast };
};
