pipeline {
    agent any 

    environment {
        AWS_DEFAULT_REGION = 'eu-west-1'
		AWS_REGION = "eu-west-1"
        
    }

    parameters {
        string(name: 'BUCKET_NAME', defaultValue: '', description: 'Specify a bucket name' )
        choice(name: 'S3_MANAGEMENT', choices: ['list_buckets', 'update', 'delete'], description: 'Manage S3')
    }



    options {
		buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
		disableConcurrentBuilds()
		// timestamps()
		// timeout 240 // minutes
		//ansiColor('xterm')
		// skipDefaultCheckout()
    }

    stages {
        stage('CRUD: CREATE'){
            // when {
            //     expression { params.CREATE_BUCKET != '' }
            // }
            steps {
                script{
                    if( params.BUCKET_NAME != null && params.BUCKET_NAME != ''){
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                            credentialsId: 'dm_aws_keys',
                            accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]) {
                            wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
                                dir('./terraform/s3_buck'){
                                    sh "terraform init"
                                    sh "terraform fmt"
                                    sh "terraform plan"
                                    sh "terraform apply -auto-approve -var 'bucket_name=${params.BUCKET_NAME}'"
                                }
                            } 
                        }
                    }  else {
                        sh "echo 'no buckets to create'"
                    }
                }
            }
        }

        stage('LS BUCKETS'){
			agent { docker { image 'simonmcc/hashicorp-pipeline:latest'}}
            when {
                expression { 
                    params.S3_MANAGEMENT == 'list_buckets' 
                }
            }
            steps {
                checkout scm 
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
					credentialsId: 'dm_aws_keys',
					accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
					secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
				]]) {
					wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
							sh "aws s3 ls --region ${env.AWS_REGION}"
					} 
				}
            }
        }

        stage('UPDATE BUCKET POLICY'){
			agent { docker { image 'simonmcc/hashicorp-pipeline:latest'}}
            when {
                expression { 
                    params.S3_MANAGEMENT == 'list_buckets' 
                }
            }
            steps {
                checkout scm 
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
					credentialsId: 'dm_aws_keys',
					accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
					secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
				]]) {
					wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
							sh "echo 'Modifying Policies'"
					} 
				}
            }
        }

        stage('DELETE BUCKET'){
			agent { docker { image 'simonmcc/hashicorp-pipeline:latest'}}
            when {
                expression { 
                    params.S3_MANAGEMENT == 'list_buckets' 
                }
            }
            steps {
                checkout scm 
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
					credentialsId: 'dm_aws_keys',
					accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
					secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
				]]) {
					wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
							sh "echo 'Deleting Bucket'"
					} 
				}
            }
        }
    }
  
}