"use client";

import { useToast } from "@/hooks/use-toast";
import {
  Toast,
  ToastClose,
  ToastDescription,
  ToastProvider,
  ToastTitle,
  ToastViewport,
} from "@/components/ui/toast";
import HtmlRender from "./HtmlRender";

export function Toaster() {
  const { toasts } = useToast();

  return (
    <ToastProvider>
      {toasts.map(({ id, title, description, action, ...props }) => (
        <Toast key={id} {...props}>
          <div className="grid gap-1">
            {title && (
              <ToastTitle>
                <HtmlRender content={title} className="text-sm font-semibold" />
              </ToastTitle>
            )}
            {description && (
              <ToastDescription>
                <HtmlRender
                  content={description as string}
                  className="text-sm font-normal opacity-90"
                />
              </ToastDescription>
            )}
          </div>
          {action}
          <ToastClose />
        </Toast>
      ))}
      <ToastViewport />
    </ToastProvider>
  );
}
