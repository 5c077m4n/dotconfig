set --local ollama_commands serve create show run pull push list cp rm help

function __fish_print_all_local_ollama_models
    ollama list | tail --lines +2 | awk '{print $1}'
end

complete --command ollama --no-files
complete --command ollama --condition "not __fish_seen_subcommand_from $ollama_commands" --arguments serve --description 'Start ollama'
complete --command ollama --condition "not __fish_seen_subcommand_from $ollama_commands" --arguments show --description 'Show information for a model'
complete --command ollama --condition "not __fish_seen_subcommand_from $ollama_commands" --arguments create --description 'Create a model from a Modelfile'
complete --command ollama --condition "not __fish_seen_subcommand_from $ollama_commands" --arguments run --description 'Run a model'
complete --command ollama --condition "not __fish_seen_subcommand_from $ollama_commands" --arguments pull --description 'Pull a model from a registery'
complete --command ollama --condition "not __fish_seen_subcommand_from $ollama_commands" --arguments push --description 'Push a model to a registery'
complete --command ollama --condition "not __fish_seen_subcommand_from $ollama_commands" --arguments list --description 'List models'
complete --command ollama --condition "not __fish_seen_subcommand_from $ollama_commands" --arguments rm --description 'Remove a model'
complete --command ollama --condition "not __fish_seen_subcommand_from $ollama_commands" --arguments help --description 'Help about any command'

for ollama_argful_command in show run pull cp push rm
    complete --command ollama --condition "__fish_seen_subcommand_from $ollama_argful_command" --arguments '(__fish_print_all_local_ollama_models)'
end
complete --command ollama --condition "__fish_seen_subcommand_from create" --force-files
