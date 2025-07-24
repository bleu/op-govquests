"use client";
import { Suspense } from "react";
import ConfirmTokenTransfer from "@/domains/gamification/components/ConfirmTokenTransfer";

export default function ConfirmTokenTransferPage() {
  return (
    <Suspense
      fallback={
        <div className="flex items-center justify-center min-h-screen">
          <div className="text-lg">Loading...</div>
        </div>
      }
    >
      <ConfirmTokenTransfer />
    </Suspense>
  );
}
