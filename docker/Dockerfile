# Stage 1: Build stage
FROM node:20-alpine as build

USER root

# Skip downloading Chrome for Puppeteer (saves build time)
ENV PUPPETEER_SKIP_DOWNLOAD=true

# Install latest Flowise globally (specific version can be set: flowise@1.0.0)
RUN npm install -g flowise

# Stage 2: Runtime stage
FROM node:20-alpine

ARG UID=11132
ARG GID=11133

RUN addgroup -g $GID llm-adm && adduser -u $UID -G llm-adm --home $HOME --disabled-password llm-apps

# Install runtime dependencies
RUN apk add --no-cache chromium git python3 py3-pip make g++ build-base cairo-dev pango-dev

# Set the environment variable for Puppeteer to find Chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Copy Flowise from the build stage
COPY --from=build /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=build /usr/local/bin /usr/local/bin

USER $UID:$GID

ENTRYPOINT ["flowise", "start"]
