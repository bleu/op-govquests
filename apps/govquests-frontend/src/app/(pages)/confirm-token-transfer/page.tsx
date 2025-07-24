"use client";
import { Button } from "@/components/ui/Button";
import { Input } from "@/components/ui/Input";
import { Badge } from "@/components/ui/badge";
import { useConfirmTokenTransfer } from "@/domains/gamification/hooks/useConfirmTokenTransfer";
import { useIsAdmin } from "@/domains/authentication/hooks";
import { useSearchParams } from "next/navigation";
import { useState } from "react";
import { toast } from "@/hooks/use-toast";
import { useRouter } from "next/navigation";
import { useRewardIssuance } from "@/domains/gamification/hooks/useRewardIssuance";

export default function ConfirmTokenTransferPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const poolId = searchParams.get("pool-id");
  const userId = searchParams.get("user-id");
  const { isAdmin, isLoading, isError } = useIsAdmin();

  const [transactionHash, setTransactionHash] = useState("");

  const { data: rewardIssuanceData } = useRewardIssuance(poolId, userId);

  const { mutate: confirmTokenTransfer } = useConfirmTokenTransfer(
    userId,
    poolId,
    transactionHash,
  );

  const handleConfirm = () => {
    if (!transactionHash.trim()) {
      toast({
        title: "Transaction hash is required",
        variant: "destructive",
      });
      return;
    }
    confirmTokenTransfer();
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-lg">Loading...</div>
      </div>
    );
  }

  if (isError) {
    toast({
      title: "Error loading user",
      variant: "destructive",
    });
    router.push("/");
    return null;
  }

  if (!isAdmin && !isLoading && !isError) {
    toast({
      title: "You are not authorized to access this page",
      variant: "destructive",
    });
    router.push("/");
    return null;
  }

  if (!rewardIssuanceData?.rewardIssuance) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-lg">Loading reward issuance...</div>
      </div>
    );
  }

  const { pool, user } = rewardIssuanceData.rewardIssuance;
  const rewardDefinition = pool?.rewardDefinition;
  const rewardableData =
    pool?.rewardable?.__typename === "SpecialBadge"
      ? pool.rewardable.displayData
      : null;

  const tokenAmount = rewardDefinition?.amount || 0;
  const tokenSymbol = "OP";
  const issuedAt = rewardIssuanceData.rewardIssuance.issuedAt as string;
  const confirmedAt = rewardIssuanceData.rewardIssuance.confirmedAt as
    | string
    | null;
  const isAlreadyConfirmed = !!confirmedAt;

  if (isAlreadyConfirmed) {
    return (
      <div className="container mx-auto max-w-2xl px-4 py-8">
        <div className="space-y-6">
          {/* Header */}
          <div className="text-center space-y-2">
            <h1 className="text-3xl font-bold">✅ Transfer Confirmed</h1>
            <p className="text-muted-foreground">
              This token transfer has already been confirmed
            </p>
          </div>

          {/* Confirmation Details */}
          <div className="bg-background/70 border rounded-lg p-6">
            <div className="flex items-center gap-2 mb-4">
              <span className="text-xl">#</span>
              <h2 className="text-xl font-semibold">Transfer Information</h2>
            </div>

            <div className="space-y-3 text-sm">
              <div className="flex justify-between">
                <span className="text-muted-foreground">Recipient:</span>
                <span className="font-mono break-all">
                  {user?.address || userId}
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-muted-foreground">Amount:</span>
                <div className="flex items-center gap-1">
                  <span className="font-bold">{tokenAmount}</span>
                  <Badge variant="secondary">{tokenSymbol}</Badge>
                </div>
              </div>
              <div className="flex justify-between">
                <span className="text-muted-foreground">Issued:</span>
                <span>{new Date(issuedAt).toLocaleString()}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-muted-foreground">Confirmed:</span>
                <span>
                  {confirmedAt
                    ? new Date(confirmedAt).toLocaleString()
                    : "Not confirmed"}
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-muted-foreground">Transaction Hash:</span>
                <span className="font-mono break-all">
                  {
                    rewardIssuanceData.rewardIssuance.claimMetadata[
                      "transaction_hash"
                    ]
                  }
                </span>
              </div>
            </div>
          </div>

          {/* Badge Information */}
          {rewardableData && (
            <div className="bg-background/70 border rounded-lg p-6">
              <div className="flex items-center gap-2 mb-2">
                <span className="text-xl">#</span>
                <h2 className="text-xl font-semibold">Badge Information</h2>
              </div>
              <p className="text-muted-foreground mb-4">
                Details about the earned badge
              </p>

              <div className="space-y-3">
                <div>
                  <h3 className="font-semibold text-lg">
                    {rewardableData.title}
                  </h3>
                  {rewardableData.description && (
                    <p className="text-muted-foreground mt-1">
                      {rewardableData.description}
                    </p>
                  )}
                </div>

                {rewardableData.imageUrl && (
                  <div className="flex justify-center">
                    <img
                      src={rewardableData.imageUrl}
                      alt={rewardableData.title}
                      className="w-24 h-24 object-contain rounded-lg"
                    />
                  </div>
                )}
              </div>
            </div>
          )}
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto max-w-2xl px-4 py-8">
      <div className="space-y-6">
        {/* Header */}
        <div className="text-center space-y-2">
          <h1 className="text-3xl font-bold">Confirm Token Transfer</h1>
          <p className="text-muted-foreground">
            Review the transfer details and enter the transaction hash to
            confirm
          </p>
        </div>

        {/* Transfer Details Card */}
        <div className="bg-background/70 border rounded-lg p-6">
          <div className="flex items-center gap-2 mb-2">
            <span className="text-xl">#</span>
            <h2 className="text-xl font-semibold">Transfer Details</h2>
          </div>
          <p className="text-muted-foreground mb-4">
            Token reward transfer information
          </p>

          <div className="space-y-4">
            {/* User Address */}
            <div className="flex flex-col space-y-1">
              <label className="text-sm font-medium text-muted-foreground">
                Recipient Address
              </label>
              <div className="p-3 bg-muted rounded-md font-mono text-sm break-all">
                {user?.address || userId}
              </div>
            </div>

            {/* Token Amount */}
            <div className="flex flex-col space-y-1">
              <label className="text-sm font-medium text-muted-foreground">
                Token Amount
              </label>
              <div className="flex items-center gap-2">
                <span className="text-2xl font-bold">{tokenAmount}</span>
                <Badge variant="secondary">{tokenSymbol}</Badge>
              </div>
            </div>

            {/* Issued Date */}
            <div className="flex flex-col space-y-1">
              <label className="text-sm font-medium text-muted-foreground">
                Issued Date
              </label>
              <div className="p-2 bg-muted rounded-md text-sm">
                {new Date(issuedAt).toLocaleString()}
              </div>
            </div>

            {/* Pool ID */}
            <div className="flex flex-col space-y-1">
              <label className="text-sm font-medium text-muted-foreground">
                Pool ID
              </label>
              <div className="p-2 bg-muted rounded-md font-mono text-xs break-all">
                {poolId}
              </div>
            </div>
          </div>
        </div>

        {/* Badge/Reward Information */}
        {rewardableData && (
          <div className="bg-background/70 border rounded-lg p-6">
            <div className="flex items-center gap-2 mb-2">
              <span className="text-xl">#</span>
              <h2 className="text-xl font-semibold">Badge Information</h2>
            </div>
            <p className="text-muted-foreground mb-4">
              Details about the earned badge
            </p>

            <div className="space-y-3">
              <div>
                <h3 className="font-semibold text-lg">
                  {rewardableData.title}
                </h3>
                {rewardableData.description && (
                  <p className="text-muted-foreground mt-1">
                    {rewardableData.description}
                  </p>
                )}
              </div>

              {rewardableData.imageUrl && (
                <div className="flex justify-center">
                  <img
                    src={rewardableData.imageUrl}
                    alt={rewardableData.title}
                    className="w-24 h-24 object-contain rounded-lg"
                  />
                </div>
              )}
            </div>
          </div>
        )}

        {/* Transaction Hash Input */}
        <div className="bg-background/70 border rounded-lg p-6">
          <div className="flex items-center gap-2 mb-2">
            <span className="text-xl">#</span>
            <h2 className="text-xl font-semibold">Transaction Confirmation</h2>
          </div>
          <p className="text-muted-foreground mb-4">
            Enter the blockchain transaction hash to confirm the transfer
          </p>

          <div className="space-y-4">
            <div className="space-y-2">
              <label htmlFor="txHash" className="text-sm font-medium">
                Transaction Hash
              </label>
              <Input
                id="txHash"
                type="text"
                placeholder="0x..."
                value={transactionHash}
                onChange={(e) => setTransactionHash(e.target.value)}
                className="font-mono text-black"
              />
            </div>

            <Button
              onClick={handleConfirm}
              className="w-full"
              disabled={!transactionHash.trim()}
            >
              Confirm Transfer
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
