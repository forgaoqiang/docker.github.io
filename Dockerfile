# Base image to use for building documentation archives
# this image uses "ONBUILD" to perform all required steps in the archives
FROM nginx:alpine

# Make the version accessible to this build-stage, and copy it to an ENV so that it persists in the final image
ONBUILD ARG VER
ONBUILD ENV VER=$VER

# Clean out any existing HTML files, and copy the HTML from the builder stage to the default location for Nginx
ONBUILD RUN rm -rf /usr/share/nginx/html/*
ONBUILD COPY --from=builder /site /usr/share/nginx/html

# Copy the Nginx config from the docs-config image
COPY --from=docs/docker.github.io:docs-config /conf/nginx-overrides.conf /etc/nginx/conf.d/default.conf

# Start Nginx to serve the archive at / (which will redirect to the version-specific dir)
CMD echo -e "Docker docs are viewable at:\nhttp://0.0.0.0:4000"; exec nginx -g 'daemon off;'
