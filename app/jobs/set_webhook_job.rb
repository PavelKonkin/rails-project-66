# frozen_string_literal: true

class SetWebhookJob < ApplicationJob
  queue_as :default

  def perform(**args)
    ApplicationContainer[:octokit_api].set_webhook(args[:user], args[:repository])
  end
end
