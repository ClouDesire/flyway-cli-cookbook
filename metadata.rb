name             'flyway-cli'
maintainer       'ClouDesire'
maintainer_email 'dev@cloudesire.com'
license          'Apache v2.0'
description      'Installs and execute flyway cli'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/ClouDesire/flyway-cli-cookbook' if respond_to?(:source_url)
issues_url       'https://github.com/ClouDesire/flyway-cli-cookbook/issues' if respond_to?(:issues_url)
version          '0.5.0'
supports         'ubuntu'
supports         'windows'

depends          'java', '~> 1.17'
depends          'ark'
depends          'compat_resource' # For custom resource compilation on chef-client versions < 12.5
