ARG BUILDER_IMAGE=debian:bookworm
ARG TARGET_IMAGE=debian:bookworm

FROM ${BUILDER_IMAGE} AS builder

RUN apt-get update -y \
	&& apt-get upgrade -y \
	&& apt-get install -y \
		build-essential \
		cmake \
    libproj-dev \
    libcurl4-gnutls-dev \
    libpng-dev \
    libjpeg-dev \
    libgif-dev \
    liblzma-dev \
    libzstd-dev \
    libwebp-dev \
    libgeos-dev \
    libsqlite3-dev \
    libpq-dev \
    libxml2-dev \
    libexpat1-dev \
    libxerces-c-dev \
    libnetcdf-dev \
    libpoppler-dev \
    libspatialite-dev \
    libhdf4-alt-dev \
    libhdf5-dev \
    libopenexr-dev \
    libkealib-dev \
    libjasper-dev \
    libmysqlclient-dev \
    libogdi-dev \
    libcfitsio-dev \
    libpodofo-dev \
    swig \
    python3-dev \
    python3-numpy \
    openjdk-17-jdk \
    libfreexl-dev \
    libgeotiff-dev \
    libcharls-dev \
    libopenjp2-7-dev \
    libkml-dev \
    libarmadillo-dev \
    libepsilon-dev \
    libheif-dev \
    libjxl-dev \
    libbrotli-dev && \
	&& apt-get -y --purge autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /gdal-3.10.2

ADD . .

RUN tar -xf ./gdal-3.10.2.tar.xz \
	&& rm -rf ./gdal-3.10.2.tar.xz \
	&& cd ./gdal-3.10.2 \
	&& mkdir -p build \
	&& cd build \
	&& cmake .. -DCMAKE_BUILD_TYPE=Release \
	&& cmake --build . \
	&& cmake --build . --target install


FROM ${TARGET_IMAGE} AS final

RUN apt-get update -y \
	&& apt-get install -y \
		libproj22 \
		libcurl4 \
		libpng16-16 \
		libjpeg62-turbo \
		libgif7 \
		liblzma5 \
		libzstd1 \
		libwebp7 \
		libgeos3.11.2 \
		libsqlite3-0 \
		libpq5 \
		libxml2 \
		libexpat1 \
		libxerces-c3.2 \
		libnetcdf19 \
		libpoppler123 \
		libspatialite7 \
		libhdf4-0-alt \
		libhdf5-103-1 \
		libopenexr25 \
		libkealib1.4.15 \
		libjasper6 \
		libmysqlclient21 \
		libogdi4.1 \
		libcfitsio9 \
		libpodofo0.9.8 \
		python3 \
		python3-numpy \
		openjdk-17-jre \
		libfreexl1 \
		libgeotiff5 \
		libcharls2 \
		libopenjp2-7 \
		libkmlbase1 \
		libarmadillo11 \
		libepsilon1 \
		libheif1 \
		libjxl0.7 \
		libbrotli1 && \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local /usr/local

WORKDIR /data
VOLUME /data

CMD ["gdalinfo", "--version"]
