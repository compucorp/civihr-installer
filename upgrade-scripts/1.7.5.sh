#!/bin/bash

echo "Installing security updates"
drush up --security-only -y

echo "Pulling CiviHR 1.7.5"
cd sites/all/modules/civicrm/tools/extensions/civihr && git stash && git fetch origin && git checkout 1.7.5 && cd -
cd sites/all/modules/civicrm/tools/extensions/civihr_tasks && git stash && git fetch origin && git checkout 1.7.5 && cd -
cd sites/all/modules/civihr-custom && git stash && git fetch origin && git checkout 1.7.5 && cd -
cd sites/all/themes/civihr_employee_portal_theme && git stash && git fetch origin && git checkout 1.7.5 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.styleguide/ && git stash && git fetch origin && git checkout v0.1-alpha4 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.shoreditch/ && git stash && git fetch origin && git checkout v0.1-alpha17 && cd -

drush cvapi extension.upgrade -y
drush updatedb -y

drush vr civihr_report_people -y
drush vr civihr_report_leave_and_absence -y

drush cc all
drush cc civicrm
