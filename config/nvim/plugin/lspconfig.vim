lua << EOH
-- Python
require'lspconfig'.pyright.setup{}

-- TypeScript
require'lspconfig'.tsserver.setup{}

-- Terraform
--require'lspconfig'.tflint.setup{}
require'lspconfig'.terraformls.setup{}

-- CSS / SCSS
require'lspconfig'.stylelint_lsp.setup{}

-- Bash
require'lspconfig'.bashls.setup{}

-- HTML
require'lspconfig'.html.setup{}

-- Go
require'lspconfig'.gopls.setup{}

-- JSON
require'lspconfig'.jsonls.setup{}

-- Docker
require'lspconfig'.dockerls.setup{}

-- Rust
require'lspconfig'.rust_analyzer.setup{}

-- Nim
require'lspconfig'.nimls.setup{}

-- Ruby
require'lspconfig'.solargraph.setup{}

-- SQL
require'lspconfig'.sqlls.setup{}

-- Crystal
require'lspconfig'.scry.setup{}

-- Nix
require'lspconfig'.rnix.setup{}

-- GraphQL
require'lspconfig'.graphql.setup{}

-- VimL
require'lspconfig'.vimls.setup{}

-- YAML
require'lspconfig'.yamlls.setup{}
EOH
