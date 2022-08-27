pipeline {

  agent {
      docker {
        image 'docker:latest'
        args '-u root --privileged'
      }
    }

  parameters {
    //Choose application branch
    gitParameter name: 'TAG',
                 type: 'PT_BRANCH_TAG',
                 defaultValue: 'ECS-CLUSTER',
                 useRepository: "https://github.com/FaztTech/nodejs-mysql-links"
  }

  environment {
    project = "baseimage"
    version = "latest"
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
          sh "docker build -t '${project}:${version}' ."
        }
      }
    }
  }


  post {
    always {
      cleanWs()
    }
    failure {
      sh "echo 'FAILED'"
    }
  }
}
