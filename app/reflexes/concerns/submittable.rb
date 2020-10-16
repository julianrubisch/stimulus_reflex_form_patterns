module Submittable
  extend ActiveSupport::Concern

  included do
    before_reflex do
      if element.dataset.signed_id.present?
        @resource = GlobalID::Locator.locate_signed(element.dataset.signed_id)
        @resource.assign_attributes(submit_params)
      else
        resource_class = Rails.application.message_verifier("calendar_events")
                              .verify(element.dataset.resource)
                              .safe_constantize
        @resource = resource_class.new(submit_params)
      end
    end
  end

  def submit
    @resource.save

    morph :nothing
  end
end
