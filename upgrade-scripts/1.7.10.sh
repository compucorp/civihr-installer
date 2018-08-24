#!/bin/bash
echo "Installing security updates"
drush up --security-only -y

echo "Pulling CiviHR 1.7.10"
cd sites/all/modules/civicrm/tools/extensions/civihr && git stash && git fetch origin && git checkout 1.7.10 && cd -
cd sites/all/modules/civicrm/tools/extensions/civihr_tasks && git stash && git fetch origin && git checkout 1.7.10 && cd -
cd sites/all/modules/civihr-custom && git stash && git fetch origin && git checkout 1.7.10 && cd -
cd sites/all/themes/civihr_employee_portal_theme && git stash && git fetch origin && git checkout 1.7.10 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.styleguide/ && git stash && git fetch origin && git checkout v0.1-alpha6 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.shoreditch/ && git stash && git fetch origin && git checkout v0.1-alpha24 && cd -

# When logging is enabled, the upgrader 1023 in HRCore fails,
# because civi will try to recreate triggers for the deleted
# fields in that upgrader. When logging is disabled, the
# triggers are not rebuilt
drush cvapi setting.create logging=0

drush cvapi extension.upgrade -y
drush updatedb -y

# Now that the upgrader has been applied, we can enable logging again
drush cvapi setting.create logging=1

drush fr civihr_employee_portal_features.menu_links -y

drush cc all
drush cc civicrm
