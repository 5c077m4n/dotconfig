function podman-sock-path
    podman machine inspect --format '{{ .ConnectionInfo.PodmanSocket.Path }}' $argv
end
