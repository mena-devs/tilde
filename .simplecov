require "simplecov"
SimpleCov.start("rails") do
  add_filter("/bin/")
  add_filter("/lib/tasks/auto_annotate_models.rake")
  add_filter("/lib/tasks/coverage.rake")
end
# TODO: Change line below to 90
SimpleCov.minimum_coverage(50)
