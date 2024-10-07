"use client";
import api from "@/lib/api";
import { useMutation, useQuery } from "@tanstack/react-query";
import { useCallback, useEffect } from "react";
import { useAccount, useSignMessage } from "wagmi";

type ApiSuccessResponse = {
  status: "success";
  data: {
    message: string;
    nonce: string;
  };
};

type ApiErrorResponse = {
  status: "error";
  error: {
    message: string;
  };
};

type ApiResponse = ApiSuccessResponse | ApiErrorResponse;

export default function Page() {
  const query = useQuery({
    queryKey: ["gitcoin_passport_scores"],
    queryFn: async () => {
      return await api<ApiResponse>(
        "/integrations/gitcoin_passport_scores/get_signing_message"
      );
    },
    enabled(query) {
      return !query.state.data;
    },
  });

  const mutation = useMutation({
    mutationFn: async (data: {
      nonce: string;
      address: string;
      signature: string;
    }) => {
      return await api<ApiResponse>(
        "/integrations/gitcoin_passport_scores/submit_passport",
        {
          method: "POST",
          body: JSON.stringify({
            signature: data.signature,
            nonce: data.nonce,
            address: data.address,
          }),
        }
      );
    },
  });

  const callback = useCallback(
    ({ address, signature }: { address: string; signature: string }) => {
      if (!query.data) return;
      if (query.data.status === "error") return;
      if (mutation.isSuccess) return;

      mutation.mutate({
        address,
        signature,
        nonce: query.data.data.nonce,
      });
    },
    [query.data]
  );

  const { signMessage, data: signature } = useSignMessage();
  const { address } = useAccount();

  useEffect(() => {
    if (!signature || !callback || !address) return;

    callback({ address, signature });
  }, [signature, callback]);

  if (query.data?.status === "error") {
    return <div>{query.data.error.message}</div>;
  }

  if (query.isLoading) {
    return <div>Loading...</div>;
  }

  if (query.isError) {
    return <div>{query.error.message}</div>;
  }

  if (!query.data?.data.message) {
    return <div>No message to sign</div>;
  }

  if (mutation.isPending) {
    return <div>Submitting...</div>;
  }

  return (
    <div>
      <div>
        <div>message: {signature}</div>
        <button
          type="button"
          className="p-2 bg-green-200"
          onClick={() => {
            if (!query.data) return;
            if (query.data.status === "error") return;

            signMessage({
              message: query.data.data.message,
            });
          }}
        >
          sign something
        </button>
      </div>
    </div>
  );
}
