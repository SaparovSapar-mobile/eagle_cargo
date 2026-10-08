allprojects {
    repositories {
        google()
        mavenCentral()
    }

    // The integration_test plugin declares its AndroidX test deps as dynamic
    // versions ("1.2+", "3.2+"), so every build has to fetch maven-metadata.xml
    // to pick a version. Pin them to the versions we already resolve to, so
    // debug builds work from the Gradle cache without network access.
    configurations.all {
        resolutionStrategy.eachDependency {
            if (requested.version?.endsWith("+") == true) {
                when ("${requested.group}:${requested.name}") {
                    "androidx.test:runner" -> useVersion("1.2.0")
                    "androidx.test:rules" -> useVersion("1.2.0")
                    "androidx.test.espresso:espresso-core" -> useVersion("3.2.0")
                }
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
