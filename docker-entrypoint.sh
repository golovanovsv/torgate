#!/bin/bash

# Tor manual - https://www.torproject.org/docs/tor-manual.html.en

TCONF="/etc/torrc"
FINGER_FILE="/var/lib/tor/fingerprint"

if [[ ! -s "$TCONF" ]]; then

    # By default TOR starting as SOCKS proxy
    echo "Making TOR configuration file"
    echo "Log notice stdout" > $TCONF

    if [[ -n "$HEARTBEATPERIOD" ]]; then
        echo "HeartbeatPeriod $HEARTBEATPERIOD minutes" >> $TCONF
    else
        echo "HeartbeatPeriod 30 minutes" >> $TCONF
    fi

    if [[ -n "$SOCKSPORT" ]]; then
        echo "SocksPort 0.0.0.0:$SOCKSPORT" >> $TCONF
    else
        echo "SocksPort 0.0.0.0:9150" >> $TCONF
    fi

    # Enable relay mode
    if [[ -n "$RELAYPORT" ]]; then
        echo "ORPort 0.0.0.0:$RELAYPORT" >> $TCONF
    fi

    # Enable exit relay
    if [[ -n "$EXITNODE" ]]; then
        echo "ExitRelay 1" >> $TCONF
    else
        echo "ExitRelay 0" >> $TCONF
    fi

    if [[ -n "$NICKNAME" ]]; then
        echo "Nickname $NICKNAME" >> $TCONF
    fi

    if [[ -n "$CONTROLPORT" ]] && [[ -n "$HASHEDCONTROLPASSWORD" ]]; then
        echo "ControlPort $CONTROLPORT" >> $TCONF
        echo "HashedControlPassword $HASHEDCONTROLPASSWORD" >> $TCONF
    fi

    if [[ -n "$CONTACTINFO" ]]; then
        echo "ContactInfo $CONTACTINFO" >> $TCONF
    fi

    if [[ -n "$FINGERPRINT" ]]; then
        echo "$FINGERPRINT" > $FINGER_FILE
    fi
fi

exec "$@"
