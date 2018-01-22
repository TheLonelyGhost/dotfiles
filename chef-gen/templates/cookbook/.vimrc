let g:ale_ruby_rubocop_executable='cookstyle'

augroup ChefFiletypes
  au! BufRead,BufNewFile *_test.rb,*/controls/*.rb set syntax=inspec
  au! BufRead,BufNewFile .kitchen.*.yml,.kitchen.yml set syntax=yaml.eruby
augroup END
