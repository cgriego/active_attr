require "active_attr/logger"

module ActiveAttr
  # @private
  class Railtie < Rails::Railtie
    initializer "active_attr.logger" do
      Logger.logger ||= ::Rails.logger
    end
  end
end
