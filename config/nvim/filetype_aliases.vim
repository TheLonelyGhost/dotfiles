" Set syntax highlighting for specific file types
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
autocmd BufRead,BufNewFile .envrc set syntax=sh
autocmd BufRead,BufNewFile .zsh{rc,rc.local,env,env.local} set filetype=zsh
autocmd BufRead,BufNewFile Jenkinsfile set syntax=groovy
autocmd BufRead,BufNewFile Pipfile set filetype=toml
autocmd BufRead,BufNewFile Pipfile.lock set filetype=json
autocmd BufRead,BufNewFile *.pyi set syntax=python
"autocmd BufRead,BufNewFile foo set filetype=bar

autocmd BufReadPre *.{bin,binarycookies} let &binary=1
autocmd BufRead,BufNewFile * if &binary | set filetype=bin | endif
