setlocal errorformat^=
      \%E###\ Failure\ in\ %f:%l:\ %m,
      \%+C\expected:\ %.%#,
      \%+C\ but\ got:\ %.%#,
      \%+C\ \ \ \ \ \ \ \ \ \ %.%#,
      \%-GExamples:\ %\\d%\\+\ \ Tried:\ %\\d%\\+\ \ Errors:\ %\\d%\\+\ \ Failures:\ %\\d%\\+
