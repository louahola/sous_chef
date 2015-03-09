name 'sous_chef'
maintainer 'Larry Zarou'
maintainer_email 'lzarou@commercehub.com'
license ''
description 'Installs/Configures a jenkins server designed for executing cookbook testing(sous_chef)'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version IO.read(File.join(File.dirname(__FILE__), 'VERSION')) rescue '0.1.0'

depends 'jenkins'
depends 'git'
depends 'build-essential'
depends 'apt'
