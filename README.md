# PKP Summit Translation Tools

This repository contains a toolset for supporting locale summiting with PKP software (OJS, OMP, and OPS).

Locale summiting ([beautifully described](https://techbase.kde.org/Localization/Workflows/PO_Summit) in the KDE project's documentation) allows us to port translations between different branches of the software, even if parts of those translations are not compatible.

## Setup

### 1. Get the tools

Make sure your system has the following tools installed:

- [Pology](http://pology.nedohodnik.net/) (provides `posummit`)

   **NOTE**: `posummit` requires a minor modification because it relies on gettext tools that [do not work well with monolingual PO files](https://github.com/WeblateOrg/weblate/issues/2658). To work around this issue, edit `posummit`, and comment out the following line with a `#`:
   ```
   assert_system("msgfmt -c -o/dev/null %s " % tmp_path)
   ```

- [Translate Toolkit](http://toolkit.translatehouse.org/) (provides pofilter)
- Standard GNU gettext tools (`msgmerge`, `msgfilter`)
- git

### Set up the files/paths

1. Make a base working directory.

   ```
   mkdir summit-basepath
   cd summit-basepath
   ```

2. Check out the applications/repos for summiting, with each relevant branch in a subdirectory.

   For each of OJS, OMP, OPS, pkp-lib, etc.:

   ```
   mkdir ojs
   cd ojs
   git checkout git@github.com:pkp/ojs -b main main
   git checkout git@github.com:pkp/ojs -b stable-3_3_0 stable-3_3_0
   cd ..
   ```
 
3. Check out this repository:
   ```
   git clone git@github.com:asmecher/summit-tools summit
   ```
 
You should now have a tree that looks like this:
```
├── ojs
│   ├── main
│   └── stable-3_3_0
├── omp
│   ├── main
│   └── stable-3_3_0
├── ops
│   ├── main
│   └── stable-3_3_0
├── pkp-lib
│   ├── main
│   └── stable-3_3_0
└── summit
```
