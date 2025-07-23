"use client";
import { Button } from "@/components/ui/Button";
import { Input } from "@/components/ui/Input";
import { useConfirmTokenTransfer } from "@/domains/gamification/hooks/useConfirmTokenTransfer";
import { useIsAdmin } from "@/domains/authentication/hooks";
import { useSearchParams } from "next/navigation";
import { useState } from "react";
import { toast } from "@/hooks/use-toast";
import { useRouter } from "next/navigation";

export default function ConfirmTokenTransferPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const poolId = searchParams.get("pool-id");
  const userId = searchParams.get("user-id");
  const { isAdmin, isLoading, isError } = useIsAdmin();

  const [transactionHash, setTransactionHash] = useState("");

  const { mutate: confirmTokenTransfer } = useConfirmTokenTransfer(
    userId,
    poolId,
    transactionHash,
  );

  const handleConfirm = () => {
    confirmTokenTransfer();
  };

  if (isLoading) {
    return <div>Loading...</div>;
  }

  if (isError) {
    toast({
      title: "Error loading user",
      variant: "destructive",
    });
    router.push("/");
  }

  if (!isAdmin && !isLoading && !isError) {
    toast({
      title: "You are not authorized to access this page",
      variant: "destructive",
    });
    router.push("/");
  }

  return (
    <div className="flex flex-col items-center justify-center gap-2 mt-10">
      <h1>Confirm Token Transfer</h1>
      <p>Pool ID: {poolId}</p>
      <p>User ID: {userId}</p>
      <Input
        type="text"
        placeholder="Enter transaction hash"
        value={transactionHash}
        onChange={(e) => setTransactionHash(e.target.value)}
        className="max-w-sm"
      />
      <Button onClick={handleConfirm}>Confirm</Button>
    </div>
  );
}
