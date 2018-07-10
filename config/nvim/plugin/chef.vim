" vim: ft=vim

if exists('$CHEF_ENV')
  " Use Test Kitchen to 'make' the chef cookbook. Usage:
  "
  " `:make verify 2008` -> shell command `kitchen verify 2008`
  set makeprg=kitchen

  let g:ale_ruby_rubocop_executable='cookstyle'
endif
