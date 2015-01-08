require 'spec_helper'

describe Split::Counters do
  include Split::Helper

  describe 'basic use' do
    before(:each) do
      Split::Counters.delete('co')
      Split::Counters.delete('co2')
    end

    after(:each) do
      Split::Counters.delete('co')
      Split::Counters.delete('co2')
    end

    it "should create a counter upon using it, if it does not exist" do
      Split::Counters.inc('co', 'exp1', 'alt1')
      Split::Counters.current_value('co', 'exp1', 'alt1').should eq("1")
      Split::Counters.all_counter_names.should include('co')
    end

    it "should create a counter directly upon using it, if it does not exist" do
      Split::Counters.delete('co')
      Split::Counters.inc('co','exp1', 'alt1')
      Split::Counters.current_value('co', 'exp1', 'alt1').should eq("1")
      Split::Counters.exists?('co').should eq(true)
    end

    it "should be possible to delete a counter" do
      Split::Counters.inc('co','exp1', 'alt1')
      Split::Counters.exists?('co').should eq(true)
      Split::Counters.all_counter_names.should include('co')
      Split::Counters.delete('co')
      Split::Counters.exists?('co').should eq(false)
      Split::Counters.all_counter_names.should_not include('co')
    end

    it "should be possible to reset a counter" do
      Split::Counters.delete('co')
      Split::Counters.inc('co','exp1', 'alt1')
      Split::Counters.current_value('co', 'exp1', 'alt1').should eq("1")
      Split::Counters.reset('co', 'exp1', 'alt1')
      Split::Counters.inc('co','exp1', 'alt1')
      Split::Counters.current_value('co', 'exp1', 'alt1').should eq("1")
    end

    it "should be possible to get all experiments and hashs counter values" do
      Split::Counters.delete('co')
      Split::Counters.inc('co', 'exp1', 'alt1')
      Split::Counters.inc('co', 'exp1', 'alt2')
      Split::Counters.inc('co', 'exp1', 'alt2')
      Split::Counters.inc('co', 'exp2', 'alt1')
      # {"exp1"=>{"alt1"=>1, "alt2"=>2}, "exp2"=>{"alt1"=>1}}
      Split::Counters.all_values_hash('co').length.should eq(2)
      Split::Counters.all_values_hash('co')['exp1'].length.should eq(2)
      Split::Counters.all_values_hash('co')['exp2'].length.should eq(1)
    end

    it "should be possible to get a list of all counters" do
      Split::Counters.delete('co')
      Split::Counters.inc('co', 'exp1', 'alt1')
      Split::Counters.inc('co2','exp2', 'alt1')
      Split::Counters.all_counter_names.length.should eq(2)
    end
  end
end
