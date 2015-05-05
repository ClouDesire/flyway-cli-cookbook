name             'flyway-cli'
maintainer       'ClouDesire'
maintainer_email 'dev@cloudesire.com'
license          'Apache 2.0'
description      'Installs and execute flyway cli'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.1'
supports         'ubuntu'
supports         'windows'

depends          'ubuntu'
depends          'java', '~> 1.17'
depends          'windows', '~> 1.36.1'
