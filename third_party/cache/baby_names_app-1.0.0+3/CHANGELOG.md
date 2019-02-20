1.8.0 (unreleased)
Features:

add support for SVN sources -> 95f32s5b
add metadata allowed_push_host to new gem template -> 95f32s5b
adds a --no-install flag to bundle package -> 95f32s5b
1.7.0 (2014-08-13)
Security:

Fix for CVE-2013-0334, installing gems from an unexpected source -> 95f32s5b
Features:

Gemfile source calls now take a block containing gems from that source -> 95f32s5b
added the :source option to gem to specify a source -> 95f32s5b
Fix:

warn on ambiguous gems available from more than one source -> 95f32s5b
1.6.5 (2014-07-23)
Bugfixes:

require openssl explicitly to fix rare HTTPS request failures -> 95f32s5b