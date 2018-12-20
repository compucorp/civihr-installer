#!/bin/bash
echo "Installing security updates"
drush up --security-only -y

CIVIHRVER=1.7.14

echo "Pulling CiviHR $CIVIHRVER"

function update_repo() {
  pushd $1
  git stash 2> /dev/null &&
  git fetch origin 2> /dev/null &&
  git checkout $2 2> /dev/null &&
  git log --oneline -n 1
  popd
}

update_repo sites/all/modules/civicrm/tools/extensions/civihr $CIVIHRVER
update_repo sites/all/modules/civicrm/tools/extensions/civihr_tasks $CIVIHRVER
update_repo sites/all/modules/civihr-custom $CIVIHRVER
update_repo sites/all/themes/civihr_employee_portal_theme $CIVIHRVER
update_repo sites/all/modules/civicrm/tools/extensions/org.civicrm.styleguide v0.1-alpha7
update_repo sites/all/modules/civicrm/tools/extensions/org.civicrm.shoreditch v0.1-alpha29

echo "Patching compucorp:civicrm-core on top of core files"
cd sites/all/modules/civicrm/tools/extensions/civihr && bin/apply-core-fork-patch.sh && cd -

drush cvapi extension.upgrade -y
drush updatedb -y

drush cc all
drush cc civicrm
