FROM sstarcher/sensu:1.4.3

# Fix Vulnerabilities
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       curl=7.52.1-5+deb9u8 \
       libcurl3=7.52.1-5+deb9u8 \
       libcurl3-gnutls=7.52.1-5+deb9u8 \
       perl=5.24.1-3+deb9u5 \
       network-manager=1.6.2-3+deb9u2 \
       libidn2-0=0.16-1+deb9u1 \
    && rm -rf /var/lib/apt/lists/*

# Enable Embedded Ruby
RUN sed -i -r 's/EMBEDDED_RUBY=false/EMBEDDED_RUBY=true/' /etc/default/sensu

# Install Mailer 2.5.4
RUN /opt/sensu/embedded/bin/gem install mail --version 2.5.4
RUN /opt/sensu/embedded/bin/gem install aws-ses

# Bake config & checks in
COPY resources/conf.d/* /etc/sensu/conf.d/
COPY resources/check.d/ /etc/sensu/check.d/
COPY resources/handlers/* /etc/sensu/handlers/
COPY resources/plugins /etc/sensu/plugins/
RUN chmod -R +x /etc/sensu/plugins
