function cursor-agent-p --wraps cursor-agent --description "Print cursor-agent stream as readable text"
    set --local c_user ''
    set --local c_tool ''
    set --local c_error ''
    set --local c_reset ''
    if isatty stdout
        set c_user (set_color $fish_color_param)
        set c_tool (set_color $fish_color_comment)
        set c_error (set_color $fish_color_error)
        set c_reset (set_color normal)
    end

    cursor-agent --output-format stream-json --print "$argv" | jq --unbuffered --raw-output \
        --arg c_user "$c_user" \
        --arg c_tool "$c_tool" \
        --arg c_error "$c_error" \
        --arg c_reset "$c_reset" \
        '
         def texts:
             [.message.content[]? | .text // empty] | join("");

         def title($color; $label):
             "\($color)[\($label)]\($c_reset)";

         def tool:
             if .tool_call.function then
                 {
                     name: .tool_call.function.name,
                     args: .tool_call.function.arguments,
                     result: .tool_call.function.result
                 }
             elif .tool_call then
                 (.tool_call | to_entries[0]) as $t
                 | {
                     name: ($t.key | sub("ToolCall$"; "")),
                     args: $t.value.args,
                     result: $t.value.result
                 }
             else null end;

         def args_text:
             if . == null then ""
             elif type == "string" then
                 (try fromjson catch null) as $parsed
                 | if ($parsed | type) == "object" then ($parsed | args_text) else . end
             elif type != "object" then ""
             elif .command then .command
             elif .pattern then
                 if .path then "\(.pattern) in \(.path)"
                 elif .targetDirectory then "\(.pattern) in \(.targetDirectory)"
                 else .pattern end
             elif .globPattern then
                 if .targetDirectory then "\(.globPattern) in \(.targetDirectory)"
                 else .globPattern end
             elif .path then .path
             elif .todos then
                 .todos | map(.content // empty) | join("\n ")
             else
                 [
                     to_entries[]
                     | select(.value | type == "string")
                     | select(.key as $k | ["fileText", "content", "toolCallId"] | index($k) | not)
                     | .value
                 ] | join(" ")
             end;

         def fail_text:
             if . == null or .success then ""
             elif .rejected.reason then .rejected.reason
             else "failed" end;

         if .type == "user" then
             texts | if length > 0 then "\n\(title($c_user; "user"))\n\(.)" else empty end
         elif .type == "assistant" then
             texts | if length > 0 then "\n\(.)" else empty end
         elif .type == "tool_call" then
             tool as $t
             | if .subtype == "started" then
                 ($t.args | args_text) as $a
                 | if $a == "" then title($c_tool; $t.name) else "\(title($c_tool; $t.name)) \($a)" end
               elif .subtype == "completed" then
                 ($t.result | fail_text) as $f
                 | if $f == "" then empty else "\(title($c_error; "\($t.name) failed")) \($f)" end
               else empty end
         elif .type == "result" and .is_error then
             .result | if . then "\(title($c_error; "error")) \(.)" else title($c_error; "error") end
         else empty end
     '

    return $pipestatus[1]
end
