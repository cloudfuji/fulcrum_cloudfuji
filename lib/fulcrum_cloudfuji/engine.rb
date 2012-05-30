module Fulcrum
  module Cloudfuji
    class Engine < Rails::Engine
      config.before_initialize do
        # Register observers to fire Cloudfuji events
        config.active_record.observers = [(config.active_record.observers || [])].flatten
        config.active_record.observers << :cloudfuji_story_observer
      end

      config.to_prepare do
        ::Fulcrum::Application.class_eval do
          # Add migrations from engine to main migrations
          config.paths['db/migrate'] += Fulcrum::Cloudfuji::Engine.paths['db/migrate'].existent
        end
      end
    end
  end
end

# Override engine view paths so that this gem's views can override application views
Rails::Engine.initializers.detect{|i| i.name == :add_view_paths }.
  instance_variable_set("@block", Proc.new {
    views = paths["app/views"].to_a
    unless views.empty?
      ActiveSupport.on_load(:action_controller){ append_view_path(views) }
      ActiveSupport.on_load(:action_mailer){ append_view_path(views) }
    end
  }
)
