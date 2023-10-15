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

## How to Build PGPM
1. **Prerequisites:**
 - Ensure you have CMake (version 3.22 or higher) installed on your system.
 - Make sure SWI-Prolog and Logtalk are available on your system.

2. **Configuration and Building:**

   Run the following commands to configure and build PGPM:

   ```bash
   # Configure
   cmake -S . -B build # . being the root directory of the project, build is where we want to build it

   # Build
   cmake --build build --parallel
   ```

3. **Running PGPM:**

   After building, you can run the pgpm executable using the following command:

   ```bash
   ./pgpm <command> [options]
   ```

   Replace `<command>` and `[options]` with your desired pgpm commands and options.

4. **Running Tests (Optional):**

   To ensure the software functions correctly, you can run the tests provided with the project:

   ```bash
   ctest
   ```
