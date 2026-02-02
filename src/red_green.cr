# RedGreen provides the core namespace for the Roslyn red/green tree port.
require "./red_green/node_flags"
require "./red_green/green_node"
require "./red_green/syntax_node"
require "./red_green/syntax_tree"
require "./red_green/syntax_token"
require "./red_green/syntax_trivia"
require "./red_green/child_syntax_list"
require "./red_green/syntax_node_or_token"
require "./red_green/syntax_token_list"
require "./red_green/syntax_trivia_list"
require "./red_green/syntax_walker"
require "./red_green/syntax_differ"
require "./red_green/syntax_factory"
require "./red_green/syntax_list"
require "./red_green/separated_syntax_list"
require "./red_green/internal_syntax/syntax_list"
require "./red_green/internal_syntax/syntax_list_variants"
require "./red_green/syntax_node_cache"

module RedGreen
  VERSION = "0.1.0"
end
