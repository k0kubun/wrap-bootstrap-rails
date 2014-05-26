require "wrap/bootstrap/rails/version"
require "unindent"

class Wrap::Bootstrap::Rails
  FG_RED = 31

  def initialize(target_dir, gem_name)
    @wrap_dir = File.expand_path(target_dir)
    @gem_name = gem_name
  end

  def create_gem!
    check_gem_dir_existence
    check_bundler_existence

    system("bundle", "gem", gem_name)
    enginize_gem
    add_railtie_dependency
  end

  private

  # Define Rails::Engine to export vendor/assets directory to rails app.
  def enginize_gem
    source = <<-EOS.unindent
      require "#{gem_name}/version"

      module #{gem_name.capitalize}
        module Rails
          class Engine < ::Rails::Engine
          end
        end
      end
    EOS

    gem_path = File.join(gem_dir, "lib", "#{gem_name}.rb")
    File.write(gem_path, source)
  end

  def add_railtie_dependency
    gemspec_path = File.join(gem_dir, "#{gem_name}.gemspec")

    lines = File.read(gemspec_path).split("\n")
    lines.insert(-2, "  spec.add_dependency 'railties', '~> 3.1'")
    File.write(gemspec_path, lines.join("\n"))
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

  def gem_name
    @gem_name
  end

  def gem_dir
    @gem_dir ||= File.join(File.expand_path("."), gem_name)
  end
end
