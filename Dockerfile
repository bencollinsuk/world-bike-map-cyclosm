FROM ubuntu:bionic

# Style dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    ca-certificates \
    curl \
    fonts-hanazono \
    fonts-noto-cjk \
    fonts-noto-hinted \
    fonts-noto-unhinted \
    gnupg \
    gnupg \
    mapnik-utils \
    nodejs \
    npm \
    postgresql-client \
    postgresql-client \
    python \
    python \
    ttf-unifont \
    unzip && \
    rm -rf /var/lib/apt/lists/*


# Kosmtik with plugins, forcing prefix to /usr because bionic sets
# npm prefix to /usr/local, which breaks the install
RUN npm set prefix /usr && npm install -g kosmtik

WORKDIR /usr/lib/node_modules/kosmtik/
RUN kosmtik plugins --install kosmtik-overpass-layer \
                    --install kosmtik-fetch-remote \
                    --install kosmtik-overlay \
                    --install kosmtik-open-in-josm \
                    --install kosmtik-map-compare \
                    --install kosmtik-osm-data-overlay \
                    --install kosmtik-mapnik-reference \
                    --install kosmtik-geojson-overlay \
    && cp /root/.config/kosmtik.yml /tmp/.kosmtik-config.yml

# Closing section
RUN mkdir -p /cyclosm
WORKDIR /cyclosm

USER 1000
CMD sh scripts/docker-startup.sh kosmtik
