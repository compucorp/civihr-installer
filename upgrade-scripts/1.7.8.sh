#!/bin/bash
echo "Installing security updates"
drush up --security-only -y

echo "Pulling CiviHR 1.7.8"
cd sites/all/modules/civicrm/tools/extensions/civihr && git stash && git fetch origin && git checkout 1.7.8 && cd -
cd sites/all/modules/civicrm/tools/extensions/civihr_tasks && git stash && git fetch origin && git checkout 1.7.8 && cd -
cd sites/all/modules/civihr-custom && git stash && git fetch origin && git checkout 1.7.8 && cd -
cd sites/all/themes/civihr_employee_portal_theme && git stash && git fetch origin && git checkout 1.7.8 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.styleguide/ && git stash && git fetch origin && git checkout v0.1-alpha5 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.shoreditch/ && git stash && git fetch origin && git checkout v0.1-alpha20 && cd -

echo "Upgrading CiviCRM to 5.3.0"
cd sites/all/modules
mv civicrm ../civicrm_bk
curl -L https://download.civicrm.org/civicrm-5.3.0-drupal.tar.gz | tar xz
mkdir civicrm/tools
cp -ar ../civicrm_bk/tools/extensions civicrm/tools/
drush cvupdb
rm -rf ../civicrm_bk
cd -
cd sites/all/modules/civicrm/tools/extensions/civihr && rm -f core-fork-last-commit-patched.txt && ./bin/apply-core-fork-patch.sh && cd -

drush cvapi extension.upgrade -y
drush updatedb -y

drush cc all
drush cc civicrm
