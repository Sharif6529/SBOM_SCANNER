FROM maven:3.8.5-jdk-8

RUN git clone https://github.com/ja-netfilter/ja-netfilter.git

ENTRYPOINT ["/bin/bash", "cd /ja-netfilter && mvn clean compile"]