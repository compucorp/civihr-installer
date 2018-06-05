#!/bin/bash

echo "Installing security updates"
drush up --security-only -y

echo "Pulling CiviHR 1.7.7"
cd sites/all/modules/civicrm/tools/extensions/civihr && git stash && git fetch origin && git checkout 1.7.7 && cd -
cd sites/all/modules/civicrm/tools/extensions/civihr_tasks && git stash && git fetch origin && git checkout 1.7.7 && cd -
cd sites/all/modules/civihr-custom && git stash && git fetch origin && git checkout 1.7.7 && cd -
cd sites/all/themes/civihr_employee_portal_theme && git stash && git fetch origin && git checkout 1.7.7 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.styleguide/ && git stash && git fetch origin && git checkout v0.1-alpha5 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.shoreditch/ && git stash && git fetch origin && git checkout v0.1-alpha19 && cd -

echo "Patching compucorp:civicrm-core on top of core files"
cd sites/all/modules/civicrm/tools/extensions/civihr && bin/apply-core-fork-patch.sh && cd -

drush cvapi extension.upgrade -y
drush updatedb -y

drush pm-update yoti-7.x-1.9 -y
drush vr civihr_report_leave_and_absence -y
drush cvapi StatusPreference.create name="checkVersion" ignore_severity="critical" hush_until=""

drush cc all
drush cc civicrm
