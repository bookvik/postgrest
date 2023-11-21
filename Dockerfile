FROM haskell:latest as builder

ARG UNAME=deployer
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME
RUN apt update
RUN apt install -y libpq-dev libgmp-dev zlib1g-dev

USER $UNAME

RUN export PATH=$PATH:/home/deployer/.bin/

WORKDIR /home/$UNAME

RUN mkdir .bin

ENV PATH="$PATH:/home/deployer/.bin"

COPY --chown=$UNAME . postgrest

WORKDIR /home/deployer/postgrest

RUN stack build --install-ghc --copy-bins --local-bin-path /home/deployer/.bin
