if exists('b:current_syntax')
    finish
endif

syn match qfFileName /^[^│]*/ nextgroup=qfSeparatorLeft
syn match qfSeparatorLeft /│/ contained nextgroup=qfLineNr
syn match qfLineNr /[^│]*/ contained nextgroup=qfSeparatorRight
syn match qfSeparatorRight '│' contained nextgroup=qfError,qfWarning,qfInfo,qfNote,qfNone
syn match qfError / E .*$/ contained
syn match qfWarning / W .*$/ contained
syn match qfInfo / I .*$/ contained
syn match qfNote / [NH] .*$/ contained
syn match qfNone / .*$/ contained

hi! def link qfFileName Constant
hi! def link qfSeparatorLeft Delimiter
hi! def link qfSeparatorRight Delimiter
hi! def link qfLineNr WarningMsg
hi! def link qfError DiagnosticError
hi! def link qfWarning DiagnosticWarn
hi! def link qfInfo DiagnosticInfo
hi! def link qfNote DiagnosticHint
hi! def link qfNone NormalNC

let b:current_syntax = 'qf'
