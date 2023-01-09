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

- [Translate Toolkit](http://toolkit.translatehouse.org/) (provides pofilter; available in Debian/Ubuntu in `translate-toolkit`)
- Standard GNU gettext tools (`msgmerge`, `msgfilter`; available in Debian/Ubuntu in `gettext`)
- git
- (Optionally) [`podiff`](https://man.gnu.org.ua/manpage/?1+podiff), an extended `diff` that's smarter about PO files, e.g. ignoring order of messages

### 2. Set up the files/paths

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

### 3. Perform any necessary repository preparation

When starting to us a summit-based translation process with preexisting repositories, some preparation will be required.

For **each branch** of repository:

```bash
cd /path/to/repository/branch

# Check the files to make sure they're all OK. This may take a while.
sh ../../summit/check-files.sh
# Watch the output for any errors; if they are found, correct and re-run.
# If any were found you may want to commit them now.

# Create the .pot template files from the English-language PO files.
# (These should not be committed -- but you'll need them later.)
sh  ../../summit/create-templates.sh

# Apply the templates to the locale files.
# This will rearrange the locale files considerably! It will order the locale files
# similarly to the English files, comment out any obsolete translations, rewrap long
# lines, and probably more.
sh ../../summit/apply-templates.sh

# Commit the changes to git. This will cause pain for anyone who has modified versions
# of the locale files, e.g. open pull requests! Make sure any pending changes are committed
# before doing this.
git add -u
git commit -m "Rearrange locale files according to templates"
git push
```
