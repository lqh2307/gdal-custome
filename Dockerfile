ARG BUILDER_IMAGE=ubuntu:24.04
ARG TARGET_IMAGE=ubuntu:24.04
# ARG BUILDER_IMAGE=debian:bookworm
# ARG TARGET_IMAGE=debian:bookworm

FROM ${BUILDER_IMAGE} AS builder

ARG GDAL_VERSION=3.10.2

RUN apt-get update -y \
	&& apt-get upgrade -y \
	&& apt-get install -y \
 		build-essential \
   		cmake \
		libproj-dev \
	&& apt-get -y --purge autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

ADD . .

RUN tar -xzf ./gdal-${GDAL_VERSION}.tar.gz \
	&& cd ./gdal-${GDAL_VERSION} \
	&& mkdir -p build \
	&& cd build \
	&& cmake .. -DCMAKE_BUILD_TYPE=Release \
	&& cmake --build . \
	&& cmake --build . --target install \
 	&& cd ../.. \
 	&& rm -rf ./gdal-${GDAL_VERSION}*


FROM ${TARGET_IMAGE} AS final

RUN apt-get update -y \
	&& apt-get install -y \
		libproj25 \
		osmosis \
	&& apt-get -y --purge autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local /usr/local

VOLUME /data
