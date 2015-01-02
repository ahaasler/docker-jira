#!/bin/sh

# Backup conf/server.xml
cp conf/server.xml conf/server.xml~

while getopts ":sn:p:c:" opt; do
	case $opt in
		s)
			echo "Using security and 'https' as connector scheme"
			# Use secure connector
			xmlstarlet ed --inplace --delete "/Server/Service/Connector/@secure" conf/server.xml
			xmlstarlet ed --inplace --insert "/Server/Service/Connector" --type attr -n secure -v true conf/server.xml
			# Use https
			xmlstarlet ed --inplace --delete "/Server/Service/Connector/@scheme" conf/server.xml
			xmlstarlet ed --inplace --insert "/Server/Service/Connector" --type attr -n scheme -v https conf/server.xml
			;;
		n)
			echo "Using '$OPTARG' as connector proxyName"
			# Set connector proxyName
			xmlstarlet ed --inplace --delete "/Server/Service/Connector/@proxyName" conf/server.xml
			xmlstarlet ed --inplace --insert "/Server/Service/Connector" --type attr -n proxyName -v $OPTARG conf/server.xml
			;;
		p)
			echo "Using '$OPTARG' as connector proxyPort"
			# Set connector proxyPort
			xmlstarlet ed --inplace --delete "/Server/Service/Connector/@proxyPort" conf/server.xml
			xmlstarlet ed --inplace --insert "/Server/Service/Connector" --type attr -n proxyPort -v $OPTARG conf/server.xml
			;;
		c)
			echo "Using '$OPTARG' as context path"
			xmlstarlet ed --inplace --delete "/Server/Service/Engine/Host/Context/@path" conf/server.xml
			xmlstarlet ed --inplace --insert "/Server/Service/Engine/Host/Context" --type attr -n path -v /$OPTARG conf/server.xml
			;;
		\?)
			echo "Unknown option: -$OPTARG"
			;;
		:)
			echo "-$OPTARG requires an argument"
			exit 1
			;;
	esac
done

# Start jira with jira user
su -m jira -c "bin/start-jira.sh -fg"
