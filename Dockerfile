# Stage 1: Build image
FROM ubuntu:noble-20241118.1 AS build

RUN apt-get update && \
    apt-get install -y autoconf && \
    apt-get install -y build-essential flex bison && \
    apt-get install -y pkg-config libtirpc-dev


WORKDIR /unfs3

COPY . .

RUN ./bootstrap && ./configure && make

# Stage 2: Create the runtime image
FROM ubuntu:noble-20241118.1

WORKDIR /unfs3

RUN apt-get update && \
    apt-get install -y nfs-common && \
    apt-get install -y libtirpc-dev

COPY --from=build /unfs3/unfsd .

CMD ["/unfs3/unfsd"]
