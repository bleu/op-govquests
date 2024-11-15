import { NotificationStrategyProps } from "./NotificationStrategy";

export const DefaultStrategy = (props: NotificationStrategyProps) => {
  const { notification } = props;

  const handleToast = () => {
    console.log(
      `Unhandled notification type: ${notification.notificationType}`,
    );
  };

  return { handleToast };
};
