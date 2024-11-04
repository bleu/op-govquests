from safe_eth.eth import EthereumClient, EthereumNetwork
from safe_eth.safe.api.transaction_service_api import TransactionServiceApi
from safe_eth.safe import Safe
from hexbytes import HexBytes
import os


def main():
    ethereum_client = EthereumClient(os.environ.get("RPC_URL"))

    # Instantiate a Safe
    safe = Safe(os.environ.get("SAFE_ADDRESS"), ethereum_client)

    # Create a Safe transaction
    safe_tx = safe.build_multisig_tx(
        os.environ.get("TO"), os.environ.get("VALUE"), HexBytes("")
    )

    # Sign the transaction with Owner A
    safe_tx.sign(os.environ.get("SYSTEM_PRIVATE_KEY"))

    # Instantiate the Transaction Service API
    transaction_service_api = TransactionServiceApi(
        network=EthereumNetwork.SEPOLIA, ethereum_client=ethereum_client
    )

    # Send the transaction to the Transaction Service with the signature from Owner A
    transaction_service_api.post_transaction(safe_tx)


if __name__ == "__main__":
    main()
