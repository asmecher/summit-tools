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

## Repository Preparation

If you are already using weblate on the repository, make sure you merge any outstanding translations from weblate.

When starting to use a summit-based translation process with a preexisting repository, some preparation will be required.

For **each branch** of the repository:

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

## Summiting / scattering

**Summiting** is the process of bringing translations together from various branches into a single place (the "summit"). **Scattering** is the process of sending any relevant changes from the summit back to the branches where they can be committed and pushed to Github.

### If Weblate sends translations to the repo's main branch

This should be considered an interim configuration. For a complete summiting process, Weblate should be configured to send translations directly to the summit, rather than the repo; [new locale keys should be added to the summit, not the branch, and all translation work should take place exclusively in the summit](http://pology.nedohodnik.net//doc/user/en_US/ch-summit.html#sec-suproblems).

However, if only as an interim configuration, it is possible for translations in one branch (probably `main`) of a repository to be the "definitive" source of translations (i.e. Weblate sends translations there), and for posummit to be used to port those translations back to other branches.

The disadvantage to this approach is that other branches will only receive partial translations. They will receive the parts of the translation that apply directly (e.g. to all branches), but not alternative translations of content that differs between branches.

### Summiting

#### 1. Prepare each branch:

```sh
cd summit-basepath/repository/branch
```

1. Update the branch checkout:
    ```sh
    git pull
    ```
2. (Re)create the templates:
    ```sh
    sh ../../summit/create-templates.sh
    ```

#### 2. Gather and scatter the summit:

```sh
cd summit-basepath/summit
```

1. Create the summit templates (e.g. for the `staticPages` repo):
    ```sh
    sh gather-templates.sh staticPages
    ```
2. Create the summit for each locale (e.g. for the `staticPages` repo):
    ```sh
    sh gather-locales.sh staticPages
    ```
3. Merge the summit for each locale (e.g. for the `staticPages` repo):
    ```sh
    sh merge-locales.sh staticPages
    ```
4. Scatter the summit to each branch (e.g. for the `staticPages` repo):
    ```sh
    sh scatter-locales.sh staticPages
    ```
#### 3. Handle changes to each branch:

```sh
cd summit-basepath/repository/branch
```

Use `git diff` / `git add -u` / `git commit` / `git push` to review and push the changes to the git repo.

If there are any locale keys that got scattered that are not appropriate for the branch, edit `summit-config-shared` and add the keys / file to the list of resolutions. This will ensure that the locale key in the specified branch/file is kept distinct from an incompatible key in another branch.
