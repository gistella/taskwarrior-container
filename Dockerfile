FROM registry.access.redhat.com/ubi8/ubi-minimal:8.6 AS builder

ARG TW_RELEASE=2.6.2

RUN microdnf install --disableplugin=subscription-manager \
	tar \
	gzip \
	gcc \
	gcc-c++ \
	libuuid-devel \
	cmake \
	make

RUN curl \
	--disable \
	--location \
	--remote-name \
	https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v${TW_RELEASE}/task-${TW_RELEASE}.tar.gz

RUN tar xzf task-${TW_RELEASE}.tar.gz && \
	cd task-${TW_RELEASE} && \
	cmake \
		-DCMAKE_BUILD_TYPE=release \
		-DENABLE_SYNC=OFF . && \
	make && \
	make install

FROM registry.access.redhat.com/ubi8/ubi-minimal:8.6

ARG TW_RELEASE=2.6.2

VOLUME /taskwarrior

COPY --from=builder /usr/local/bin/task /usr/local/bin/task
COPY --from=builder task-${TW_RELEASE}/doc/man/*.1 /usr/local/share/man/man1/
COPY --from=builder task-${TW_RELEASE}/doc/man/*.5 /usr/local/share/man/man5/

RUN microdnf install man && mandb

ENTRYPOINT ["/usr/local/bin/task", "rc:/taskwarrior/.taskrc"]
