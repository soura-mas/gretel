module Gretel
  class RouteCrumbsGenerator
    attr_reader :link_text_attr_name

    def self.generate(*args)
      new(*args).generate
    end

    def initialize(link_text_attr_name: 'name')
      @link_text_attr_name = link_text_attr_name
    end

    def generate
      path_to_routes.map do |path, route|
        Builder.new(path, route, path_to_routes, link_text_attr_name).build
      end.join("\n")
    end

    private

      def path_to_routes
        @path_to_routes ||= Rails.application.routes.named_routes.map do |_name, route|
          path = route.path.spec.to_s.gsub(/\(\.:format\)/, '')
          next if path.start_with?('/rails')

          [path, route]
        end.compact.to_h
      end

      class Builder
        attr_reader :path, :route, :path_to_routes, :link_text_attr_name

        def initialize(path, route, path_to_routes, link_text_attr_name)
          @path = path
          @route = route
          @path_to_routes = path_to_routes
          @link_text_attr_name = link_text_attr_name
        end

        def build
          parent_line =
            if parent_route.present?
              "parent :#{[parent_route.name, *Builder.crumb_parts_of(parent_route)].join(', ')}"
            end

          crumb_args, path_args =
            if crumb_parts.present?
              crumb_parts_str = crumb_parts.join(', ')
              [" |#{crumb_parts_str}|", "(#{crumb_parts_str})"]
            end

          <<~RUBY.gsub(/^\s*\n/, '')
            crumb :#{route.name} do#{crumb_args}
              link #{link_text}, #{route.name}_path#{path_args}
              #{parent_line}
            end
          RUBY
        end

        private

          class << self
            # e.g. projects/:project_id/issues/:id => [:project_id, :id] => ['project', 'issue']
            def crumb_parts_of(route)
              route.required_parts.map do |part|
                if part == :id
                  controller_name = route.defaults[:controller].split('/')[-1] # without namespace. e.g. admin/users => users
                  controller_name.singularize
                else
                  part.to_s.gsub(/_id/, '')
                end
              end
            end
          end

          def crumb_parts
            @crumb_parts ||= Builder.crumb_parts_of(route)
          end

          def link_text
            if route.required_parts.include?(:id)
              "#{crumb_parts.last}.#{link_text_attr_name}"
            else
              "t('breadcrumbs.#{route.name}')"
            end
          end

          def parent_route
            return nil if path == '/'

            @parent_route ||=
              begin
                work_parent_path = path
                work_parent_route = nil
                while work_parent_route.nil? && work_parent_path.present?
                  parent_path_parts = work_parent_path.split('/')[0...-1]
                  parent_path_parts[-1] = ':id' if parent_path_parts.last&.match?(/:.+_id/)
                  work_parent_path = parent_path_parts.join('/')
                  work_parent_route = path_to_routes[work_parent_path]
                end
                work_parent_route.presence || path_to_routes['/']
              end
          end
      end
  end
end
