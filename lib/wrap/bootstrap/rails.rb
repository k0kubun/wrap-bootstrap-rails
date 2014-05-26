require "wrap/bootstrap/rails/version"

module Wrap
  module Bootstrap
    class Rails
      FG_RED = 31

      def initialize(target_dir, gem_name)
        @wrap_dir = File.expand_path(target_dir)
        @gem_name = gem_name
      end

      def create_gem!
        check_gem_dir_existence
        check_bundler_existence

        system("bundle", "gem", gem_name)
      end

      private

      def gem_name
        @gem_name
      end

      def check_gem_dir_existence
        if File.exists?(gem_dir)
          abort_execution("Gem create destination ('#{gem_dir}') already exists.")
        end
      end

      def check_bundler_existence
        if `which bundle`.empty?
          abort_execution("Could not find bundle in your PATH.")
        end
      end

      def abort_execution(message)
        puts "\033[#{FG_RED}m#{message} Aborting.\033[0m"
        exit
      end

      def gem_dir
        @gem_dir ||= File.join(File.expand_path("."), gem_name)
      end
    end
  end
end
