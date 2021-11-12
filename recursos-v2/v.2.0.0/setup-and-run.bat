set dockerhub_user=cbcarlos7

set jenkins_port=8080
set image_name=missao-devops-jenkins
set image_version=2.0.0
set container_name=md-jenkins
set home=C:/Users/Brito
docker pull jenkins:2.222.4

if not exist downloads (
    md downloads
    curl -o downloads/jdk-8u144-linux-x64.tar.gz http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/jdk-8u144-linux-x64.tar.gz
    curl -o downloads/jdk-7u80-linux-x64.tar.gz http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/jdk-7u80-linux-x64.tar.gz
    curl -o downloads/apache-maven-3.5.2-bin.tar.gz http://mirror.vorboss.net/apache/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz
)

docker stop %container_name%

docker build --no-cache -t %dockerhub_user%/%image_name%:%image_version% .

if not exist m2deps ](
    md m2deps
)

if  exist jobs (
    rmdir /s /q jobs
)
if not exist jobs (
    md jobs
)

docker run -p %jenkins_port%:8080 -v downloads:/var/jenkins_home/downloads -v jobs:/var/jenkins_home/jobs/ -v m2deps:/var/jenkins_home/.m2/repository/  -v %home%/.ssh:/var/jenkins_home/.ssh/ --rm --name %container_name%  %dockerhub_user%/%image_name%:%image_version%