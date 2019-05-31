FROM ruby:2.5.5-slim

ENV RAILS_ENV production

COPY . /var/www

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
# Fix brokenness in Debian slim image
# https://github.com/debuerreotype/debuerreotype/issues/10
  for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done &&\
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
  libgmp3-dev \
  libxml2-dev \
  libxslt1-dev \
  libssl-dev \
  imagemagick \
  ca-certificates \
  rsync &&\
# Add 'web' user which will run the application
  adduser web --home /home/web --shell /bin/bash --disabled-password --gecos "" &&\
# Init application dirs
  mkdir -p /var/bundle /var/www /var/www/docker /data/public &&\
  chown -R web:web /var/bundle /var/www /data &&\
# Install gems, precompile assets
  cd /var/www/ &&\
  find /var/www/docker -type f -name "*.sh" -print0 | xargs -0 chmod +x &&\
  chown -R web:web /var/www &&\
  cd /var/www/ &&\
  su-exec web bundle install --path /var/bundle --deployment --without development test deploy &&\
  su web -c 'cd /var/www && . /var/www/.env.docker-build && bundle exec rake assets:precompile' &&\
  rm -rf /var/www/tmp/* /var/www/log/* /home/web/.bundle/cache &&\
# Cleanup
  apt-get clean &&\
  apt-get remove --purge -y \
  apt-transport-https \
  wget \
  curl \
  libcurl4-openssl-dev \
  python-dev \
  python-setuptools \
  software-properties-common \
  gnupg \
  python-pip \
  git \
  libreadline-dev \
  zlib1g-dev \
  flex \
  bison \
  libxml2-dev \
  libxslt1-dev \
  rsync &&\
  apt-get -y autoremove &&\
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/fonts \
  /usr/share/doc/* /etc/fonts /root/.cache /usr/share/fontconfig \
  /usr/share/icons /usr/share/man

ENTRYPOINT ["/var/www/docker/entrypoint.sh"]
VOLUME /var/www
WORKDIR /var/www
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
