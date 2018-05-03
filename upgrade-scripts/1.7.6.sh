#!/bin/bash

echo "Installing security updates"
drush up --security-only -y

echo "Creating core-fork-last-commit-patched.txt and make it skip the attachments patch"

pushd "sites/all/modules/civicrm/tools/extensions/civihr" >> /dev/null
    if [ ! -f core-fork-last-commit-patched.txt ]; then
        echo "985964d12dd9fd046d53d2923aa0ed4bf928764c" > core-fork-last-commit-patched.txt
    fi;
popd

echo "Pulling CiviHR 1.7.6"
cd sites/all/modules/civicrm/tools/extensions/civihr && git stash && git fetch origin && git checkout 1.7.6 && cd -
cd sites/all/modules/civicrm/tools/extensions/civihr_tasks && git stash && git fetch origin && git checkout 1.7.6 && cd -
cd sites/all/modules/civihr-custom && git stash && git fetch origin && git checkout 1.7.6 && cd -
cd sites/all/themes/civihr_employee_portal_theme && git stash && git fetch origin && git checkout 1.7.6 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.styleguide/ && git stash && git fetch origin && git checkout v0.1-alpha5 && cd -
cd sites/all/modules/civicrm/tools/extensions/org.civicrm.shoreditch/ && git stash && git fetch origin && git checkout v0.1-alpha18 && cd -

echo "Patching compucorp:civicrm-core on top of core files"
cd sites/all/modules/civicrm/tools/extensions/civihr && bin/apply-core-fork-patch.sh && cd -

drush cvapi extension.upgrade -y
drush updatedb -y

drush pm-update -y webform_civicrm

drush cc all
drush cc civicrm
