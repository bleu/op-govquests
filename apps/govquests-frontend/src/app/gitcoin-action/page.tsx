"use client";

import { useSignMessage } from "wagmi";

export default function Page() {
  const { signMessage, data } = useSignMessage();

  return (
    <div>
      <div>message: {data}</div>
      <button
        type="button"
        className="p-2 bg-green-200"
        onClick={() =>
          signMessage({
            message:
              "I hereby agree to submit my address in order to score my associated Gitcoin Passport from Ceramic.\n\nNonce: 67b693988b738431b0f2f8abce8b466442c5381a5e8196978135bd141ebb\n",
          })
        }
      >
        sign something
      </button>
    </div>
  );
}
