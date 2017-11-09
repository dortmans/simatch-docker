#!/bin/bash
set -e

# setup ros environment
source "/simatch/devel/setup.bash"
exec "$@"
