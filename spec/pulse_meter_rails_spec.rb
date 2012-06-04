require 'spec_helper'

describe PulseToolbox do
  let(:redis) {"redis"}

  describe "::redis=" do
    it "should set PulseMeter redis" do
      described_class.redis = redis
      PulseMeter.redis.should == redis
    end
  end

  describe "::redis" do
    it "should retrieve redis" do
      described_class.redis = redis
      described_class.redis.should == redis
    end
  end
end
