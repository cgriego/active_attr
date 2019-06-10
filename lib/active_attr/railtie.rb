require "active_attr/attributes"
require "active_attr/logger"

module ActiveAttr
  # @private
  class Railtie < Rails::Railtie
    initializer "active_attr.logger" do
      Logger.logger ||= ::Rails.logger
    end

    initializer "active_attr.attributes" do
      Attributes.filter_attributes += Rails.application.config.filter_parameters
    end
  end
end
