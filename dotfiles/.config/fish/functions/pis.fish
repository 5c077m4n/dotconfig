function pis --description 'Run pi in a Docker sandbox limited to the current directory'
    set --local image pi-sandbox
    set --local volume pi-agent-home

    # Optional: force an image rebuild with `pis --rebuild`
    set --local rebuild 0
    if test (count $argv) -gt 0; and test "$argv[1]" = --rebuild
        set rebuild 1
        set --erase argv[1]
    end

    # Build the image if needed, Dockerfile injected via stdin (no build context)
    if test $rebuild -eq 1; or not docker image inspect $image >/dev/null 2>&1
        echo "Building $image ..."
        set --local dockerfile '
FROM node:24-bookworm-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends bash ca-certificates git ripgrep \
  && rm -rf /var/lib/apt/lists/*
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent

WORKDIR /workspace
ENTRYPOINT ["pi"]
'
        echo $dockerfile | docker build --tag $image -
    end

    docker volume create $volume >/dev/null

    if not docker run --rm --volume $volume:/agent alpine test -f /agent/auth.json 2>/dev/null
        echo "Seeding $volume with auth.json and settings.json from ~/.pi/agent ..."
        docker run --rm --volume ~/.pi/agent/auth.json:/seed/auth.json:ro --volume ~/.pi/agent/settings.json:/seed/settings.json:ro --volume $volume:/agent alpine sh -c 'cp /seed/* /agent/ && chmod 600 /agent/auth.json'
    end

    set --local tty_flags
    tty --silent >/dev/null; and set tty_flags --interactive --tty
    docker run --rm $tty_flags --volume $PWD:/workspace --workdir /workspace --volume $volume:/root/.pi/agent $image $argv
end
