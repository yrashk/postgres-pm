:- object(fs_tests,
	extends(lgtunit)).


cover(fs).

test(recursive_directory_files) :-
  logtalk::loaded_file_property(F, basename('fs.lgt')),
  logtalk::loaded_file_property(F, directory(Dir)),
  fs::recursive_directory_files(Dir, '', 'fs.lgt').

test(url_valid_filename, all(valid_filename(Chars))) :-
  Urls = ["http://foo.com:8080/test?q=3%20"],
  list::member(Url, Urls),
  fs::valid_filename(Url, Filename),
  atom_chars(Filename, Chars).

valid_filename(Chars) :-
  ::assertion(\+ list::member('/', Chars)),
  ::assertion(\+ list::member(':', Chars)),
  ::assertion(\+ list::member('\\', Chars)),
  ::assertion(\+ list::member('*', Chars)),
  ::assertion(\+ list::member('?', Chars)).

:- end_object.