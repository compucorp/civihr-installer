#!/bin/bash

echo "Installing security updates"
drush up --security-only -y

CIVIHRVER=1.7.11

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
update_repo sites/all/modules/civicrm/tools/extensions/org.civicrm.styleguide v0.1-alpha6
update_repo sites/all/modules/civicrm/tools/extensions/org.civicrm.shoreditch v0.1-alpha25

echo "PCHR-4238: Fix Relationship Type in XML definitions"
cat <<"SCRIPT" > fix-4238.php
<?php
    civicrm_initialize();

    $caseTypes = civicrm_api3('CaseType', 'get', [
      'return' => ['id', 'name'],
      'sequential' => 1
    ])['values'];

    foreach ($caseTypes as $caseType) {
      $xml = CRM_Case_XMLRepository::singleton()->retrieve($caseType['name']);
      $updated = false;
      if($xml) {
        foreach ($xml->CaseRoles->RelationshipType as $rt) {
          if ($rt->name == 'Line Manager') {
            $rt->name = 'Is Line Manager of';
            $updated = true;
          }
        }
      }

      if ($updated) {
        // We update the table directly because using the API would result in the
        // creation of managed entities for the CaseType components, which we
        // don't want to happen
        $params = [
          1 => [$xml->asXML(), 'String'],
          2 => [$caseType['id'], 'Integer']
        ];
        CRM_Core_DAO::executeQuery("UPDATE civicrm_case_type SET definition = %1 WHERE id = %2", $params);
      }
    }
SCRIPT
drush php-script fix-4238
rm -f fix-4238

echo "FAR-298: Enable CiviTask and CiviDocument for all sites"
drush ev "\$components = civicrm_api3('setting', 'getsingle', ['return' => 'enable_components', 'sequential' => 1]); \$components = array_unique(array_merge(\$components['enable_components'], ['CiviTask', 'CiviDocument'])); var_dump(civicrm_api3('setting', 'create', ['enable_components' => \$components]));"

echo "PCHR-4138: Revert menus in the SSP"
drush features-revert civihr_employee_portal_features.menu_links -y

echo "PCHR-4233: Remove orphan managed CiviCase activity types"
drush civicrm-sql-query "delete from civicrm_managed where module = 'civicrm' and name like 'civicase:%' and entity_id not in (select id from civicrm_option_value)"
drush civicrm-sql-query "select * from civicrm_managed where module = 'civicrm' and name like 'civicase:%' and entity_id not in (select id from civicrm_option_value)"

drush cvapi extension.upgrade -y
drush updatedb -y

drush cc all
drush cc civicrm
