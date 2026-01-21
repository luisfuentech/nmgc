# Node Modules Garbage Cleaner

This module allows you to remove lock files (`package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`) and `node_modules` from your project. It also provides a clean installation of your dependencies using npm, yarn, or pnpm.

<a href="https://nodei.co/npm/nmgc">
  <img src="https://nodei.co/npm/nmgc.png?downloads=true">
</a>

[![npm version](https://img.shields.io/npm/v/nmgc.svg?style=flat-square)](https://badge.fury.io/js/nmgc)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/LuisFuenTech/nmgc/blob/master/LICENSE)
[![NodeJS](https://img.shields.io/badge/node-6.x.x-brightgreen?style=flat-square)](https://github.com/LuisFuenTech/nmgc/blob/master/package.json)
[![install size](https://packagephobia.now.sh/badge?p=nmgc)](https://packagephobia.now.sh/result?p=nmgc)
[![npm downloads](https://img.shields.io/npm/dm/nmgc.svg?style=flat-square)](http://npm-stat.com/charts.html?package=nmgc)

# Compatibility

The minimum supported version of Node.js is v6.

# Usage

## Installation

```bash
npm i -g nmgc
```

Or use with `npx`

```bash
npx nmgc <COMMAND> [OPTIONS]
```

# Commands

```bash
USAGE:
    nmgc <COMMAND> [OPTIONS]

COMMAND
    h, help     show general help
    r, remove   remove lock files (package-lock.json, yarn.lock, pnpm-lock.yaml) and node_modules
    i, install  clean dependencies and install them from package.json

OPTIONS:
    -f, --force  force the installation
    --npm        use npm package manager
    --yarn       use yarn package manager
    --pnpm       use pnpm package manager

NOTE: If no package manager is specified, it will auto-detect based on lock files.
```

## Examples

```bash
# Remove lock files and node_modules
$ nmgc remove

# Clean install with auto-detection
$ nmgc install

# Clean install using yarn
$ nmgc install --yarn

# Clean install using pnpm
$ nmgc install --pnpm

# Install a specific package with npm
$ nmgc install express

# Install a specific package with yarn
$ nmgc install lodash --yarn
```

# License

[MIT](https://github.com/LuisFuenTech/nmgc/blob/master/LICENSE)
