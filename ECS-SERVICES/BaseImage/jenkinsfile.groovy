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
                 defaultValue: 'master',
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
    stage('Push image to AWS ECR') {
      steps {
        script {
          sh("echo 'Pushing to ECR repo: ${project}:${version}'")
          sh('curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
              unzip awscliv2.zip && \
              ./aws/install && \
              rm -rf awscliv2*')
          sh ("aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin 901576725721.dkr.ecr.eu-central-1.amazonaws.com")
          sh("docker push ${project}:${version}")
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
