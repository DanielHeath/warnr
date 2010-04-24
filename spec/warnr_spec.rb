require 'spec/spec_helper'

describe Client do

  before do
    @client = Client.new
    @user = User.create
  end

  it "should return true from save when valid and warning free" do
    @client.manager = @user
    @client.abn = '123'
    Client.should_not_receive(:callback)
    @client.save.should eql(true)
  end
  
  describe "when the record is invalid" do
    def self.no_callback_save_false
      it "should not recieve a callback when saved" do
        Client.should_not_receive(:callback)
        @client.save
      end
      it "should return false from save" do
        @client.save.should eql(false)
      end
    end
    describe "when the record has warnings" do
      no_callback_save_false
    end
    describe "when the record has no warnings" do
      before do
        @client.abn = '1234'
      end
      no_callback_save_false
    end
  end
  
  it "should be marked to only warn when errors exist on 'abn'" do
    Client.warnr_warning_fields.should eql([:abn])
  end
  
  it "should have a callback recorded" do
    Client._on_save_with_warnings_callbacks.length.should eql(1)
  end

  describe "when only warnings have been violated" do
    before do
      @client.manager = @user
    end
    it "should return true for valid?" do
      @client.valid?.should eql(true)
    end
    describe "after calling valid?" do
      before do
        @client.valid?
      end
      it "should contain a warning" do
        @client.warnings.empty?.should eql(false)
      end
      it "should not contain an error" do
        @client.errors.empty?.should eql(true)
      end
    end
    it "should be valid" do
      @client.valid?.should eql(true)
    end
    it "should return true when saved" do
      @client.save.should eql(true)
    end
    it "should run a callback when you save it" do
      @client.should_receive(:handle_warnings).once
      @client.save
    end
  end
end

