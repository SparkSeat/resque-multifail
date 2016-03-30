module Resque
  module Failure
    class Multifail < Redis
      def save
        Resque.redis.sadd(:multifail_jobs, hash_key)
        Resque.redis.hset(hash_key, :failures, job_failures + 1)

        Resque::Logging.warn("#{hash_key} has now failed #{job_failures} times")

        super if job_failures > allowed_failures
      end

      def hash_key
        Multifail.hash_key(payload)
      end

      def job_failures
        Multifail.job_failures(payload)
      end

      def self.clear(*args)
        Resque.redis.smembers(:multifail_jobs).each do |hash_key|
          Resque.redis.del(hash_key)
        end

        super
      end

      def self.clear_failures(payload)
        Resque.redis.del(hash_key(payload))
      end

      def self.job_failures(payload)
        hash_key = Multifail.hash_key(payload)
        Resque.redis.hget(hash_key, :failures).to_i || 0
      end

      def self.hash_key(payload)
        klass = payload['class']
        args  = payload['args']

        args.join('-') if args

        "#{klass}-#{args}"
      end

      private

      def allowed_failures
        klass = payload['class']
        klass = klass.safe_constantize if klass.is_a? String
        klass.instance_variable_get('@allow_failures') || 0
      end
    end
  end
end
