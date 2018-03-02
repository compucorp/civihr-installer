#!/usr/bin/env bash

cd sites/all/modules/civicrm/tools/extensions/civihr
git fetch origin
git checkout 1.7.0

drush cvapi extension.refresh local=1
drush cvapi extension.install keys=uk.co.compucorp.civicrm.hrleaveandabsences
drush cvapi extension.install keys=uk.co.compucorp.civicrm.hrcomments
drush cvapi extension.install keys=uk.co.compucorp.civicrm.hremails

cd -

cd sites/all/modules/civicrm/tools/extensions/civihr_tasks && git fetch origin && git checkout 1.7.0 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.shoreditch && git fetch origin && git checkout v0.1-alpha12 && cd -
cd sites/all/modules/civihr-custom && git fetch origin && git checkout 1.7.0 && cd -
cd sites/all/themes/civihr_employee_portal_theme && git fetch origin && git checkout 1.7.0 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.styleguide/ && git fetch origin && git checkout 0.1-alpha3 && cd -

drush vdis absence_list
drush vdis absence_approval_list
drush vdis calendar_absence_list
drush sql-query "DROP VIEW absence_list"
drush sql-query "DROP VIEW absence_approval_list"
drush sql-query "DROP VIEW absence_activity"
drush sql-query "DROP VIEW absence_entitlement"

drush en civihr_leave_absences leave_and_absences_features -y
drush features-revert civihr_employee_portal_features -y
drush features-revert civihr_default_permissions -y
drush updatedb -y
drush cvapi extension.upgrade -y

#apply attachment patches
cd sites/all/modules/civicrm/
wget https://gist.githubusercontent.com/davialexandre/deafc6d4929fbf58b97105e54bfb300f/raw/2ec70492a8d5ce419337cc58097c1dfd3e2d4df6/attachments.patch
patch -p1 -i attachments.patch
rm attachments.patch

drush cvapi extension.disable keys=org.civicrm.hrabsence
drush cvapi extension.uninstall keys=org.civicrm.hrabsence

drush cc all
drush cc civicrm
