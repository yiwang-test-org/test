# Inventory fixture: a non Docker Hub registry and a scratch stage.
FROM public.ecr.aws/docker/library/node:24-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

FROM scratch AS artifacts
COPY --from=build /app/node_modules /node_modules

FROM node:24-alpine@sha256:06d7adf3e0ef61a13f1d28682726366f97a15aa1888c934d3ecec86c33918b53
COPY --from=artifacts /node_modules /app/node_modules
CMD ["node", "/app"]
