#!/usr/bin/env groovy

pipeline {
    agent any

    tools {
        maven 'maven'
        jdk 'jdk1.8'
    }

    stages {
        stage('Build') {
            steps {
                sh "printenv"
                sh "mvn clean test package spring-boot:repackage"

            }
        }
        
        stage('pmd') {
            steps {
                sh "mvn pmd:pmd"
            }
        }

    }
    
    
    post {
        failure{
            mail body: 'failure body', from: 'cicd@alstru.com', subject: 'build status', to: 'xiaohu.ge@alstru.com'
        }
        always{
            pmd(canRunOnFailed: true, pattern: '**/target/pmd.xml')
//            junit 'target/surefire-reports/**/*.xml'
            junit(testResults: '**/target/surefire-reports/**/*.xml')
            jacoco(
                    execPattern: 'target/**/*.exec',
                    classPattern: 'target/classes',
                    sourcePattern: 'src/main/java',
                    exclusionPattern: 'src/test*',
                    buildOverBuild: true,
                    changeBuildStatus: true,
                    deltaLineCoverage: '69',
                    minimumLineCoverage:'0',
                    maximumLineCoverage: '61'
            )
            
           script {
            allure([
                    includeProperties: false,
                    jdk: '',
                    properties: [],
                    reportBuildPolicy: 'ALWAYS',
                    results: [[path: 'target/allure-results']]
                ])
            }
            

        }

    }
}
