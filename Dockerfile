# ARG BUILDER_IMAGE=ubuntu:22.04
# ARG TARGET_IMAGE=ubuntu:22.04
ARG BUILDER_IMAGE=ubuntu:24.04
ARG TARGET_IMAGE=ubuntu:24.04

FROM ${BUILDER_IMAGE} AS builder

# ARG GDAL_VERSION=3.10.3
ARG GDAL_VERSION=3.11.0

RUN apt-get update -y \
	&& apt-get upgrade -y \
	&& apt-get install -y \
 		build-essential \
		cmake \
		libproj-dev \
		libsqlite3-dev \
		librasterlite2-dev \
		libspatialite-dev \
		libpng-dev \
		libjpeg-dev \
		libgif-dev \
		libwebp-dev \
		libtiff-dev \
	&& apt-get -y --purge autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

ADD . .

RUN tar -xzf ./gdal-${GDAL_VERSION}.tar.gz \
	&& cd ./gdal-${GDAL_VERSION} \
	&& mkdir -p build \
	&& cd build \
	&& cmake .. \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_RPATH=/usr/local/opt/gdal \
		-DCMAKE_INSTALL_PREFIX=/usr/local/opt/gdal \
		-DCMAKE_INSTALL_LIBDIR=/usr/local/opt/gdal \
	&& cmake --build . \
	&& cmake --build . --target install \
 	&& cd ../.. \
 	&& rm -rf ./gdal-${GDAL_VERSION}*


FROM ${TARGET_IMAGE} AS final

# # ubuntu 22.04
# RUN apt-get update -y \
# 	&& apt-get install -y \
# 		libproj22 \
# 		libsqlite3-0 \
# 		librasterlite2-1 \
# 		libspatialite7 \
# 		libpng16-16 \
# 		libjpeg-turbo8 \
# 		libgif7 \
# 		libwebp7 \
# 		libtiff5 \
# 	&& apt-get -y --purge autoremove \
# 	&& apt-get clean \
# 	&& rm -rf /var/lib/apt/lists/*

# ubuntu 24.04
RUN apt-get update -y \
	&& apt-get install -y \
		libproj25 \
		libsqlite3-0 \
		librasterlite2-1 \
		libspatialite8 \
		libpng16-16 \
		libjpeg-turbo8 \
		libgif7 \
		libwebp7 \
		libtiff6 \
	&& apt-get -y --purge autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# # ubuntu 24.04 - osmosis
# RUN apt-get update -y \
# 	&& apt-get install -y \
# 		libproj25 \
# 		osmosis \
# 		libsqlite3-0 \
# 		librasterlite2-1 \
# 		libspatialite8 \
# 		libpng16-16 \
# 		libjpeg-turbo8 \
# 		libgif7 \
# 		libwebp7 \
# 		libtiff6 \
# 	&& apt-get -y --purge autoremove \
# 	&& apt-get clean \
# 	&& rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/opt /usr/local/opt

ENV PATH=/usr/local/opt/gdal/bin:${PATH}
