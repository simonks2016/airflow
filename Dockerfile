FROM apache/airflow:2.10.5

# 切换到 root 用户
USER root
# 使用阿里云镜像加速 apt
RUN echo "deb https://mirrors.aliyun.com/debian/ bullseye main non-free contrib" > /etc/apt/sources.list && \
    apt update && apt install -y openjdk-11-jdk 

# 让 JAVA_HOME 在 Docker 运行时生效
ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-arm64"
ENV PATH="$JAVA_HOME/bin:$PATH"
# 验证 Java 是否安装成功
RUN java -version

# 切换回 airflow 用户
USER airflow

# 安装 Apache Airflow 及 Python 依赖
RUN pip install apache-airflow==2.10.5 -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install apache-airflow-providers-apache-spark==5.0.0 -i https://pypi.tuna.tsinghua.edu.cn/simple







