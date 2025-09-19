ARG BUILDER_IMAGE=ubuntu:24.04
ARG TARGET_IMAGE=ubuntu:24.04

FROM ${BUILDER_IMAGE} AS osmium-tool-builder

ARG PREFIX_DIR=/usr/local/opt

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y \
	&& apt-get upgrade -y \
	&& apt-get install -y \
      build-essential \
      cmake \
			nlohmann-json3-dev \
			libboost-program-options-dev \
			libbz2-dev \
			zlib1g-dev \
			libexpat1-dev \
			liblz4-dev \
			libosmium2-dev \
			libprotozero-dev \
  && luarocks install luaflock \
	&& apt-get -y --purge autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY ./osmium-tool/osmium-tool.tar.gz .

RUN tar -xzf ./osmium-tool.tar.gz \
	&& cd ./osmium-tool \
  && mkdir -p ./build \
  && cd ./build \
  && cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${PREFIX_DIR}/osmium-tool \
  && cmake --build . --parallel $(nproc) \
  && cmake --build . --target install \
  && cd ../.. \
  && rm -rf ./osmium-tool*


FROM ${TARGET_IMAGE} AS final

ARG PREFIX_DIR=/usr/local/opt

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y \
	&& apt-get install -y \
		nlohmann-json3-dev \
    libboost-program-options1.83.0 \
		libbz2-1.0 \
		zlib1g \
		libexpat1 \
		liblz4-1 \
		libosmium2-2 \
		libprotozero0 \
	&& apt-get -y --purge autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=osmium-tool-builder ${PREFIX_DIR} ${PREFIX_DIR}

ENV PATH=${PREFIX_DIR}/osmium-tool/bin:${PATH}

VOLUME /data

WORKDIR /data
