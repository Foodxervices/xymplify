namespace :permissions do
  task :setup => :environment do
    Permission.write("all", "manage", "Everything", "All operations")

    controllers = Dir.new("#{Rails.root}/app/controllers").entries
    controllers.each do |controller|
      if controller =~ /_controller/
        foo_bar = controller.camelize.gsub(".rb","").constantize.new
      end
    end
    # You can change ApplicationController for a super-class used by your restricted controllers
    ApplicationController.subclasses.each do |controller|
      if controller.respond_to?(:permission)  
        clazz = controller.permission
        action_name = I18n.t("actions.#{controller.controller_name}.manage", default: "#{controller.controller_name.classify} :: Manage")
        Permission.write(clazz, "manage", action_name, "All operations")
        controller.action_methods.each do |action|
          if action.to_s.index("_callback").nil?
            action_desc, cancan_action = Permission.eval_cancan_action(action)
            action_name = I18n.t("actions.#{controller.controller_name}.#{cancan_action}", default: "#{controller.controller_name.classify} :: #{cancan_action.humanize}")
            Permission.write(clazz, cancan_action, action_name, action_desc)
          end
        end
      end
    end
  end
end