#!/bin/sh

# regexp?
# the whole file ?

fullpath="/opt/mmonit/conf"

MMONIT_PORT=${MMONIT_PORT:-8080}
MMONIT_DOMAIN=${MMONIT_DOMAIN:-"your.domain.com"}
MMONIT_URL=${MMONIT_URL:-"https://$MMONIT_DOMAIN"}
MMONIT_DATABASE_URL=${MMONIT_DATABASE_URL:-"sqlite:///db/mmonit.db?synchronous=normal&foreign_keys=on&journal_mode=wal&temp_store=memory&cache_size=-20000&mmap_size=20971520"}
MMONIT_LICENSE_OWNER=${MMONIT_LICENSE_OWNER:-"Owner"}
MMONIT_LICENSE_KEY=${MMONIT_LICENSE_KEY:-"key"}

serverxmltext="
<!-- server.xml generated with entrypoint.sh -->
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<Server>
  <Service>
    <Connector address=\"*\" port=\"${MMONIT_PORT}\" processors=\"25\" />
    <Engine name=\"mmonit\" defaultHost=\"${MMONIT_DOMAIN}\" fileCache=\"10 MB\">
      <Realm url=\"${MMONIT_DATABASE_URL}\"
           minConnections=\"5\"
           maxConnections=\"25\"
           reapConnections=\"300\" />
      <ErrorLogger directory=\"logs\" fileName=\"error.log\" rotate=\"month\" />
      <Host name=\"${MMONIT_DOMAIN}\" appBase=\".\">
        <Logger directory=\"logs\" fileName=\"mmonit.log\" rotate=\"month\"
              timestamp=\"true\" />
        <Context path=\"\" docBase=\"docroot\" sessionTimeout=\"30 min\"
               maxActiveSessions=\"1024\" saveSessions=\"true\" />
        <Context path=\"/collector\" docBase=\"docroot/collector\" />
      </Host>
    </Engine>
  </Service>
  <License file=\"license.xml\" />
</Server>
"

if [ -f "$fullpath/server.xml" ]; then
	comparisonline="<!-- server.xml generated with entrypoint.sh -->"
	fstlineserv=$(head -n 1 "$fullpath/server.xml")
	if [ ! "$comparisonline" = "$fstlineserv" ]; then
		echo "$serverxmltext" >"$fullpath/server.xml"
	fi
else
	touch "$fullpath/server.xml"
	echo "$serverxmltext" >"$fullpath/server.xml"
fi

licensetext="
<!-- license.xml generated with entrypoint.sh -->
<License owner=\"${MMONIT_LICENSE_OWNER}\">${MMONIT_LICENSE_KEY}</License>
"

if [ -f "$fullpath/license.xml" ]; then
	comparisonline="<!-- license.xml generated with entrypoint.sh -->"
	fstlinelic=$(head -n 1 "$fullpath/license.xml")
	if [ ! "$comparisonline" = "$fstlinelic" ]; then
		echo "$licensetext" >"$fullpath/license.xml"
	fi
else
	touch "$fullpath/license.xml"
	echo "$licensetext" >"$fullpath/license.xml"
fi

echo "Launching M/Monit..."
exec "$@"
