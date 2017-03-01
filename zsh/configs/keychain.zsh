
__LIST_OF_KEYS=()
#eval "$(keychain --eval id_rsa work_id_rsa)"

for key in ~/.ssh/*id_rsa; do
  __LIST_OF_KEYS+=$(basename $key)
done

eval "$(keychain --eval $__LIST_OF_KEYS)"

__LIST_OF_KEYS=()
