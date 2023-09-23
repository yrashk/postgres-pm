:- object(fs).

:- use_module(library(filesex)).

:- public([recursive_directory_files/3, valid_filename/2]).

recursive_directory_files(Path, RelativeDirectory, File) :-
    recursive_directory_files(Path, '', RelativeDirectory, File).

recursive_directory_files(Directory, CurrentRelativeDir, RelativeDirectory, File) :-
    os::directory_files(Directory, Files),
    list::member(FileOrSubdir, Files),
    FileOrSubdir \= '.', FileOrSubdir \= '..', FileOrSubdir \= '.git',
    directory_file_path(Directory, FileOrSubdir, FilePath),
    (   os::directory_exists(FilePath)
    ->  (CurrentRelativeDir = '' ->
            NewRelativeDir = FileOrSubdir
        ;   atomic_list_concat([CurrentRelativeDir, FileOrSubdir], '/', NewRelativeDir)
        ),
        recursive_directory_files(FilePath, NewRelativeDir, RelativeDirectory, File)
    ;   RelativeDirectory = CurrentRelativeDir,
        File = FileOrSubdir
    ).


valid_filename(Name, Filename) :-
    atom_chars(Name, Chars),
    meta::map(sanitize_char, Chars, SanitizedChars),
    atom_chars(Filename, SanitizedChars).

sanitize_char(C, '_') :-
    list::member(C, ['\\','/',':','*','?',' ']), !.
sanitize_char(C, C).

:- end_object.

