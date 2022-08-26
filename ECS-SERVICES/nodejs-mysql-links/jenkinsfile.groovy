pipeline {

  // agent {
  //     docker {
  //       image 'docker:latest'
  //       args '-u root --privileged'
  //     }
  //   }

  agent any;
  parameters {
    //Choose application branch
    gitParameter name: 'TAG',
                 type: 'PT_BRANCH_TAG',
                 defaultValue: 'master',
                 useRepository: "https://github.com/FaztTech/nodejs-mysql-links"
  }

  environment {
    project = "nodejs-mysql-links"
    version = "${TAG}".toLowerCase().replaceAll("origin/", "")
  }
  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
  }

  stages {
    stage('Build') {
      steps {
        script {
          git branch: "${version}",
            //credentialsId: '12345-1234-4696-af25-123455',
            url: 'https://github.com/FaztTech/nodejs-mysql-links'
          sh "docker build -t '${project}:${version}' ."
          // def image = docker.image("${project}:${version}")
          //    image.inside {
          //      sh "cp /dist/gameHeroes ${WORKSPACE}"
          //      sh "cp /data.yaml ${WORKSPACE}"
          //    }
          // sh "tar -czvf ${project}_${version}.tar.gz gameHeroes data.yaml"
          // archiveArtifacts "gameHeroes, data.yaml, ${project}_${version}.tar.gz"
        }
      }
    }
  }

  post {
    always {
      cleanWs()
    }
    success {
      sh "docker rmi -f \$(docker image ls --quiet --filter 'reference=${project}:${version}') || true"
    }
    failure {
      sh "echo 'FAILED'"
    }
  }
}
