module ActionTracking
  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnActionCreated, to: [ActionTracking::ActionCreated])
      event_store.subscribe(OnActionExecutionStarted, to: [ActionTracking::ActionExecutionStarted])
      event_store.subscribe(OnActionExecutionCompleted, to: [ActionTracking::ActionExecutionCompleted])
      event_store.subscribe(OnActionUpdated, to: [ActionTracking::ActionUpdated])
    end
  end
end
