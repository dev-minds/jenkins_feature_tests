@Library('jk_shared_lib@master') _

pipeline {
    agent any 
    
    parameters {
        choice(name: 'AWS_ACCT', choices: ['dm_acct', 'phelun_acct'], description: 'Specify target account')
        string(name: 'BUCKET_NAME', defaultValue: '', description: 'Specify a bucket name' )
        choice(name: 'S3_MANAGEMENT', choices: ['list_buckets', 'update', 'delete'], description: 'Manage S3')
    }

    environment {
        AWS_DEFAULT_REGION = 'eu-west-1'
		AWS_REGION = "eu-west-1"
        TG_BUCKET_PREFIX = "dm-acct"
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
        stage('TG WORKS'){
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
                            dir("./tg_test/${params.AWS_ACCT}"){
                                sh ""
							    sh "terragrunt apply-all -auto-approve --terragrunt-non-interactive"
                            }
					} 
				}
            }
        }

        stage('CRUD: CREATE'){
            // when {
            //     expression { params.CREATE_BUCKET != '' }
            // }
            
            steps {
                script{
                    if( params.BUCKET_NAME == ''){
                        sh "echo 'no buckets to create'"
                    }  else {
                        deleteDir() 
                        checkout scm
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                            credentialsId: 'dm_aws_keys',
                            accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]) {
                            wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
                                dir('./terraform/s3_buck'){
                                    // sh "terraform init"
                                    // sh "terraform fmt"
                                    // sh "terraform plan "
                                    // sh "terraform apply -auto-approve -var 'bucket_name=${params.BUCKET_NAME}' "    
                                    sh "echo 'TESTING'"                            }
                            } 
                        }                    
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
    post {
        always {
            echo 'One way or another, I have finished'
            deleteDir() /* clean up our workspace */
        }
		// success {
		// 	slackSend baseUrl: 'https://xxxxxxxxxxxxhhhhjjk/services/hooks/jenkins-ci/', channel: '#ci', tokenCredentialId: 'slack', color: 'good', message: ":terraform: Terraform pipeline *finished successfully* :white_check_mark:\n>*Service:* `${env.UPSTREAM}` \n>*Account:* `${env.ACCOUNT}` \n>*Version*: `${env.VERSION}` \n>*ami-id*: `${env.AMIID}`\n>*Duration*: ${currentBuild.durationString.replaceAll('and counting','')}"
		// }
		// failure {
		// 	slackSend baseUrl: 'https://xxxxxxxxxxnjhdjjjjj/services/hooks/jenkins-ci/', channel: '#ci', tokenCredentialId: 'slack', color: 'danger', message: ":terraform: Terraform pipeline *failed* :x:\n>*Service:* `${env.UPSTREAM}` \n>*Account:* `${env.ACCOUNT}` \n>*Version*: `${env.VERSION}` \n>*ami-id*: `${env.AMIID}`  \n>*Duration*: ${currentBuild.durationString.replaceAll('and counting','')}"
		// }
    }
  
}