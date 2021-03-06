require 'spec_helper'

describe Travis::Addons::Hipchat::Instruments::Task do
  include Travis::Testing::Stubs

  let(:subject)   { Travis::Addons::Hipchat::Task }
  let(:payload)   { Travis::Api.data(build, for: 'event', version: 'v0') }
  let(:task)      { subject.new(payload, targets: %w(token@room)) }
  let(:publisher) { Travis::Notification::Publisher::Memory.new }
  let(:event)     { publisher.events[1] }

  before :each do
    Travis::Notification.publishers.replace([publisher])
    task.stubs(:process)
    task.run
  end

  it 'publishes a event' do
    event.should publish_instrumentation_event(
      event: 'travis.addons.hipchat.task.run:completed',
      message: 'Travis::Addons::Hipchat::Task#run:completed for #<Build id=1>',
    )
    event[:data].except(:payload).should == {
      repository: 'svenfuchs/minimal',
      object_id: 1,
      object_type: 'Build',
      targets: %w(token@room),
      message: [
        'svenfuchs/minimal#2 (master - 62aae5f : Sven Fuchs): the build has passed',
        'Change view: https://github.com/svenfuchs/minimal/compare/master...develop',
        'Build details: http://travis-ci.org/svenfuchs/minimal/builds/1'
      ]
    }
    event[:data][:payload].should_not be_nil
  end
end
