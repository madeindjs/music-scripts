---
# build me with pandoc:
# pandoc music-library-export.md -t man | gzip > music-library-export.1.gz
title: music-library-export.sh
section: 1
header: User Manual
footer: music-library-export.sh 1.0.0
date: July 29, 2023
---

# NAME

**music-library-export.sh** — Audio library syncing and conversion utility

# SYNOPSIS


| **music-library-export.sh** _EXPORT_DIRECTORY_ \[FORMAT {ogg}\]

# DESCRIPTION

The intended use is syncing an audio library with many lossless files to a mobile device with limited storage.

Just move in you music library folder and run the script to copy you audio file eleswhere.

- the loseless files will be converted to your desired format
- the lossy files will be copied as is

# EXAMPLES

**music-library-export.sh ~/exported-library**

BUGS
====

See GitHub Issues: <https://github.com/madeindjs/music-scripts/issues>

AUTHOR
======

Alexandre Rousseau <alexandre@rsseau.fr>

