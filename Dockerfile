# Build local monorepo image
# docker build --no-cache -t flowise .

# Run image
# docker run -d -p 3000:3000 flowise

FROM node:20-alpine

RUN apk add --update libc6-compat python3 make g++
# Needed for pdfjs-dist
RUN apk add --no-cache build-base cairo-dev pango-dev
# Install Chromium
RUN apk add --no-cache chromium

# Install PNPM globally
RUN npm install -g pnpm

ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

ENV NODE_OPTIONS=--max-old-space-size=8192

WORKDIR /usr/src

# Copy app source
COPY . .

RUN pnpm install
RUN pnpm build

EXPOSE 3000

CMD ["npx", "flowise", "start", \
    "--FLOWISE_USERNAME=avengers", \
    "--FLOWISE_PASSWORD=SoyaBotol69", \
    "--CORS_ORIGINS=*", \
    "--IFRAME_ORIGINS=*", \
    "--DATABASE_TYPE=postgres", \
    "--DATABASE_HOST=admin.soluvion.com", \
    "--DATABASE_PORT=5432", \
    "--DATABASE_USER=flowise", \
    "--DATABASE_PASSWORD=flowise", \
    "--DATABASE_NAME=flowise", \
    "--DATABASE_SSL=false", \
    "--DATABASE_SSL_KEY_BASE64=false"]
