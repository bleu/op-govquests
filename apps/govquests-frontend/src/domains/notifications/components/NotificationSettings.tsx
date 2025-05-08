import { Button } from "@/components/ui/Button";
import { ConditionalWrapper } from "@/components/ui/ConditionalWrapper";
import { Switch } from "@/components/ui/switch";
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/components/ui/tooltip";
import { useNotificationPreferences } from "../hooks/useNotificationPreferences";
import {
  useIsTelegramConnected,
  useTelegramConnect,
} from "../hooks/useTelegramConnect";
import { useUpdateNotificationPreferences } from "../hooks/useUpdateNotificationPreferences";
import { useCurrentUser } from "@/domains/authentication/hooks";
import Link from "next/link";

export const NotificationSettings = () => {
  return (
    <div className="flex flex-col gap-8 mb-2">
      <TelegramNotificationSettings />
      <EmailNotificationSettings />
    </div>
  );
};

const TelegramNotificationSettings = () => {
  const { data: notificationPreferences } = useNotificationPreferences();

  const { data: isTelegramConnected } = useIsTelegramConnected();
  const { mutateAsync: awaitConnectTelegram } = useTelegramConnect();
  const { mutate: updateNotificationPreferences } =
    useUpdateNotificationPreferences();

  const toggleTelegramNotification = (value: boolean) => {
    updateNotificationPreferences({
      telegramNotifications: value,
    });
  };

  const handleTelegramConnection = async () => {
    const { connectTelegram } = await awaitConnectTelegram();

    if (connectTelegram.linkToChat) {
      window.open(connectTelegram.linkToChat, "_blank");
    }
  };

  return (
    <div className="flex flex-col gap-4 transition-all duration-300">
      <div className="flex flex-col gap-2">
        <div className="flex justify-between items-center">
          <p className="font-bold">Connect Telegram</p>
          <ConditionalWrapper
            condition={!isTelegramConnected}
            wrapper={(children) => (
              <TooltipProvider>
                <Tooltip>
                  <TooltipTrigger>{children}</TooltipTrigger>
                  <TooltipContent>
                    <p>Connect with Telegram first to enable notifications</p>
                  </TooltipContent>
                </Tooltip>
              </TooltipProvider>
            )}
          >
            <Switch
              checked={notificationPreferences?.telegramNotifications}
              onCheckedChange={toggleTelegramNotification}
              disabled={!isTelegramConnected || !notificationPreferences}
            />
          </ConditionalWrapper>
        </div>
        <span className="text-sm">
          Get updates on votes, achievements, and more directly on Telegram.
        </span>
      </div>
      <div className="flex flex-col gap-2">
        <Button
          variant="outline"
          onClick={handleTelegramConnection}
          disabled={isTelegramConnected}
        >
          Connect with Telegram
        </Button>
        {isTelegramConnected && (
          <span className="text-xs font-bold">
            Telegram connected successfully!
          </span>
        )}
      </div>
    </div>
  );
};

const EmailNotificationSettings = () => {
  const { data: notificationPreferences } = useNotificationPreferences();
  const { mutate: updateNotificationPreferences } =
    useUpdateNotificationPreferences();

  const toggleEmailNotification = (value: boolean) => {
    updateNotificationPreferences({
      emailNotifications: value,
    });
  };

  const { data: currentUser } = useCurrentUser();

  const isEmailVerified = !!currentUser?.currentUser?.email;

  return (
    <div className="flex flex-col gap-2">
      <div className="flex justify-between items-center">
        <p className="font-bold">Enable Email Notifications</p>
        <ConditionalWrapper
          condition={!isEmailVerified}
          wrapper={(children) => (
            <TooltipProvider>
              <Tooltip>
                <TooltipTrigger>{children}</TooltipTrigger>
                <TooltipContent>
                  <p>
                    You need to verify your email first to enable email
                    notifications.{" "}
                    <Link
                      href={`${process.env.NEXT_PUBLIC_APP_URL}/quests/unlock-your-profile?actionId=c56e5d13-0fca-5b2a-9b04-12778a77a776`}
                    >
                      Verify your email
                    </Link>
                  </p>
                </TooltipContent>
              </Tooltip>
            </TooltipProvider>
          )}
        >
          <Switch
            checked={notificationPreferences?.emailNotifications}
            onCheckedChange={toggleEmailNotification}
            disabled={!notificationPreferences}
          />
        </ConditionalWrapper>
      </div>
      <span className="text-sm">
        Receive updates on votes, badges, and leaderboard rankings in your
        inbox.
      </span>
    </div>
  );
};
