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
            emailext body:
                """<p>EXECUTE: Job <b>\'${env.JOB_NAME}:${env.BUILD_NUMBER})\'
                </b></p><p>View console output at "<a href="${env.BUILD_URL}">
                ${env.JOB_NAME}:${env.BUILD_NUMBER}</a>"</p>
                <p><i>(Build log is attached.)</i></p>""",
                compressLog: true,
                attachLog: true,
                recipientProviders: [culprits(), developers(), requestor(), brokenBuildSuspects()],
                replyTo: 'do-not-relply@alstru.com',
                subject: "Status: ${currentBuild.result?:'SUCCESS'} - Job \'${env.JOB_NAME}:${env.BUILD_NUMBER}\'",
                to: "xiaohu.ge@alstru.com"
        }
        always{
            dingTalk accessToken: "d3b2239bc0eb89d54e51036b8efeb048cb34fed80092d1ba1c3af5255b07c086", imageUrl: "https://www.alstru.com/wp-content/themes/aletheia/images/logo2.png", jenkinsUrl: 'https://jenkins.alstru.com', message: '代码质量审查项目', notifyPeople: 'XXX'
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
