module Submittable
  extend ActiveSupport::Concern

  included do
    before_reflex do
      resource_class = Rails.application.message_verifier("calendar_events")
                            .verify(element.dataset.resource)
                            .safe_constantize
      @resource = resource_class.new(submit_params)
    end
  end

  def submit
    @resource.save

    morph :nothing
  end
end
