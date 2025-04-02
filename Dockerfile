FROM docker.m.daocloud.io/apache/airflow:2.10.5

# 切换到 root 用户
USER root

# 使用阿里云镜像加速 apt
RUN echo "deb https://mirrors.aliyun.com/debian/ bullseye main contrib non-free" > /etc/apt/sources.list \
 && echo "deb https://mirrors.aliyun.com/debian/ bullseye-updates main contrib non-free" >> /etc/apt/sources.list \
 && echo "deb https://mirrors.aliyun.com/debian-security bullseye-security main contrib non-free" >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    openjdk-11-jdk \
    wget \
    tar \
 && rm -rf /var/lib/apt/lists/* \
 && java -version

# 设置 JAVA_HOME
ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-arm64"
ENV PATH="$JAVA_HOME/bin:$PATH"

# 安装 Spark (假设已有 spark-3.5.5-bin-hadoop3.tgz 存在于阿里云镜像仓库)
ENV SPARK_VERSION=3.5.5
ENV HADOOP_VERSION=3
RUN wget -O /tmp/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    https://mirrors.aliyun.com/apache/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
 && tar xzf /tmp/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /opt \
 && mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark \
 && rm -f /tmp/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

ENV SPARK_HOME=/opt/spark
ENV PATH="$SPARK_HOME/bin:$PATH"

# 切换回 airflow 用户
USER airflow

# 拷贝自定义组件到容器
COPY airflow_alibaba_provider-0.0.3-py3-none-any.whl /tmp/
COPY emi_sdk-0.1.1b0-py3-none-any.whl /tmp/

# 安装 Python 依赖，均使用阿里云 PyPI 源
RUN pip install -i https://mirrors.aliyun.com/pypi/simple --no-cache-dir \
    pyspark \
    apache-airflow-providers-apache-spark==5.0.0 \
    requests \
    beautifulsoup4 \
    oss2 \
    /tmp/airflow_alibaba_provider-0.0.3-py3-none-any.whl \
    /tmp/emi_sdk-0.1.1b0-py3-none-any.whl










