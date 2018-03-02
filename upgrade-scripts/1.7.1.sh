#!/bin/bash

echo  "PCHR-2832: Upgrade CiviCRM"
cd sites/all/modules
mv civicrm ../civicrm_bk
curl -L https://download.civicrm.org/civicrm-4.7.27-drupal.tar.gz | tar xz
mkdir civicrm/tools
cp -ar ../civicrm_bk/tools/extensions civicrm/tools/
drush cvupdb #ignore info about  workflows

# "Fix" for the invalid entity filter error
sed -i '/Invalid Entity Filter/s/^/\/\//' civicrm/CRM/Core/BAO/CustomGroup.php
sed -i '/Invalid Filter/s/^/\/\//' civicrm/CRM/Core/BAO/CustomGroup.php

drush cc all
drush cc civicrm
rm -rf ../civicrm_bk

# Apply the attachments patch
cd civicrm
wget -O attachments.patch https://gist.githubusercontent.com/davialexandre/199b3ebb2c69f43c07dde0f51fb02c8b/raw/0f11edad8049c6edddd7f865c801ecba5fa4c052/attachments-4.7.27.patch
patch -p1 -i attachments.patch
rm attachments.patch
cd ../../../../

echo "PCHR-2873"
drush vset cache 0

echo  "PCHR-2958: New menu on new sites"
drush dl roles_for_menu-7.x-1.1
drush en roles_for_menu -y

echo "PCHR-2846: Add management for emergency contacts on SSP"
drush up -y webform_civicrm-7.x-4.19
cd sites/all/modules/contrib/webform_civicrm
curl -L https://patch-diff.githubusercontent.com/raw/colemanw/webform_civicrm/pull/93.patch > /tmp/93.patch
patch -p1 < /tmp/93.patch
drush -y updb
cd -

echo "PCHR-2583: SSP Menu updates for user with SSP access"
drush dl menu_attributes-7.x-1.0 -y
drush en menu_attributes -y

echo "PCHR-2560: Welcome email"
drush vset --format=integer mimemail_sitestyle 0
drush vset --format=integer smtp_allowhtml 1
drush vset mailsystem_theme default

echo "PCHR-2339: User onboarding wizard"
drush vset --format=integer node_export_reset_path_webform 0

echo "Pulling CiviHR 1.7.1"
cd sites/all/modules/civicrm/tools/extensions/civihr && git fetch origin && git checkout 1.7.1 && cd -
cd sites/all/modules/civicrm/tools/extensions/civihr_tasks && git fetch origin && git checkout 1.7.1 && cd -
cd sites/all/modules/civihr-custom && git fetch origin && git checkout 1.7.1 && cd -
cd sites/all/themes/civihr_employee_portal_theme && git fetch origin && git checkout 1.7.1 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.styleguide/ && git fetch origin && git checkout 0.1-alpha3 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.shoreditch/ && git fetch origin && git checkout v0.1-alpha14 && cd -

echo "PCHR-2846: Add management for emergency contacts on SSP"
drush ne-import --file=$PWD/sites/all/modules/civihr-custom/civihr_employee_portal/features/node_export_files/emergency_contact_creation_webform.export
drush ne-import --file=$PWD/sites/all/modules/civihr-custom/civihr_employee_portal/features/node_export_files/dependant_creation_webform.export

echo "PCHR-2783: User image upload doesn't seem to be working"
drush vset --format=integer user_pictures 0
drush -y updatedb

echo "PCHR-2585: Main menu item button to switch from SSP to Admin"
drush sql-query "DELETE FROM menu_links WHERE link_title = 'CiviHR SSP'"
drush sql-query "DELETE FROM menu_links WHERE link_title = 'CiviHR admin'"

echo "PCHR-2583: SSP menu updates for user with SSP access"
drush cc all
drush fr civihr_employee_portal_features -y
drush fr leave_and_absences_features -y
drush views-revert -y

echo "PCHR-2582: Rename assignments to workflows wherever it appears"
drush views-revert -y

echo "PCHR-2581: Make the developer menu item on CiviCRM admin only show for root user role"
drush fr civihr_default_permissions -y

echo "PCHR-2560: Welcome email"
drush en -y civihr_default_mail_content
drush dis -y mimemail_compress

echo "PCHR-2339: User onboarding wizard"
drush ne-import --file=$PWD/sites/all/modules/civihr-custom/civihr_employee_portal/features/node_export_files/onboarding_form.export
drush en -y onboarding_slideshow
# For unknown reasons, sometimes the first command only downloads the dependencies but doesn't enable them,
# so it call drush en a second time to make sure this will happen
drush en -y onboarding_slideshow
drush ne-import --file=$PWD/sites/all/modules/civihr-custom/civihr_employee_portal/features/node_export_files/onboarding_slideshow_images.export
(cd libraries/jquery.cycle; [[ $(file jquery.cycle.all.js) == *gzip* ]] && mv jquery.cycle.all.js jquery.cycle.all.js.gz && gunzip jquery.cycle.all.js.gz)

drush updatedb -y
drush cvapi extension.upgrade -y

drush cvapi System.updateindexes

drush cc all
drush cc civicrm
