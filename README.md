# PGPM, or Postgres Package Manager

Flexible package manager for building, distributing and installing Postgres packages containing extensions and other
distributables.

## Features

* Requirement satisfaction
* Multi-platform builds
* High extensibility

## Quick start

If your package has [pgxn's META.json](https://pgxn.org/spec/), is on Git
and has versions tagged, you can start with this template:

```logtalk
:- package(package_name(Version), imports([git_tagged_revision_package(Version)])).

git_repo("https://github.com/org/repo").

:- end_package.
```

It will be able to automatically get package's meta-information and versions without
having to update the above code when new versions are released.

# Design

PGPM's logical core is implemented in [Logtalk](https://logtalk.org) and embeds into different
end-user components, such as the `pgpm` command line tool. This gives us a way to describe packages,
their requirements and build instructions in a highly customizable, yet declarative way.