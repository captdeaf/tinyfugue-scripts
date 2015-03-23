; Disarming and Picking.
/set dr_picking=
/def dr_queue_disarm=\
  /drc disarm id=~=disarm=~=disarm analy=~=disarm harvest=~=empty left %;\
  /drc get lockpick=~=pick id=~=pick blind=~=stow lockpick %;\
  /drc open %{dr_picking}=~=fill my pouch with my %{dr_picking} %;\
  /drc get coin from %{dr_picking}=~=get coin from %{dr_picking}=~=get coin from %{dr_picking}=~=get coin from %{dr_picking} %;\
  /drc dismantle %{dr_picking}

/def -p10 -h"SEND pickit *" -wdr dr_pickit=\
  /set dr_picking=%{-1} %;\
  /echo Auto-picking %{dr_picking} ...%;\
  /dr_queue_disarm
/def -t"Careful probing of the * fails to reveal to you what type of trap protects it." -mglob -wdr drt_redisarm_id=\
  /dr disarm id

; Reset the autopick queue if there's another trap.
/def -t"You*not yet fully disarmed." -mglob -wdr drt_restart_disarm=\
  /set dr_cqueue= %;\
  /drc disarm analy=~=disarm harvest=~=empty left %;\
  /dr_queue_disarm
/def -t"You work with the trap for a while but are unable to make any progress." -wdr drt_redisarm=\
  /dr disarm
/def -t"You are unable to determine a proper method of extracting part of *" -wdr drt_redisarm_analyze=\
  /dr disarm analyze
/def -t"You fumble around with the trap apparatus, but are unable to extract anything of value." -wdr drt_redisarm_harvest=\
  /dr disarm harvest
/def -t"Careful probing of * fails to teach you anything about the lock guarding it." -mglob -wdr drt_repick_id=\
  /dr ~=pick id
/def -t"You are unable to determine anything useful about the lock on *." -mglob -wdr drt_repick_analyze=\
  /dr ~=pick analyze
/def -t"You are unable to make any progress towards opening the lock." -wdr drt_repick=\
  /dr pick blind
/def -t"You discover another lock protecting the * contents as soon as you remove this one." -mglob -wdr drt_pick_again=\
  /dr pick id %;\
  /dr pick blind
