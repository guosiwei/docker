# FROM python:3.8.5

# RUN pip --no-cache-dir install hanlp

# RUN pip install jupyterlab

# WORKDIR /jupyter

# EXPOSE 8888

# CMD ["bash", "-c", "jupyter lab --notebook-dir=/jupyter --ip 0.0.0.0 --no-browser --allow-root"]
# 使用官方的 Alpine Linux 镜像作为基础镜像
FROM nginx

# 安装必要的工具和库
RUN apk update && \
    apk add --no-cache build-base pcre-dev zlib-dev openssl-dev git

# 设置工作目录
WORKDIR /usr/src/app

# 获取 nginx-http-flv-module 模块
RUN git clone https://github.com/winshining/nginx-http-flv-module.git

# 下载特定版本的 Nginx 源码
RUN wget https://nginx.org/download/nginx-1.24.0.tar.gz && \
    tar -xzf nginx-1.24.0.tar.gz && \
    rm nginx-1.24.0.tar.gz

# 进入到 nginx 源码目录
WORKDIR nginx-1.24.0

# 配置 nginx 编译选项，添加 flv module 支持
RUN ./configure --add-module=/usr/src/app/nginx-http-flv-module \
                --with-http_ssl_module \
                --with-stream \
                --with-stream_ssl_module

# 编译并安装 nginx
RUN make && make install

# 更改工作目录回到根目录
WORKDIR /

# 替换默认的 nginx 配置文件
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露端口
EXPOSE 80 8002

# 启动 nginx 服务
CMD ["nginx", "-g", "daemon off;"]
