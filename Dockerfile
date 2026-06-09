# Base image pinned by a mutable tag rather than an immutable @sha256 digest.
# A registry-side re-push of node:20-alpine would silently change this build.
# (ISSUE-706, medium.)
FROM node:20-alpine

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY dist ./dist

USER node
ENTRYPOINT ["node", "dist/cli.js"]
