#!/bin/bash
. config.conf
arr=($(find ./ -name "$InfoName" | sed -z "s/\/${InfoName}\n/ /g"))

# echo $list
echo "Selectable list:"
echo "可选列表:"
for i in "${!arr[@]}"; do
  echo "    $i)${arr[$i]}"
done

if [[ $1 == "--select" ]]; then
  echo "input the num of your choice item:"
  echo "输入你选择的项的编号:"
  # set -o emacs
  # bind 'set show-all-if-ambiguous on'
  # bind 'TAB:menu-complete'
  read -e -p "" choice
  item=${arr[$choice]}
  if [[ $item = "" ]]; then
    echo "error[no this num($choice) item] and exit"
    exit 1
  fi
  export SelectCaItem=$item
  echo "$SelectCaItem"
fi
