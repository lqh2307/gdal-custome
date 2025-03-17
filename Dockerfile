ARG BUILDER_IMAGE=ubuntu:24.04
ARG TARGET_IMAGE=ubuntu:24.04

FROM ${BUILDER_IMAGE} AS builder

RUN apt-get update -y \
	&& apt-get upgrade -y \
	&& apt-get install -y \
		libproj-dev \
	&& apt-get -y --purge autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

ADD . .

RUN tar -xzf ./gdal-3.10.2.tar.gz \
	&& rm -rf ./gdal-3.10.2.tar.gz \
	&& cd ./gdal-3.10.2 \
	&& mkdir -p build \
	&& cd build \
	&& cmake .. -DCMAKE_BUILD_TYPE=Release \
	&& cmake --build . \
	&& cmake --build . --target install

RUN ldconfig


FROM ${TARGET_IMAGE} AS final

RUN apt-get update -y \
	&& apt-get install -y \
		libproj25 \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local /usr/local

RUN ldconfig

WORKDIR /data
VOLUME /data

CMD ["gdalinfo", "--version"]
