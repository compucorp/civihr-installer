#!/bin/bash
# Author: Aljaz Ceru <aljaz@compucorp.co.uk>
# CiviHR release 1.6.10
#
# PRE RELEASE
drush -y en civicrm_resources
# END OF PRERELEASE
# RELEASE 
cd sites/all/modules/civicrm/tools/extensions/civihr && git fetch origin && git checkout 1.6.10 && cd -
cd sites/all/modules/civicrm/tools/extensions/civihr_tasks && git fetch origin && git checkout 1.6.10 && cd -
cd sites/all/modules/civihr-custom && git fetch origin && git checkout 1.6.10 && cd -
cd sites/all/themes/civihr_employee_portal_theme && git fetch origin && git checkout 1.6.10 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.styleguide/ && git remote set-url origin https://github.com/civicrm/org.civicrm.shoreditch.git && git fetch origin && git checkout 0.1-alpha3 &&  cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.shoreditch/ && git remote set-url origin https://github.com/civicrm/org.civicrm.shoreditch.git && git fetch origin && git checkout v0.1-alpha9 &&  cd -
drush cvapi extension.refresh local=1
drush updatedb -y
drush cvapi extension.upgrade -y
drush cvapi extension.enable keys=uk.co.compucorp.civicrm.hremails
drush vdis Documents
drush ven Documents
drush vr Documents
drush fr --force -y civihr_default_permissions
drush en -y masquerade
drush vdis civihr_staff_directory
drush ven civihr_staff_directory
drush en -y logintoboggan
drush vset logintoboggan_login_with_email 1
drush cc civicrm
drush cc all
# END OF RELEASE
# POST RELEASE
drush role-add-perm 'civihr_manager' 'change document status'
drush role-add-perm 'civihr_manager' 'access Tasks and Assignments Files'
drush role-add-perm 'civihr_manager' 'access uploaded files'
drush role-add-perm 'civihr_staff' 'access AJAX API'
drush role-add-perm 'civihr_staff' 'view all activities'
drush role-add-perm 'civihr_staff' 'access Tasks and Assignments Files'
drush role-add-perm 'civihr_staff' 'access uploaded files'
# END OF POST RELEASE

