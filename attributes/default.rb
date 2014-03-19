default[:flyway][:version] = "2.3"
default[:flyway][:installation_path] = "/opt/flyway"
default[:flyway][:jdbc_url] = "jdbc:postgresql://localhost:5432/database"
default[:flyway][:jdbc_username] = ""
default[:flyway][:jdbc_password] = ""
default[:flyway][:jdbc_driver][:postgresql][:version] = "9.3-1100-jdbc4"
default[:flyway][:jdbc_driver][:mysql][:version] = "5.1.28"
default[:flyway][:init_on_migrate] = "false"
default[:flyway][:include_java_recipe] = true


default[:flyway][:version_installed] = "0"
default[:flyway][:base_url] = "http://repo1.maven.org/maven2/com/googlecode/flyway/flyway-commandline/VERSION/flyway-commandline-VERSION.tar.gz"
default[:flyway][:jdbc_driver][:postgresql][:url] = "http://search.maven.org/remotecontent?filepath=org/postgresql/postgresql/VERSION/postgresql-VERSION.jar"
default[:flyway][:jdbc_driver][:mysql][:url] = "http://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/VERSION/mysql-connector-java-VERSION.jar"
