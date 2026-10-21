function pi --wraps pi --description "A Pi agent wrapper"
    set --export --local PI_CODING_AGENT_DIR ~/.config/pi/agent/
    command pi $argv
end
