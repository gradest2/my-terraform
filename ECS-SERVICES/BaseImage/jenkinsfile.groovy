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
                 defaultValue: 'main',
                 useRepository: "https://github.com/gradest2/my-terraform"
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
          git branch: "${version}",
            //credentialsId: '12345-1234-4696-af25-123455',
            url: 'https://github.com/gradest2/my-terraform'
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
