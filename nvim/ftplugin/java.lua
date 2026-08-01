-- Start jdtls for Java in Gradle/Maven projects (root has gradlew, mvnw, build.gradle, pom.xml, etc.).
local config = require("jdtls_config").build_config()
if config then
  require("jdtls").start_or_attach(config)
end
