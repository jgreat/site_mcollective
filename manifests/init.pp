class site_mcollective ($install_type = 'agent') {
    #Conifguration is defined in hiera copy site_mcollective.yaml to your yaml dir
    $config = hiera('site_mcollective')
    case $install_type { 
        'agent': {
            #Just the agent to install on insances
            class { 'mcollective':
                middleware_hosts          => $config['middleware_hosts'],
                middleware_ssl            => true,
                middleware_password       => $config['activemq_password'],
                middleware_admin_password => $config['activemq_admin_password'],
                securityprovider          => 'ssl',
                ssl_client_certs          => $config['ssl_client_certs'],
                ssl_ca_cert               => $config['ssl_ca_cert'],
                ssl_server_public         => $config['ssl_server_public'],
                ssl_server_private        => $config['ssl_server_private'],
            }
        }
        'middleware': {
            #Instal agent, client (mco) and middleware server. 
            class { 'mcollective':
                client                    => true,
                middleware                => true,
                middleware_hosts          => $config['middleware_hosts'],
                middleware_ssl            => true,
                middleware_password       => $config['activemq_password'],
                middleware_admin_password => $config['activemq_admin_password'],
                securityprovider          => 'ssl',
                ssl_client_certs          => $config['ssl_client_certs'],
                ssl_ca_cert               => $config['ssl_ca_cert'],
                ssl_server_public         => $config['ssl_server_public'],
                ssl_server_private        => $config['ssl_server_private'],
            }
            @site_mcollective::user { $config['users']: }
            Site_mcollective::User <|title == $config['users'] |>
        }
        /^(client|console)$/: {
            #Install agent and client (mco)
            class { 'mcollective':
                client                    => true,
                middleware_hosts          => $config['middleware_hosts'],
                middleware_ssl            => true,
                middleware_password       => $config['activemq_password'],
                middleware_admin_password => $config['activemq_admin_password'],
                securityprovider          => 'ssl',
                ssl_client_certs          => $config['ssl_client_certs'],
                ssl_ca_cert               => $config['ssl_ca_cert'],
                ssl_server_public         => $config['ssl_server_public'],
                ssl_server_private        => $config['ssl_server_private'],
            }
            @site_mcollective::user { $config['users']: }
            Site_mcollective::User <|title == $config['users'] |>
        }
        default: {
        }
    }
    
    #Server setting to stop warnings
    mcollective::server::setting { 'plugin.activemq.heartbeat_interval':
        setting => 'plugin.activemq.heartbeat_interval',
        value   => '30',
    }

    #Define plugins to install. Puppet Labs has some packaged ones
    mcollective::plugin { 'puppet':
        package =>  true,
    }
    #Others need to be installed by downloading and providing path
    mcollective::plugin { 'shellout':
        source => 'puppet:///modules/site_mcollective/plugins/shellout',
    }
}


define site_mcollective::user () {
    mcollective::user { $title:
        certificate => "puppet:///modules/site_mcollective/user/certs/${title}.pem",
        private_key => "puppet:///modules/site_mcollective/user/keys/${title}.pem",
        #require     => User[$title],
    }
    mcollective::user::setting { "$title.plugin.activemq.heartbeat_interval":
        username => $title,
        setting  => 'plugin.activemq.heartbeat_interval',
        value    => '30',
    }
}

