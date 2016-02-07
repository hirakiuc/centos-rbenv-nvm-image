FROM centos:7
MAINTAINER hirakiuc

RUN yum -y update \
  && yum -y install make tar git gcc-c++ openssl-devel readline-devel gdbm-devel libffi-devel zlib-devel curl-devel bzip2 \
  && yum clean all

# Install rbenv, ruby-build, rbenv-default-gems
RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv \
  && git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build \
  && git clone https://github.com/sstephenson/rbenv-default-gems.git /root/.rbenv/plugins/rbenv-default-gems \
  && /root/.rbenv/plugins/ruby-build/install.sh \
  && echo 'bundler' >> /root/.rbenv/default-gems \
  && echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh \
  && echo 'eval "$(rbenv init -)"' >> .bashrc \
  && echo 'gem: --no-rdoc --no-ri' >> /root/.gemrc
ENV PATH /root/.rbenv/bin:$PATH
ENV CONFIGURE_OPTS --disable-install-doc

# Install ruby 2.2.0 by rbenv
RUN rbenv install 2.2.0 && rbenv global 2.2.0
ENV PATH /root/.rbenv/shims:$PATH

# Install node.js 5.0.1 by nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.30.2/install.sh | NVM_DIR='/usr/local/nvm' bash \
  && echo 'source /usr/local/nvm/nvm.sh' >> /etc/profile.d/nvm.sh \
  && . /usr/local/nvm/nvm.sh \
  && nvm install v5.1.1 \
  && nvm alias default v5.1.1

