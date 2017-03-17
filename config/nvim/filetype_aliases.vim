" Set syntax highlighting for specific file types
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
autocmd BufRead,BufNewFile .envrc set filetype=sh
autocmd BufRead,BufNewFile .zsh{rc,rc.local,env,env.local} set filetype=zsh
"autocmd BufRead,BufNewFile foo set filetype=bar