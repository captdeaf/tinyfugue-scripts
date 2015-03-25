; /load_dr <path to dr>
/def load_dr=\
  /set dr_path=%{*} %;\
  /require %{dr_path}/dr.tf %;\
  /require %{dr_path}/dragonrealms.login.tf %;\
  /require %{dr_path}/dr-autopick.tf %;\
  /require %{dr_path}/dr-vaultswap.tf %;\
  /require %{dr_path}/dr-crafting.tf %;\
  /require %{dr_path}/dr-spells.tf %;\
  /require %{dr_path}/dr-colors.tf
