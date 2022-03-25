FROM denoland/deno:distroless-1.20.3@sha256:6c29b2981ce9f6a84160a9ca9a2b02ab4da076c642719a852eabd2183720775f
ENV DENO_ENV=production

WORKDIR /app

# Cache the dependencies as a layer (the following two steps are re-run only when deps.ts is modified).
# Ideally fetch deps.ts will download and compile _all_ external files used in main.ts.
COPY deps.ts .
RUN ["deno", "cache", "--unstable", "deps.ts"]

# These steps will be re-run upon each file change in your working directory:
ADD . .
# Compile the main app so that it doesn't need to be compiled each startup/entry.
RUN ["deno", "cache", "--unstable", "main.ts"]

# Optionally prefer not to run as root.
USER nonroot

CMD ["run", "--unstable", "--allow-net", "--allow-env", "main.ts"]