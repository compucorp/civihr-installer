#!/bin/bash 
# Author: Aljaz Ceru
# Template script for CiviHR releases
# version: 1.6.11
drush -y dis yoti yoti_connect
cd sites/all/modules/civicrm/tools/extensions/civihr && git pull origin master &&  cd -
cd sites/all/modules/civicrm/tools/extensions/civihr_tasks && git pull origin master &&  cd -
cd sites/all/modules/civihr-custom && git pull origin master &&  cd -
cd sites/all/themes/civihr_employee_portal_theme && git pull origin master &&  cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.styleguide/ && git pull origin master &&  cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.shoreditch/ && git pull origin master &&  cd -
drush -y en yoti
drush pm-update views_fieldsets 7.x-2.1
drush updatedb -y
drush cvapi extension.upgrade -y
drush cc civicrm
drush cc all