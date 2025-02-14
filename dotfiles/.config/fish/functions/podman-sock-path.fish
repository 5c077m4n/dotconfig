function podman-sock-path --wraps "podman machine inspect"
    podman machine inspect --format '{{ .ConnectionInfo.PodmanSocket.Path }}' $argv
end
