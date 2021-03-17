require "split/helper"

module Split
  module CounterHelper
    def ab_counter_inc(counter_name, experiment, alternative)
      begin
        Split::Counters.inc(counter_name, experiment, alternative)
      rescue => e
        raise(e) unless Split.configuration.db_failover
      end
    end
  end

  module Counters
    def self.hash_name_for_name(in_name)
      "co:#{in_name}"
    end

    def self.keyname_for_experiment_and_alternative(experiment, alternative)
      [experiment.gsub(":", ""), alternative.gsub(":", "")].join(':')
    end

    def self.inc(name, experiment, alternative)
      Split.redis.sadd(:counters, name)
      Split.redis.hincrby(Split::Counters.hash_name_for_name(name), Split::Counters.keyname_for_experiment_and_alternative(experiment, alternative), 1)
    end

    def self.current_value(name, experiment, alternative)
      Split.redis.hget(Split::Counters.hash_name_for_name(name), Split::Counters.keyname_for_experiment_and_alternative(experiment, alternative))
    end

    def self.exists?(name)
      Split.redis.exists(Split::Counters.hash_name_for_name(name))
    end

    def self.delete(name)
      Split.redis.srem(:counters, name)
      Split.redis.del(Split::Counters.hash_name_for_name(name))
    end

    def self.reset(name, experiment, alternative)
      Split.redis.hdel(Split::Counters.hash_name_for_name(name), Split::Counters.keyname_for_experiment_and_alternative(experiment, alternative))
    end

    def self.all_values_hash(name)
      return_hash = {}
      result_hash = Split.redis.hgetall(self.hash_name_for_name(name))  # {"exp1:alt1"=>"1", "exp1:alt2"=>"2", "exp2:alt1"=>"1", "exp2:alt2"=>"2"}
      result_hash.each do |key, value| 
        experiment, alternative = key.split(":")
        return_hash[experiment] ||= Hash.new
        return_hash[experiment].merge!({ alternative => value.to_i })
      end
      return_hash
    end

    def self.all_counter_names
      Split.redis.smembers(:counters)
    end
  end
end

module Split::Helper
  include Split::CounterHelper
end

if defined?(Rails)
  ActiveSupport.on_load(:action_controller_base) do
    class ActionController::Base
      ActionController::Base.send :include, Split::CounterHelper
      ActionController::Base.helper Split::CounterHelper
    end
  end
end
