#!/bin/bash 
# Author: Aljaz Ceru
# Template script for CiviHR releases
# version: 1.6.11
drush -y dis yoti yoti_connect
cd sites/all/modules/civicrm/tools/extensions/civihr && git fetch origin && git checkout 1.6.11 && cd -
cd sites/all/modules/civicrm/tools/extensions/civihr_tasks && git fetch origin && git checkout 1.6.11 && cd -
cd sites/all/modules/civihr-custom && git fetch origin && git checkout 1.6.11 && cd -
cd sites/all/themes/civihr_employee_portal_theme && git fetch origin && git checkout 1.6.11 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.styleguide/ && git fetch origin && git checkout 0.1-alpha3 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.shoreditch/ && git fetch origin && git checkout v0.1-alpha10 && cd -
drush -y en yoti
drush pm-update views_fieldsets 7.x-2.1
drush updatedb -y
drush cvapi extension.upgrade -y
drush cc civicrm
drush cc all
