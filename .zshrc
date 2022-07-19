# Other default configurations
 export FZF_DEFAULT_COMMAND='rg --files --follow --hidden'
 export VISUAL=vim
 export EDITOR="$VISUAL"
 export BUNDLER_EDITOR="$VISUAL"

# search branches with fzf
gch() {git for-each-ref --sort='authordate:iso8601' --format='%(authordate:relative)%09%(refname:short)' refs/heads | fzf --tac --bind 'enter:execute(echo {} | rev | cut -f1 | rev | xargs git checkout)+abort,tab:execute-silent(echo {} | rev | cut -f1 | rev | pbcopy)+abort'
}
