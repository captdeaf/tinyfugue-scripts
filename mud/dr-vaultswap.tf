/def -p10 -h"SEND vaultswap *" -mglob -wdr dr_vault_swap_backpack=\
  /let color=%{-1} %;\
  /dr_stow %{dr_lhand} %;\
  /dr_stow %{dr_rhand} %;\
  /drc go ironwood arch=go blackwood arch=go rosewood arch=pull lever=go door=open vault %;\
  /drc remove backpack=put my backpack in vault%;\
  /drc get %{color} backpack from vault %;\
  /drc wear my backpack=store default in my backpack %;\
  /drc close vault=go door=go arch

