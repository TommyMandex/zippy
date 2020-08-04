# zippy
Zippy is a simple script to get large amount of zip files info to text

# Usage
```
$ zippy.sh -f badass_phishing_kit.zip [-r]
```
-f or --file to process a single zip file
```
$ zippy.sh -d DIRECTORY_FULL_OF_ZIPS [-r]
```
-d or --dir to process all the zip files in the directory

OPTION -r (or --remove) removes file with .zip extension if it's not a zip (careful, won't ask confirmation!)

```
$ zippy.sh --help
```
simply shows the usage help and Zippy version

# Notes
Zippy comes from my personal need to get a quick way to process phishing kits gathered through [miteru](https://github.com/ninoseki/miteru) and similar scripts.

# Todo
Enable search for interesting indicators of phishing kit (PHP files, exfiltration methods, logs writing, ...)
