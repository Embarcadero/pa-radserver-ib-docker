#!/bin/bash

if [ -f /etc/ems/emsserver.ini -a -f /etc/ems/emsserver.ib ]; then
        :
else
		rm /opt/interbase/license/radserverlicense.slip

        /opt/interbase/bin/LicenseManagerLauncher -i console

		sh /tmp/rssetup.sh swaggerui RS,RC,SUI
		sh /tmp/apachesetup.sh radserver radconsole RS,RC
fi

if [ -f /etc/ems/module.so ]; then
	sed -i ':a;N;$!ba;s#\[Server\.Packages\]\n#\[Server\.Packages\]\n/etc/ems/module.so=module#g' /etc/ems/emsserver.ini
fi

if [ "$CONFIG" = "PRODUCTION" ]; then
	:
else
	if [ "$CONFIG" = "INTERBASE" ]; then
		:
	else
		nohup broadwayd :2 &
		export GDK_BACKEND=broadway
		export BROADWAY_DISPLAY=:2
	fi
fi

if [ "$CONFIG" = "INTERBASE" ]; then
	service apache2 stop
else
	/usr/sbin/apachectl -D Foreground
	status=$?
	if [ $status -ne 0 ]; then
		echo "Failed to start apache: $status"
		exit $status
	fi
fi

/opt/interbase/bin/ibmgr -start -forever
status=$?
if [ $status -ne 0 ]; then
	echo "Failed to start interbase: $status"
	exit $status
fi

if [ "$CONFIG" = "PRODUCTION" ]; then
	:
else
	if [ "$CONFIG" = "INTERBASE" ]; then
		:
	else
		./paserver -password=$PA_SERVER_PASSWORD 
		status=$?
		if [ $status -ne 0 ]; then
			echo "Failed to start paserver: $status"
			exit $status
		fi
	fi
fi

while sleep 60; do
	ps aux |grep paserver |grep -q -v grep
	PA_SERVER_STATUS=$?
	if [ "$CONFIG" = "PRODUCTION" ]; then
		PA_SERVER_STATUS=0
	else
		if [ "$CONFIG" = "INTERBASE" ]; then
			PA_SERVER_STATUS=0
		fi
	fi

	if pgrep -x "ibserver" >/dev/null
	then
			INTERBASE_STATUS=1
	else
			INTERBASE_STATUS=0
	fi
	
	ps aux |grep apache |grep -q -v grep
	APACHE_STATUS=$?
	if [ "$CONFIG" = "INTERBASE" ]; then
		APACHE_STATUS=0
	fi
	if [ $PA_SERVER_STATUS -eq 0 -a $APACHE_STATUS -eq 0 -a $INTERBASE_STATUS -eq 0 ]; then
		echo "Complete!"
		exit 1
	fi
done
