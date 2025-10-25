#!/bin/bash
state=$(xkb-switch -g | grep -q 'Caps' && echo "on" || echo "off")
echo "{\"text\":\"$([ $state == "on" ] && echo "CAPS")\",\"class\":\"$state\"}"
