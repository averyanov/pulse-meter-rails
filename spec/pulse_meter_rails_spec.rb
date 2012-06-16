require 'spec_helper'

describe PulseToolbox do
  let(:redis) {Redis.new}

  describe ".redis=" do
    it "sets PulseMeter redis" do
      described_class.redis = redis
      PulseMeter.redis.should == redis
    end
  end

  describe ".redis" do
    before do
      described_class.redis = redis
    end

    it "retrieves redis" do
      described_class.redis.should == redis
    end

    it "reconnects redis client when pid changes" do
      old_object_id = described_class.redis.object_id
      Process.stub(:pid).and_return(1)
      described_class.redis.object_id.should_not == old_object_id
    end
  end

  describe ".pid_changed" do
    context "when pid is unchanged" do
      it "returns false" do
        described_class.pid_changed.should be_false
      end
    end

    context "when pid changes" do
      before do
        described_class.redis = redis
        Process.stub(:pid).and_return(1)
      end

      it "returns true" do
        described_class.pid_changed.should be_true
      end
    end
  end

  describe ".reconnect" do
    before do
      described_class.redis = Redis.new :db => 2
    end

    it "recreates redis client" do
      expect {described_class.reconnect}.to change {described_class.redis.object_id}
    end

    it "recreates redis client with same connection options" do
      expect {described_class.reconnect}.not_to change {described_class.redis.client.id}
    end
  end
end
