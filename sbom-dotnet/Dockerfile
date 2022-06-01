FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
RUN yum -y update \
    && apt-get -y update \
    && apt-get -y install git
RUN git clone https://github.com/dotnet/project-system.git

