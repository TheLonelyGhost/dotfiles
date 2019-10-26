/ source / {
  if ($0 !~ /source "\$1"/) {
    gsub(/ source /, " _profile_source ")
  }
}
{print}
