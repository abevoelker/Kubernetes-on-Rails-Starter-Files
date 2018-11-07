FROM ruby:2.5-slim

ENV RAILS_ENV production

# Install build dependencies
RUN set -ex &&\
  apt-get update &&\
  apt-get install -y --no-install-recommends \
  sudo \
  wget \
  curl \
  build-essential \
  libcurl4-openssl-dev \
  python-dev \
  python-setuptools \
  software-properties-common \
  gnupg \
  python-pip \
  git \
  file \
  brotli &&\
# Python libs
  pip install python-magic &&\
# Node 10.x
  curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - &&\
# Yarn
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - &&\
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list &&\
# Install su-exec
  cd /tmp &&\
  wget -O su-exec-0.2.tar.gz https://github.com/ncopa/su-exec/archive/v0.2.tar.gz &&\
  tar -xzvf su-exec-0.2.tar.gz &&\
  cd su-exec-0.2/ &&\
  make &&\
  cp -a su-exec /usr/bin/ &&\
# Update apt cache with PPAs and install Node and Ruby app dependencies
  apt-get clean &&\
  apt-get update &&\
  apt-get install -y --no-install-recommends \
  nodejs \
  yarn \
  libpq-dev \
  postgresql-client-9.6 \
  libreadline-dev \
  zlib1g-dev \
  flex \
  bison \
  libxml2-dev \
  libxslt1-dev \
  libssl-dev \
  imagemagick \
  ca-certificates \
  rsync &&\
# Remove build dependencies, clean up APT and temp files
  apt-get clean &&\
  apt-get remove --purge -y wget curl &&\
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
# Add 'web' user which will run the application
  adduser web --home /home/web --shell /bin/bash --disabled-password --gecos ""

COPY Gemfile* /var/www/
RUN \
  mkdir -p /var/www/docker &&\
  echo "export PATH=\"\$PATH:/opt/rubies/ruby-$BUILD_RUBY_VERSION/bin\"" > /var/www/docker/ruby-path.sh &&\
  chmod +x /var/www/docker/ruby-path.sh &&\
  mkdir -p /var/bundle &&\
  chown -R web:web /var/bundle &&\
  chown -R web:web /var/www &&\
  mkdir -p /data/public &&\
  chown -R web:web /data

USER web

RUN cd /var/www &&\
  . /var/www/docker/ruby-path.sh &&\
  bundle install --path /var/bundle --deployment --without development test deploy

# Add application source
USER root
COPY . /var/www
RUN cd /var/www/ &&\
  find /var/www/docker -type f -name "*.sh" -print0 | xargs -0 chmod +x &&\
  chown -R web:web /var/www

# Precompile assets and cleanup
USER web
RUN cd /var/www &&\
  . /var/www/docker/ruby-path.sh &&\
  . /var/www/.env.docker-build &&\
  bundle exec rake assets:precompile &&\
  rm -rf /var/www/tmp/* /var/www/log/*

USER root
ENTRYPOINT ["/var/www/docker/docker-entrypoint.sh"]

VOLUME /var/www

WORKDIR /var/www

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
