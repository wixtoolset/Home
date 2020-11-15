<img src="https://github.com/wixtoolset/Home/raw/master/imgs/wix-white-bg.png" alt="WiX Toolset" height="128" />

# Home

The Home repository is the starting point for developers wanting to contribute to the WiX Toolset.


## Getting Started

The WiX Toolset is composed of several projects that are distributed across several Git repositories.
The output of a project is published and shared with other projects via NuGet packages.
Thus, you only need to enlist in the Git repositories required for your change.

Before you begin, you must have [Git][git] and the [.NET Core 2.0 SDK][core2] installed. [Visual Studio 2017.3][vs] can be used
to get both.

To help developer productivity, the `enlist.cmd` in this repository can be used to manage a .sln file
with all the projects you clone. Simply follow these steps to get going:

1. Create a folder to hold the WiX Toolset projects. For example, `C:\src\wixtoolset`
2. Clone this repository into that folder: `git clone https://github.com/wixtoolset/Home.git C:\src\wixtoolset\Home`
3. Run the `enlist.cmd` in your clone of the Home repository for the project you are interested in. For example: `C:\src\wixtoolset\Home\enlist.cmd Core`

The `enlist.cmd` will clone the desired project, create a `WixToolset.sln` in the root folder (e.g. `C:\src\wixtoolset`), add the
requested projects to the solution and configure NuGet. You can run `enlist.cmd` multiple times to add additional projects.


[git]: https://git-for-windows.github.io/
[core2]: https://www.microsoft.com/net/core
[vs]: https://www.visualstudio.com/vs/