function docker --wraps podman --description "A replacement for docker"
    podman $argv
end
