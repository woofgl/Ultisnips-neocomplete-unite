"=============================================================================
" FILE: neosnippet.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 05 Jun 2013.
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:source = {
      \ 'name' : 'ultisnips',
      \ 'kind' : 'keyword',
      \ 'rank' : 8,
      \ 'hooks' : {},
      \}

function! s:source.hooks.on_init(context) "{{{
  " Initialize.
  "call neosnippet#util#set_default(
        "\ 'g:neosnippet#enable_preview', 0)
endfunction"}}}

function! s:source.gather_candidates(context) "{{{
  "return values(neosnippet#get_snippets())
  " return keys(UltiSnips_SnippetsInCurrentScope())
  return s:get_words_list(a:context.complete_str,a:context.complete_pos)
endfunction"}}}

function! s:source.hooks.on_post_filter(context) "{{{
  for snippet in a:context.candidates
    let snippet.dup = 1
    let snippet.menu = '[snippets]'
    "let snippet.menu = neosnippet#util#strwidthpart(
          "\ snippet.menu_template, winwidth(0)/3)
    "if g:neosnippet#enable_preview
      "let snippet.info = snippet.snip
    "endif
  endfor
  return a:context.candidates
endfunction"}}}
 " Get Completion list based on UltiSnips function used in <C-Tab> completion
" list
function! s:get_words_list(cur_word, possible)
python << EOF
import vim
import sys
from UltiSnips import UltiSnips_Manager
import UltiSnips._vim as _vim
cur_word = vim.eval("a:cur_word")
possible = True if vim.eval("a:possible") else False
rawsnips = UltiSnips_Manager._snips(cur_word, possible)

snips = []
for snip in rawsnips:
    display = {}
    display['real_name'] = snip.trigger
    display['menu'] = '<snip> ' + snip.description
    display['word'] = snip.trigger
    display['kind'] = '~'
    snips.append(display)

vim.command("return %s" % _vim.escape(snips))
EOF
endfunction

function! neocomplete#sources#ultisnips#define() "{{{
  return s:source
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
