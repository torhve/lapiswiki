#
# Dockerfile for lapis
#
# VERSION   0.0.3


FROM torhve/openresty
MAINTAINER Tor Hveem <tor@hveem.no>
ENV REFRESHED_AT 2013-12-12

RUN    apt-get -y install luarocks

# Need dev version of lapis until leafo cuts a new release
RUN    luarocks install http://github.com/leafo/lapis/raw/master/lapis-dev-1.rockspec
RUN    luarocks install --server=http://rocks.moonscript.org/manifests/leafo moonscript

EXPOSE 8080
CMD lapis server production



