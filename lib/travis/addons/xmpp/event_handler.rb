module Travis
  module Addons
    module Xmpp
      # Publishes a build notification to XMPP rooms or users as defined in the
      # configuration (`.travis.yml`).
      #
      # XMPP credentials are encrypted using the repository's ssl key.
      class EventHandler < Event::Handler
        API_VERSION = 'v2'

        EVENTS = /build:finished/

        def handle?
          !pull_request? && targets.present? && config.send_on_finished_for?(:xmpp)
        end

        def handle
          Travis::Addons::XMPP::Task.run(:xmpp, payload, targets: targets)
        end

        def targets
          @targets ||= {
            rooms: config.notification_values(:xmpp, :rooms),
            users: config.notification_values(:xmpp, :users)
          }
        end

        Instruments::EventHandler.attach_to(self)
      end
    end
  end
end
