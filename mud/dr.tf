; Dragonrealms scripts.
;

; By default, ignore all the junk we get for the wizard.
; This is last in priority so we can other stuff we want as needed.
/def -ag -q -p0 -mregexp -wdr -t"^\034GS" dr_gag_special

; time now and end of next roundtime.
/set dr_tnow=0
/set dr_tnowset=0
/set dr_tnext=0
/set dr_hung=0

/def drchecktimer=\
  /let tleft=$[trunc((%{dr_tnext}-%{dr_tnow})-(time()-%{dr_tnowset})+1.5)] %;\
  /if (tleft <= 0) \
    /set timeleft= %;\
    /set dr_hung=0 %;\
  /else \
    /set dr_hung=1 %;\
    /set timeleft=timeout:%{tleft} %;\
  /endif
  
; Round timer detection.
/if (%{timer_running} !~ "yes") \
  /set timeleft=0 %;\
  /status_add -A@world timeleft:10%;\
  /set timer_running=yes %;\
  /repeat -wdr -0.5 i /drchecktimer \
  %;\
/endif

; When round timer ends.
/def -F -p9 -mregexp -wdr -t"^\034GSQ(\d+)" dr_get_timeout=\
  /set dr_tnext=%{P1}

; Time now. This is sent secondly, oddly.
/def -F -p9 -mregexp -wdr -t"^\034GSq(\d+)" dr_get_timenow=\
  /set dr_tnow=%{P1} %;\
  /set dr_tnowset=$[time()]

/def ^\GSq0972325047

; Ignore the prompts.
/def -wdr -h"PROMPT *" -ag -mglob dr_prompt=

; Utility /methods.

; Since dr actually has a queud limit of commands to send, we have to worry
; about sending stuff too fast. So we have a limitation of roughly 2 commands/sec.
; So this script uses a repeating queue every half second as long as the queue
; is empty.

; Clear the queue
/set dr_queue=

/def dr_send=\
  /if (dr_hung > 0) \
    /split %{dr_queue}%;\
    /if (%{P1} =~ "~") \
      /set dr_queue=%{P2}%;\
      /dr_send%;\
    /else \
      /repeat -0.4 1 /dr_send %;\
    /endif %;\
  /else \
    /split %{dr_queue}%;\
    /if (%{P1} !~ "~") \
      /send -wdr %{P1}%;\
      /set dr_queue=%{P2}%;\
      /if (strlen(%{P2})) \
        /repeat -0.5 1 /dr_send %;\
      /endif %;\
    /else \
      /set dr_queue=%{P2}%;\
      /if (strlen(%{P2})) \
        /repeat -1.2 1 /dr_send %;\
      /endif %;\
    /endif %; \
  /endif

; /dr: send a series of commands to -wdr.
/def dr=\
  /if (strlen(%{dr_queue}))\
    /set dr_queue=%{dr_queue}=%{*} %;\
  /else \
    /set dr_queue=%{*}%;\
    /dr_send %;\
  /endif

; Repeat if we get a "... wait" bit. Stick it on front of queue.
/def -F -q -p1 -h"SEND (\S.*)" -mregexp -wdr dr_recordlast=\
/set dr_lasttyped=%{P1}

/def -mglob -t"...wait * seconds." -wdr drt_repeat_last=\
/if (strlen(%{dr_lasttyped})) \
/dr %{dr_lasttyped} %;\
/set dr_lasttyped= %;\
/endif

/set dr_trains=no

/def dr_traincycle=\
  /if (%{dr_trains} =~ "yes") \
    /split %{*} %;\
    /let count=$[%{P1}-1] %;\
    /split %{P2} %;\
    /let delay=%{P1} %;\
    /let command=%{P2} %;\
    /echo Training '%{command}', %{count} times with %{delay} delay. %;\
    /dr %{command} %;\
    /if (%{count} > 0) \
      /repeat -%{delay} 1 /dr_traincycle %{count}=%{delay}=%{command} %;\
    /endif %;\
  /endif

