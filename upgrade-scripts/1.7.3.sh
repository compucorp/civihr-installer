#!/bin/bash

echo "Pulling CiviHR 1.7.2"
cd sites/all/modules/civicrm/tools/extensions/civihr && git fetch origin && git checkout 1.7.3 && cd -
cd sites/all/modules/civicrm/tools/extensions/civihr_tasks && git fetch origin && git checkout 1.7.3 && cd -
cd sites/all/modules/civihr-custom && git fetch origin && git checkout 1.7.3 && cd -
cd sites/all/themes/civihr_employee_portal_theme && git fetch origin && git checkout 1.7.3 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.styleguide/ && git fetch origin && git checkout 0.1-alpha3 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.shoreditch/ && git fetch origin && git checkout v0.1-alpha15 && cd -

drush updatedb -y
drush cvapi extension.upgrade -y

drush fr -y --force civihr_employee_portal_features.menu_links

drush cc all
drush cc civicrm
