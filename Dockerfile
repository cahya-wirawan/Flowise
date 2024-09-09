# Build local monorepo image
# docker build --no-cache -t  flowise .

# Run image
# docker run -d -p 3000:3000 flowise


FROM node:20-alpine
ARG UID=11132
ARG GID=11133

RUN addgroup -g $GID llm-adm && adduser -u $UID -G llm-adm --home $HOME --disabled-password llm-apps

RUN apk add --update libc6-compat python3 make g++
# needed for pdfjs-dist
RUN apk add --no-cache build-base cairo-dev pango-dev

# Install Chromium
RUN apk add --no-cache chromium

#install PNPM globaly
RUN npm install -g pnpm

ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

ENV NODE_OPTIONS=--max-old-space-size=8192

WORKDIR /usr/src

# Copy app source
COPY . .

RUN pnpm install

RUN pnpm build

# RUN chown -R $UID:$GID /usr/src/packages/server

USER $UID:$GID

EXPOSE 3000

CMD [ "pnpm", "start" ]
