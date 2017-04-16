module CanStrap
  module Boot
    class << self
      def bootstrap
        Object.const_set(:Ability, abilty_klass)
      end

      private

      def abilty_klass
        Class.new do
          include CanCan::Ability

          def initialize(user)
            return unless user.present?

            # Apply roles
            user.roles.pluck(:name).each do |role|
              instance_exec(user, &"CanStrap::Abilities::#{role.camelize}"
                .safe_constantize.try(:permissions)
              )
            end 
          end
        end
      end
    end
  end
end