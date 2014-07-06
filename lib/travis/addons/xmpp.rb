module Travis
  module Addons
    module Xmpp
      require 'travis/addons/xmpp/instruments'
      require 'travis/addons/xmpp/event_handler'

      class Task < ::Travis::Task; end
    end
  end
end