; dtrain <count> <delays> <command>- repeat 
/def -p10 -h"SEND dtrain (\d+) (\d+) (\S.*)" -mregexp -wdr dr_dtrain=\
  /set dr_trains=yes %;\
  /dr_traincycle %{P1}=%{P2}=%{P3}

/def -p5  -h"SEND dtrain*" -wdr dr_dtrain_info=\
  /echo -wdr Usage: dtrain <count> <delays> <command>

; See the queue, and anything I'm training.
/def -p10 -h"SEND dq" -wdr dr_dq=\
  /echo -wdr -- queue: %{dr_queue}

; oops - clear queue.
/def -p10 -h"SEND oops" -wdr dr_oops=\
  /echo -wdr Oops, clearing queue: %{dr_queue}. %;\
  /set dr_queue= %;\
  /set dr_trains=no

; Empty hands.
/def dr_emptyhands=/dr stow left=stow right=wear right

; slr: Stow left and right.
/def -p10 -h"SEND slr" -wdr dr_slr=/dr_emptyhands

; wl: wield longbow
/def -p10 -h"SEND wl" -wdr dr_wl=/dr remove longbow=load

; dw: dual wield sword and dagger
/def -p10 -h"SEND dw" -wdr dr_dw=/dr get sword=get dagger

; rah: retreat, aim, hide
/def -p10 -h"SEND rah" -wdr dr_rah=/dr aim=retreat=hide

; ecc: eagle's cry at chest
/def -p10 -h"SEND ecc" -wdr dr_ecc=/dr prep ec 4=target

; autocasts:
/def -mglob -t"Your formation of a targeting*has completed." -wdr drt_cast_target=/dr cast
/def -t"You feel fully prepared to cast your spell." -wdr drt_cast_area=/dr cast

; autofire:
/def -t"You think you have your best shot possible now." -wdr drt_fire=/dr poach=fire

; Disarming and Picking.
/def -t"You are unable to make any progress towards opening the lock." -wdr drt_repick=\
  /quote -0 /dr ~=`/recall -i -mglob /1 pick*
/def -t"You work with the trap for a while but are unable to make any progress." -wdr drt_redisarm=\
  /quote -0 /dr ~=`/recall -i -mglob /1 disarm*
/def -t"You fumble around with the trap apparatus, but are unable to extract anything of value." -wdr drt_redisarm_harvest=\
  /quote -0 /dr ~=`/recall -i -mglob /1 disarm*
/def -t"You are unable to determine anything useful about the lock on *." -mglob -wdr drt_repick_analyze=\
  /quote -0 /dr ~=pick analyze

; A chance for a stun can be inflicted upon the enemy by landing a jab, a slice and a thrust.
; Armor reduction can be inflicted upon the enemy by landing a lunge, a lunge and a draw.
/def -wdr -mregexp -t"can be inflicted.*?by landing a (.*)\\.$" drt_analyzed=\
  /let moves=$[replace(", a ","=~=",replace(" and",",",%{P1}))] %;\
  /dr ~=%{moves}=~=analyze=~

; autoretreat
/if (dr_autoret !~ "no") \
  /set dr_autoret=yes %;\
/endif

/def -t"The * closes to melee range on you!" -wdr drt_melee_retreat=\
  /if (dr_autoret =~ "yes") \
    /dr ret=~=ret %;\
  /endif

/def -t"The * closes to pole weapon range on you!" -wdr drt_pole_retreat=\
  /if (dr_autoret =~ "yes") \
    /dr ret %;\
  /endif

/set dr_autofollow=no

/def -wdr -mregexp -t"^Directions towards.*?: (.*?)(\.|, and you're there\\.)" drt_autofollow=\
  /if (dr_autofollow =~ "yes") \
    /set dr_autofollow=no %;\
    /let moves=$[replace(", ","=",replace(" and","",%{P1}))] %;\
    /dr dir stop %;\
    /dr %{moves} %;\
  /endif

; autofollow directions
/def -q -p10 -h"SEND goto (.*)" -mregexp -wdr dr_goto=\
  /set dr_autofollow=yes %;\
  /dr dir %{P1} 8
