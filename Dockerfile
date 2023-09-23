FROM debian:bookworm-slim

RUN apt-get update -y
RUN apt-get install -y git build-essential cmake libz-dev libncurses-dev fish
RUN apt-get install -y postgresql postgresql-client