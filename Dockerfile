FROM centos:centos8

#SETUP
RUN cd /etc/yum.repos.d/ \
    && sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* \
    && yum -y update \
    && yum -y install icu \
    && dnf -y install npm git java-11-openjdk-devel \
    && dnf module reset nodejs -y \
    && dnf module install nodejs:12 -y 

#Install syft
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin

#Install cyclonedx-cli
COPY cyclonedx-cli/bin/linux-x64/cyclonedx /cyclonedx

ADD https://github.com/tomnomnom/gron/releases/download/v0.6.1/gron-linux-amd64-0.6.1.tgz /tmp/gron.tgz

#install maven
RUN yum install wget \
    && wget http://mirror.olnevhost.net/pub/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz \
    && tar xvf apache-maven-3.0.5-bin.tar.gz \
    && rm -rf apache-maven-3.0.5-bin.tar.gz  \
    && mv apache-maven-3.0.5  /usr/local/apache-maven \
    && export M2_HOME=/usr/local/apache-maven \
    && export M2=$M2_HOME/bin \
    && export PATH=$M2:$PATH \
    && source ~/.bashrc

RUN tar xzf /tmp/gron.tgz \
    && mv ./gron /usr/local/bin/ \
    && rm /tmp/gron.tgz

#Install @cyclonedx/bom
RUN npm install -g @cyclonedx/bom

#Install cyclonedx-core-java
RUN git clone https://github.com/CycloneDX/cyclonedx-core-java

#Install cyclonedx-python-lib/
RUN dnf install python3 -y \
    && yum  install python3-pip -y \
    && pip3 install cyclonedx-python-lib

#Install CycloneDX
RUN dnf install dotnet-sdk-5.0 -y \
    && dnf install aspnetcore-runtime-5.0 -y \
    && dnf install dotnet-runtime-5.0 -y \
    && dotnet tool install --global CycloneDX --version 2.3.0 \
    && echo '# Add .NET Core SDK tools' >> ~/.bash_profile  \
    && echo 'export PATH="$PATH:/root/.dotnet/tools"' >> ~/.bash_profile 

#RUN mkdir sbom_java
#ENTRYPOINT [ "/cyclonedx" ]
