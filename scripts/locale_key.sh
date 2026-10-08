#!/bin/bash
#!/bin/bash
dart run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
file=$(pwd)"/lib/generated/locale_keys.g.dart"
echo '// ignore_for_file: constant_identifier_names' | cat - $file > temp && mv temp $file