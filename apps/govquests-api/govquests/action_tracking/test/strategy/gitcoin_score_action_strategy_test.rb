# govquests/action_tracking/test/strategy/gitcoin_score_action_strategy_test.rb

require_relative "../test_helper"
require "minitest/mock"

module ActionTracking
  class GitcoinScoreActionStrategyTest < Test
    def setup
      super
      @strategy = GitcoinScoreActionStrategy.new
      @api_mock = Minitest::Mock.new
      @strategy.instance_variable_set(:@api, @api_mock)
    end

    def test_action_type
      assert_equal "gitcoin_score", @strategy.send(:action_type)
    end

    def test_description
      assert_equal "Complete Gitcoin Passport verification", @strategy.send(:description)
    end

    def test_action_data
      assert_equal({min_score: 20}, @strategy.send(:action_data, {}))
      assert_equal({min_score: 30}, @strategy.send(:action_data, {min_score: 30}))
    end

    def test_start_execution
      @api_mock.expect :get_signing_message, {"nonce" => "test_nonce", "message" => "test_message"}

      result = @strategy.start_execution({})

      assert_equal({
        state: "message_requested",
        nonce: "test_nonce",
        message: "test_message"
      }, result)

      @api_mock.verify
    end

    def test_complete_execution_success
      @api_mock.expect :submit_passport, {"score" => 25}, ["0x123", "signature", "nonce"]

      result = @strategy.complete_execution({
        address: "0x123",
        signature: "signature",
        nonce: "nonce"
      })

      assert_equal({
        status: "completed",
        state: "done",
        score: 25,
        message: "Gitcoin Passport verified successfully"
      }, result)

      @api_mock.verify
    end

    def test_complete_execution_failure
      @api_mock.expect :submit_passport, {"score" => 15}, ["0x123", "signature", "nonce"]

      result = @strategy.complete_execution({
        address: "0x123",
        signature: "signature",
        nonce: "nonce"
      })

      assert_equal({
        status: "failed",
        state: "done",
        score: 15,
        message: "Gitcoin Passport score too low"
      }, result)

      @api_mock.verify
    end

    def test_verify_completion
      assert @strategy.send(:verify_completion, {score: 25})
      refute @strategy.send(:verify_completion, {score: 15})
    end
  end
end
