CiviHR Installation Script
==========================

CiviHR is a complex system, with many moving parts. It's possible to create a new site manually, but, given the number of necessary steps, this a hard and time consuming task. This script tries to solve this problem, requiring a very minimum number of external tools and it's able complete an installation in just a few minutes.

Technical Requirements
----------------------

In order to run the script and CiviHR you'll need:
- PHP >= 5.5.9 and < 7 (With these extensions enabled: curl, mysql, gd, mbstring and all the xml extensions)
- MySQL 5.5 or 5.6
- Git
- Curl
- Drush >= 7 (Available globally)

You'll also need to enable URL rewriting on your web server.

Download and Installation
-------------------------

Just clone this repository to the computer where you want to install civihr and make the `civihr-install` script executable.

As an optional step, if you want to make the script globally accessible, you can add the cloned folder to your `PATH` environment variable. Example:

```
$export PATH=$PATH:/path/to/cloned/repository
``` 

Usage
-----

You can always check the most recent usage instructions and all the available options by just calling the script without any params.

These are all the minimum required params:

```
civihr-install <civihr-site-name> --dbuser <mysql-username> --cmsdb <name-of-drupal-database> --crmdb <name-of-civicrm-database> --url <site-url>
```

Here's an example:

```
civihr-install civihr --dbuser root --cmsdb drupal --crmdb civicrm --url http://localhost:8080
```

This will:
- Create a new `civihr` (name taken from the site name) folder inside your current directory
- Create the `drupal` and `civicrm` databases
- Install CiviHR inside the `civihr` folder

At the end of the installation you should see some information about your new site:

```
[[Show site summary (civihr)]]
 - CMS_ROOT: /example/folder/civihr
 - CMS_URL: http://localhost:8080
 - CMS_DB_DSN: mysql://root@127.0.0.1:3306/drupal?new_link=true
 - CIVI_DB_DSN: mysql://root@127.0.0.1:3306/civicrm?new_link=true
 - ADMIN_USER: admin
 - ADMIN_PASS: <random password>
[[General notes]]
 - You may need to restart httpd.
 - You may need to add the hostname and IP to /etc/hosts or DNS.
```

After the installation is complete, you'll probably need to create a new virtual host for your site. This configuration will depend on which web server you're using and the specificities of the system/environment on which you're installing CiviHR. Here's an example of how this can be done on Apache:

```
<VirtualHost *:8080>
    ServerAdmin webmaster@localhost
    DocumentRoot "/example/folder/civihr"

    ServerName localhost
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    <Directory "/example/folder/civihr">
        Options All
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>

</VirtualHost>
```

> Remember, CiviHR requires URL rewriting to be enabled in your web server

With the virtual host in place and the web server restarted, you should now be able to access the new site.

Depending on your permissions settings, you might need to change the permissions of the Drupal `files` folder (usually inside `sites/default/files`, `/example/folder/civihr/sites/default/files` in the example) so that the user running the web server can write to it.

Besides the `admin` user, the script will also create the `civihr_staff`, `civihr_manager` and `civihr_admin` users. Each one has a different access level to the system. The password for them is the same as their user names.

Upgrading CiviHR
----------------
Currently it's only possible to upgrade from one version of CiviHR to the next (for example from 1.6.9 to 1.6.10). So you'll need to run the upgrade script for each version. These scripts can be found in upgrade-scripts folder. They must be run from web root folder of the site, not any of it subdirs due to depending on relative paths to run git updates.

Known Issues and Limitations
----------------------------
- If you pass the database password to the command (using the `--dbpass` option), you might see a warning saying "Using a password on the command line interface can be insecure". This is just a warning from MySQL and it doesn't interfere with the installation process.
- If you check the command output, you might see an error message saying "Error while trying to find the common path for enabled extensions of project radix. Extensions are: civihr_default_theme, default, radix.". We're working on fixing this, but for the moment, you can igore it, since it doesn't interfere with the installation.
- The created site is not suitable for development, as it lacks many of the tools necessary for this
