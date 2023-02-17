require 'fileutils'
require 'pathname'

APP_ROOT = Pathname.new('mygame').freeze

guard :shell do
  watch(/^[^#]*\.rb/) { |m|
    if run_all?(m)
      run_all
    else
      test_path = m[0].include?('tests/') ? Pathname.new(m[0]) : add_test_directory_to_path(m[0])
      next unless test_path.exist?

      run_dragonruby_tests(test_path)
    end
  }
end

def run_all?(match)
  match.is_a? Array
end

def run_all
  run_dragonruby_tests(APP_ROOT / 'tests/main.rb')
end

def add_test_directory_to_path(path)
  path_from_app_root = Pathname.new(path).relative_path_from(APP_ROOT)
  APP_ROOT / 'tests' / path_from_app_root
end

def run_dragonruby_tests(path)
  envs = 'SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy'
  relative_test_path = Pathname.new(path).relative_path_from(APP_ROOT)
  system "#{envs} ./dragonruby #{APP_ROOT} --test #{relative_test_path}"
end
