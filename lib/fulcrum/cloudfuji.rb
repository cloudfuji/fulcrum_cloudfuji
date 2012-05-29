module Fulcrum
  module Cloudfuji
    class << self
      def enable_cloudfuji!
        load_observers!
        extend_user!
        extend_project!
        disable_devise_for_cloudfuji_controllers!
      end

      def extend_user!
        puts "Extending the User model"
        User.class_eval do
          validates_presence_of   :ido_id
          validates_uniqueness_of :ido_id

          attr_accessible :ido_id

          after_create :add_all_projects!
          before_destroy :remove_all_projects!

          def set_random_password_if_blank
            # Not needed with Cloudfuji authentication
            super unless ::Cloudfuji::Platform.on_cloudfuji?
          end
          alias :set_reset_password_token :set_random_password_if_blank

          def cloudfuji_extra_attributes(extra_attributes)
            self.name  = "#{extra_attributes['first_name'].to_s} #{extra_attributes['last_name'].to_s}"
            if extra_attributes['first_name'] && extra_attributes['last_name']
              self.initials  = "#{extra_attributes['first_name'][0].upcase}#{extra_attributes['last_name'][0].upcase}"
            else
              self.initials  = "#{extra_attributes['email'][0].upcase}#{extra_attributes['email'][1].upcase}"
            end

            self.email = extra_attributes["email"]
          end

          def add_all_projects!
            Project.all.each { |project| project.users << self unless project.users.member?(self) }
          end

          def remove_all_projects!
            Project.all.each { |project| project.users.delete(self) if project.users.member?(self) }
          end

          def active_for_authentication?
            super && active?
          end
        end
      end

      def extend_project!
        puts "Extending the Project model"
        Project.class_eval do
          after_create :add_all_users!

          def add_all_users!
            User.all.each do |user|
              unless self.users.include?(user)
                self.users << user
              end
            end
          end
        end
      end

      def load_observers!
        Dir[File.expand_path("../cloudfuji/event_observers/*.rb", __FILE__)].each { |file| require file }
      end

      # Temporary hack because all routes require authentication in
      # Fulcrum
      def disable_devise_for_cloudfuji_controllers!
        puts "Disabling devise auth protection on cloudfuji controllers"

        ::Cloudfuji::DataController.instance_eval { before_filter :authenticate_user!, :except => [:index]  }
        ::Cloudfuji::EnvsController.instance_eval { before_filter :authenticate_user!, :except => [:update] }
        ::Cloudfuji::MailController.instance_eval { before_filter :authenticate_user!, :except => [:index]  }

        puts "Devise checks disabled for Cloudfuji controllers"
      end
    end
  end
end

if Cloudfuji::Platform.on_cloudfuji?
  class CloudfujiRailtie < Rails::Railtie
    # Enabling it via this hook means that it'll be reloaded on each
    # request in development mode, so you can make changes in here and
    # it'll be immeidately reflected
    config.to_prepare do
      puts "Enabling Cloudfuji"
      Fulcrum::Cloudfuji.enable_cloudfuji!
      puts "Finished enabling Cloudfuji"
    end
  end
end
