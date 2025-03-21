function docker-compose --wraps podman-compose --description "A replacement for docker-compose"
    podman-compose $argv
end
