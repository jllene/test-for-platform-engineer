# test-for-platform-engineer

This project is to setup the infrastructure in AWS, which including VPC, ALB, ECS, Redis and S3. It can be deployed to dev/test/perf/stg/prod by Jenkins.

├── Jenkinsfile       
├── Dockerfile      
├── app.py      
├── terraform/      
&emsp;&emsp;├── dev/      
&emsp;&emsp;├── test/      
&emsp;&emsp;├── perf/      
&emsp;&emsp;├── stage/      
&emsp;&emsp;├── prod/      
&emsp;&emsp;├── infra/      

app.py, python based Application<br>
Dockerfile, to build the docker image<br>
Jenkinsfile, a Jenkins pipeline to deploy the infra from docker build, push to artifactory and trigger terraform to deploy the infra to AWS.<br>
terraform/, <br>
&emsp;AWS infrastructures defined in infra/ folder<br>
&emsp;dev/, test/, perf/, stage/ and prod/ are terraform code which will deploy infras to aws for different environment.
