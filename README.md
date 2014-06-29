site_mcollective
================

Puppet module that a wraps puppetlabs/mcollective to make install easy-ish. You might be able to do this though some fancy yaml, I just found this cleaner.

#####Requirements
This module requires the `puppetlabs/mcollective` module
```
puppet module install puppetlabs/mcollective
```

#####Installation
Clone this repo into your `/etc/puppet/modules` directory.  
  
NOTE: This module uses hiera with yaml.
  - Copy the `site_mcollective/site_mcollective.yaml` to your yaml directory
  - Add `site_mcolletive` to `hiera.yaml :hirearchy:`. 
  - Restart your puppetmaster (apache2).

#####Configuration
Modify the `site_mcollective.yaml` file to suit your install.
  - `middleware_hosts:` a list of your puppetmaster/mcollective servers.
  - `activemq_password:` Change it to something long and random.
  - `activemq_admin_password:` Change it to something long and random.
  - `ssl_server_public:` Change cert file name to your server name.
  - `ssl_server_private:` Change key file name to your server name.
  - `users:` a list of your users that can run `mco`. These users must alreay have accounts.

######Copy Server SSL certs to Module
CA cert
```
cp /var/lib/puppet.example.com/ssl/certs/ca.pem /etc/puppet/modules/site_mcollective/files/server/certs/
```
Server Cert/Key
```
cp /var/lib/puppet.example.com/ssl/certs/puppet.example.com.pem /etc/puppet/modules/site_mcollective/files/server/certs/
cp /var/lib/puppet.example.com/ssl/private_keys/puppet.example.com.pem /etc/puppet/modules/site_mcollective/files/server/keys/
chgrp puppet /etc/puppet/modules/site_mcollective/files/server/keys/puppet.example.com.pem
```

######Create user SSL certs and copy to Module  
NOTE: this user should already exist on the system.   
Create the Cert/Key
```
puppet cert generate <user>
```
Copy Cert/Key
```
cp /var/lib/puppet.example.com/ssl/certs/<user>.pem /etc/puppet/modules/site_mcollective/files/user/certs/
cp /var/lib/puppet.example.com/ssl/private_keys/<user>.pem /etc/puppet/modules/site_mcollective/files/user/keys/
chgrp puppet /etc/puppet/modules/site_mcollective/files/user/keys/<user>.pem
```
#####Call the site_mcollective class in your puppet manifest.
Agent only install (Instances you want to control with MCollective): 
```
class { 'site_mcollective': }
```
Middleware "Server" install (I install this on my puppetmaster):  
Includes agent, client(mco commands) and middleware.  
NOTE: the users you define in the `site_mcollective.yaml` will need to have accounts on this systems. 
```
class { 'site_mcollective': install_type => 'middleware' }
```
Client "Console" install.   
Other places you want to run mco from but not install the server.  
NOTE: the users you define in the `site_mcollective.yaml` will need to have accounts on this systems. 

```
class { 'site_mcollective': install_type => 'client' }
```

