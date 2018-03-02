#!/bin/bash

echo "Pulling CiviHR 1.7.4"
cd sites/all/modules/civicrm/tools/extensions/civihr && git fetch origin && git checkout 1.7.4 && cd -
cd sites/all/modules/civicrm/tools/extensions/civihr_tasks && git fetch origin && git checkout 1.7.4 && cd -
cd sites/all/modules/civihr-custom && git fetch origin && git checkout 1.7.4 && cd -
cd sites/all/themes/civihr_employee_portal_theme && git fetch origin && git checkout 1.7.4 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.styleguide/ && git fetch origin && git checkout 0.1-alpha3 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.shoreditch/ && git fetch origin && git checkout 0.1-alpha16 && cd -

drush cvapi extension.upgrade -y
drush updatedb -y

VSQ_MODULE_PATH=$(drush ev "echo realpath(drupal_get_path('module', 'views_json_query'))")
echo "Removing views_json_query from $VSQ_MODULE_PATH"
rm -rf $VSQ_MODULE_PATH

drush cc all
drush cc civicrm
