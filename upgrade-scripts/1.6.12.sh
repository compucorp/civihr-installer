#!/bin/bash
# Author: Stelios Milidonis <stelios@compucorp.co.uk>
# CiviHR release 1.6.12

drush up --security-only -y
cd sites/all/modules/civicrm/tools/extensions/civihr && git fetch origin && git checkout 1.6.12 && cd -
cd sites/all/modules/civicrm/tools/extensions/civihr_tasks && git fetch origin && git checkout 1.6.12 && cd -
cd sites/all/modules/civihr-custom && git fetch origin && git checkout 1.6.12 && cd -
cd sites/all/themes/civihr_employee_portal_theme && git fetch origin && git checkout 1.6.12 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.styleguide/ && git fetch origin && git checkout 0.1-alpha3 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.shoreditch/ && git fetch origin && git checkout v0.1-alpha11 && cd -

drush role-add-perm 'administrator' 'access CiviReport'
drush role-add-perm 'administrator' 'access Report Criteria'
drush role-add-perm 'civihr_admin' 'access Report Criteria'
drush role-add-perm 'administrator' 'access Tasks and Assignments Files'
drush role-add-perm 'administrator' 'access all cases and activities'
drush role-add-perm 'administrator' 'access my cases and activities'
drush role-add-perm 'administrator' 'add cases'
drush role-add-perm 'administrator' 'administer CiviCase'
drush role-add-perm 'administrator' 'administer Reports'
drush role-add-perm 'administrator' 'delete in CiviCase'
drush vr civihr_staff_directory
drush vr Documents
drush vr my_details_block
