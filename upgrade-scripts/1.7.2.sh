#!/bin/bash

echo "Pulling CiviHR 1.7.2"
cd sites/all/modules/civicrm/tools/extensions/civihr && git fetch origin && git checkout 1.7.2 && cd -
cd sites/all/modules/civicrm/tools/extensions/civihr_tasks && git fetch origin && git checkout 1.7.2 && cd -
cd sites/all/modules/civihr-custom && git fetch origin && git checkout 1.7.2 && cd -
cd sites/all/themes/civihr_employee_portal_theme && git fetch origin && git checkout 1.7.2 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.styleguide/ && git fetch origin && git checkout 0.1-alpha3 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.shoreditch/ && git fetch origin && git checkout v0.1-alpha14 && cd -

drush updatedb -y
drush cvapi extension.upgrade -y

drush civicrm-sql-query 'select dependant_s__92, count(dependant_s__92) FROM civicrm_value_emergency_contacts_21 GROUP BY dependant_s__92'
drush civicrm-sql-query 'UPDATE civicrm_value_emergency_contacts_21 SET dependant_s__92 = "no" WHERE dependant_s__92 = "" OR dependant_s__92 IS NULL'
drush civicrm-sql-query 'select dependant_s__92, count(dependant_s__92) FROM civicrm_value_emergency_contacts_21 GROUP BY dependant_s__92'

drush cc all
drush cc civicrm
