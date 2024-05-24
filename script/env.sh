#!/bin/sh
set -e
script_dir=$(cd $(dirname $0);pwd)
ROOT=$(dirname $script_dir)
apps_dir=$ROOT/apps
packages_dir=$ROOT/packages
organization=com.openvidu.flutter
app_name=meeting
package_name=sdk