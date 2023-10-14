### How to Contribute:

<img align="right" width="400" src="https://firstcontributions.github.io/assets/Readme/fork.png" alt="fork this repository" />

**1. Fork the Repository**

   Click the "Fork" button at the top-right of the [postgres-pm repository](https://github.com/postgres-pm/postgres-pm) to create your fork.

**2. Clone Your Fork**

   Open your terminal and clone your fork to your local machine:

   ```bash
   git clone https://github.com/your-username/postgres-pm.git
   ```

   Replace `your-username` with your GitHub username.

**3. Navigate to the Project Directory**

   Change your current directory to the PGPM project folder:

   ```bash

   cd pgpm

   ```

**4. Add a Reference to the Original Repository**

   To stay updated with the main project, add a reference (remote) to the original repository:

   ```bash
   git remote add upstream https://github.com/postgres-pm/postgres-pm.git
   ```

**5. Verify the Remotes**

   Ensure that you have the remotes set correctly by checking:

   ```bash
   git remote -v
   ```

**6. Keep Your Fork Updated**

   Regularly update your fork with changes from the main project:

   ```bash
   git pull upstream master
   ```

**7. Create a New Branch**

   Create a new branch for your contributions:

   ```bash
   git checkout -b your-branch-name
   ```

   Replace `your-branch-name` with a descriptive name for your branch.

**8. Make Changes**

   Make the desired changes to the codebase. Implement features, fix bugs, or improve documentation.

**9. Stage Your Changes**

   Stage your changes for the commit:

   ```bash
   git add .
   ```

**10. Commit Your Changes**

   Commit your changes with a descriptive message:

   ```bash
   git commit -m "Your relevant message here"
   ```

**11. Push to Your Remote Repository**

   Push your changes to your remote repository:

   ```bash
   git push -u origin your-branch-name
   ```

**12. Create a Pull Request**

   Visit the PGPM repository on GitHub and create a pull request. Provide a clear title and description explaining your changes and contributions.

**13. Review and Wait**

   Sit back and relax while your pull request is reviewed by the project maintainers.

### How to Build PGPM

**To build the Postgres Package Manager (pgpm) based on the provided CMake configuration and directory structure, you need to follow these steps:**

1. **Prerequisites:**

   - Make sure you have CMake (version 3.22 or higher) installed on your system.
   - Ensure you have SWI-Prolog and Logtalk available on your system, as they are required for the CMake configuration.

2. **Create a Build Directory:**

   Create a separate build directory to keep your source code clean:

   ```bash
   mkdir build
   cd build
   ```

3. **Configure the Build:**

   Run CMake to configure the build environment based on the `CMakeLists.txt` and CMake configuration files:

   ```bash
   cmake ..
   ```

4. **Build the Project:**

   Compile the pgpm source code by running the `make` command (or an equivalent command like `make -j4` for parallel compilation):

   ```bash
   make
   ```

5. **Run pgpm:**

   After building, you can run the pgpm executable using the following command:

   ```bash
   ./pgpm <command> [options]
   ```

   Replace `<command>` and `[options]` with your desired pgpm commands and options.

6. **Run Tests (Optional):**

   To ensure the software functions correctly, you can run the tests provided with the project using the following command:

   ```bash
   ctest
   ```

   This will execute the tests using CMake's built-in test runner.
