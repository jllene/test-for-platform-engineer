# test-for-platform-engineer

This project is to setup the infrastructure in AWS, which including VPC, ALB, ECS, Redis and S3. It can be deployed to dev/test/perf/stg/prod by Jenkins.

├── Jenkinsfile       
├── Dockerfile
├── app.py
└── terraform/
    ├── dev/
    ├── test/
    ├── perf/
    ├── stage/
    ├── prod/
    └── infra/

app.py, python based Application
Dockerfile, to build the docker image
Jenkinsfile, a Jenkins pipeline to deploy the infra from docker build, push to artifactory and trigger terraform to deploy the infra to AWS.
terraform, 
	AWS infrastructures defined in infra/ folder
	dev/, test/, perf/, stage/ and prod/ are terraform code which will deploy infras to aws for different environment.