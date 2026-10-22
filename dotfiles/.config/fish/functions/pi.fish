function pi --wraps pi --description "A Pi agent wrapper"
    set --export --local PI_CODING_AGENT_DIR ~/.config/pi/agent/
    set --export --local PI_SKIP_VERSION_CHECK 1
    command pi $argv
end
