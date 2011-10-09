#!/bin/bash

# LXC tools
# Copyright (C) 2011 Infertux <infertux@infertux.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

# Check for updates on Debian-based containers.
# Pass --interactive flag (or anything ;)) to give you the possibility to upgrade.

LXC=/var/lib/lxc
ROOTFS=rootfs
UPGRADE_CMD="apt-get dist-upgrade"
RUNNING_CONTAINERS="$(netstat -xa | grep $LXC | sed -e 's#.*'"$LXC/"'\(.*\)/command#\1#')"
INTERACTIVE="$1"

for container in $RUNNING_CONTAINERS; do
  chroot $LXC/$container/$ROOTFS apt-get update -qq
  updates="$(chroot $LXC/$container/$ROOTFS $UPGRADE_CMD -qs | grep '^ ')"

  if [ "$updates" ]; then
    [ "$INTERACTIVE" ] && chroot $LXC/$container/$ROOTFS $UPGRADE_CMD || echo -e "Updates for $container:\n$updates"
  else
    echo "$container is up-to-date."
  fi
done
