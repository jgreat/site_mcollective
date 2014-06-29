site_mcollective
================

Puppet module that's a wrapper to install mcollective.

#####Installation:#####  
Clone this repo into your `/etc/puppet/modules` directory.  
  
NOTE: This module uses hiera with yaml.
  - Copy the `site_mcollective/site_mcollective.yaml` to your yaml directory
  - Add `site_mcolletive` to `hiera.yaml :hirearchy:`. 
  - Restart your puppetmaster (apache2).

#####Configuration:#####
Modify the `site_mcollective.yaml` file to suit your install.
  - `middleware_hosts:` your puppet master server.
  - `activemq_password:` Change it to something long and random.
  - `activemq_admin_password:` Change it to something long and random.
  - `ssl_server_public:` Change cert file name to your server name.
  - `ssl_server_private:` Change key file name to your server name.
  - `users:` remove me and add your users to this list/array.

######Copy Server SSL certs to module######  
CA cert
```
cp /var/lib/puppet.example.com/ssl/certs/ca.pem /etc/puppet/modules/site_mcollective/files/server/certs/
```
Server Cert/Key
```
cp /var/lib/puppet.example.com/ssl/certs/puppet.example.com.pem /etc/puppet/modules/site_mcollective/files/server/certs/
cp /var/lib/puppet.example.com/ssl/private_keys/puppet.example.com.pem /etc/puppet/modules/site_mcollective/files/server/keys/
```

######Create user SSL certs and copy to module######  
Note this user should already exist on the system.  
Create the Cert/Key
```
puppet cert generate <user>
```
  - Copy Cert/Key
```
cp /var/lib/puppet.example.com/ssl/certs/<user>.pem /etc/puppet/modules/site_mcollective/files/user/certs/
cp /var/lib/puppet.example.com/ssl/private_keys/<user>.pem /etc/puppet/modules/site_mcollective/files/user/keys/
```
Call the site_mcollective class in your puppet manifest.

Agent only install (Instances you want to control with MCollective): 
  class { 'site_mcollective': }

Middleware "Server" install (I install this on my puppetmaster):
  Includes agent, client(mco commands) and middleware.
  class { 'site_mcollective': install_type => 'middleware' }

Client "Console" install. 
  Other places you want to run mco from but not install the server.
  class { 'site_mcollective': install_type => 'client' }


