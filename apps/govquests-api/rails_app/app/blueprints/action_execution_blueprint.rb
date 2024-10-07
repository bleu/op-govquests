# {
#     "data": {
#         "id": 2,
#         "execution_id": "46b0fe20-dabc-45dd-bfc1-5e0f56d627e2",
#         "action_id": "54d24d70-1c89-4a0a-88ad-e24a1926a2f3",
#         "user_id": "1da1cdab-a037-4d92-8625-717c5fad9f35",
#         "started_at": "2024-10-07T19:11:40.356Z",
#         "status": "started",
#         "created_at": "2024-10-07T19:11:40.402Z",
#         "updated_at": "2024-10-07T19:11:40.402Z",
#         "action_type": "gitcoin_score",
#         "result": null,
#         "completed_at": null,
#         "nonce": "20f961d38281f14381a06dc9b69080f7",
#         "start_data": {
#             "step": 0,
#             "nonce": "e8274b89c180a97dfb7268468484410b82572b0690fefd309d3131d8ab03",
#             "state": "started",
#             "message": "I hereby agree to submit my address in order to score my associated Gitcoin Passport from Ceramic.\n\nNonce: e8274b89c180a97dfb7268468484410b82572b0690fefd309d3131d8ab03\n",
#             "stepCount": 1
#         },
#         "completion_data": {}
#     },
#     "nonce": "20f961d38281f14381a06dc9b69080f7",
#     "execution_id": "46b0fe20-dabc-45dd-bfc1-5e0f56d627e2",
#     "expires_at": "2024-10-07T19:41:40.356Z"
# }
class ActionExecutionBlueprint < Blueprinter::Base
  fields :execution_id, :start_data, :nonce, :completion_data, :action_type

  identifier :execution_id
end
