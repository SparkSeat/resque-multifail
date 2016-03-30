class ExampleJob
  extend Resque::Plugins::Multifail

  @queue = :test
  @allow_failures = 3

  def self.perform(arg1, arg2)
  end
end
