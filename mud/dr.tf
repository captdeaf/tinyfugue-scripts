; Dragonrealms scripts.
;

;;; TRAINING
;
; /set dr_cycle=hunt=~=collect rock=~=prep stw 4=~=kick pile=~=scout cover my tracks=~=appraise runestone=~=collect rock=~=kick pile=hunt=~=focus runestone=~=prep compost 4=~=focus runestone=~=appraise coat=~=perceive

; By default, ignore all the junk we get for the wizard.
; This is last in priority so we can other stuff we want as needed.
/def -ag -p0 -mregexp -wdr -t"^\034?GS" dr_gag_special

; time now and end of next roundtime.
/if (%{dr_tnow} =~ "") \
  /set dr_tnow=0 %;\
  /set dr_tnowset=0 %;\
  /set dr_tnext=0 %;\
  /set dr_hung=0 %;\
  /set dr_lhand= %;\
  /set dr_rhand= %;\
  /set dr_lasttypetime=0
/endif

; Clear the queues
; Non-combat queue
; /set dr_queue=

; Combat queue (for analyze).
; /set dr_cqueue=

; default cycle. When both queues are empty, this is bumped to dr_cqueue.
; /set dr_cycle=

; drchecktimer: Every 1/2 second, we run.
; If we're not stuck in a roundtimer, then pop something off of:
;   1) dr_queue
;   2) dr_cqueue (combat)
;
; If we are stuck in a roundtimer, then trim the ~s off of either queue.
;

/def drchecktimer=\
  /let tleft=$[trunc((%{dr_tnext}-%{dr_tnow})-(time()-%{dr_tnowset})+1.8)] %;\
  /if (tleft <= 0) \
    /set timeleft= %;\
    /set dr_hung=0 %;\
    /dr_dequeue %;\
  /else \
    /set dr_hung=1 %;\
    /set timeleft=timeout:%{tleft} %;\
    /dr_cleanqueue %;\
  /endif

/def dr_send=\
  /if (%{*} !~ "~") \
    /if (%{*} =/ "/*") \
      /eval %{*} %;\
    /else \
      /send -wdr $[replace("ENEMY",%{dr_enemy},%{*})] %;\
    /endif%; \
  /endif

; Set lasttypetime to load time, why not.
/set dr_lasttypetime=$[time()]

/def dr_dequeue=\
  /let idle=$[time()-%{dr_lasttypetime}] %;\
  /if (%{idle} < 600) \
    /if (strlen(%{dr_queue})) \
      /split %{dr_queue} %;\
      /set dr_queue=%{P2} %;\
      /dr_send %{P1} %;\
    /elseif (dr_spell_waiting() != 0) \
      /dr_spell_cast %;\
    /elseif (strlen(%{dr_cqueue})) \
      /split %{dr_cqueue} %;\
      /set dr_cqueue=%{P2} %;\
      /dr_send %{P1} %;\
    /elseif (strlen(%{dr_cycle})) \
      /set dr_cqueue=%{dr_cycle} %;\
    /endif %;\
  /endif

/def dr_cleanqueue=\
  /if (strlen(%{dr_queue})) \
    /split %{dr_queue}%;\
    /if (%{P1} =~ "~") \
      /set dr_queue=%{P2}%;\
      /dr_cleanqueue %;\
    /endif %;\
  /elseif (strlen(%{dr_cqueue})) \
    /split %{dr_cqueue}%;\
    /if (%{P1} =~ "~") \
      /set dr_cqueue=%{P2}%;\
      /dr_cleanqueue %;\
    /endif %;\
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
/def -ag -F -p9 -mregexp -wdr -t"^\034?GSQ(\d+)" dr_get_timeout=\
  /set dr_tnext=%{P1}

; Time now. This is sent secondly, oddly.
/def -ag -F -p9 -mregexp -wdr -t"^\034?GSq(\d+)" dr_get_timenow=\
  /set dr_tnow=%{P1} %;\
  /set dr_tnowset=$[time()]

/def ^\GSq0972325047

; Ignore the prompts.
/def -wdr -h"PROMPT *" -ag -mglob dr_prompt=

; What's carried in my hands?

/def -ag -F -p9 -mregexp -wdr -t"^\034?GSm.{30}(\S.*\S)\s*$" dr_get_rhand=\
  /set dr_rhand=%{P1}

/def -ag -F -p9 -mregexp -wdr -t"^\034?GSl.{30}(\S.*\S)\s*$" dr_get_lhand=\
  /set dr_lhand=%{P1}

/def dr_stow=\
  /if (%{*} !~ "Empty") \
    /if (%{*} =~ "longbow") \
      /dr unload my longbow=stow left=wear my longbow %;\
    /elseif (%{*} =~ "sling") \ \
      /dr unload my sling=stow left=stow my sling %;\
    /else \
      /dr stow my %{*} %;\
    /endif %;\
  /endif

/def -ag -F -p9 -mregexp -wdr -t"^\034?GSq(\d+)" dr_get_timenow=\
  /set dr_tnow=%{P1} %;\
  /set dr_tnowset=$[time()]

; Who am I facing?
/def -F -p9 -mregexp -wdr -t"You turn to face (\S.+?)[,.]" dr_get_enemy=\
  /set dr_enemy=%{P1}

; Since dr actually has a queud limit of commands to send, we have to worry
; about sending stuff too fast. So we have a limitation of roughly 2 commands/sec.
; So this script uses a repeating queue every half second as long as the queue
; is empty.

; /dr: queue a series of commands to -wdr.
/def dr=\
  /if (strlen(%{dr_queue}))\
    /set dr_queue=%{dr_queue}=~=%{*} %;\
  /else \
    /set dr_queue=%{*}%;\
  /endif

; /drc: queue a series of combat commands.
/def drc=\
  /if (strlen(%{dr_cqueue}))\
    /set dr_cqueue=%{dr_cqueue}=~=%{*} %;\
  /else \
    /set dr_cqueue=%{*}%;\
  /endif

; For dr_dequeue, so we don't afk train if suddenly called away.
/def -F -q -p1000 -h"SEND (\S.*)" -mregexp -wdr dr_recordlasttimestamp=\
  /set dr_lasttypetime=$[time()]

; Repeat if we get a "... wait" bit. Stick it on front of queue.
/def -F -q -p1 -h"SEND (\S.*)" -mregexp -wdr dr_recordlast=\
  /set dr_lasttyped=%{P1}

/def -mglob -t"...wait * seconds." -wdr drt_repeat_last=\
  /if (strlen(%{dr_lasttyped})) \
    /dr %{dr_lasttyped} %;\
    /set dr_lasttyped= %;\
  /endif

; See the queue, and anything I'm training.
/def -p10 -h"SEND dq" -wdr dr_dq=\
  /echo -wdr ## queue: %{dr_queue} %;\
  /echo -wdr ## combat queue: %{dr_cqueue} %;\
  /echo -wdr ## default cycle: %{dr_cycle} %;\
  /echo -wdr ## %;\
  /echo -wdr ## spells: %{dr_spell_queue} %;\
  /echo -wdr ## spell cycle: %{dr_spell_cycle}

; oops - clear queue.
/def -p10 -h"SEND oops" -wdr dr_oops=\
  /echo -wdr Oops, clearing queue: %{dr_queue}. %;\
  /set dr_queue= %;\
  /set dr_cycle= %;\
  /set dr_cqueue= %;\
  /set dr_spell_queue= %;\
  /set dr_spell_cycle=

/def -p10 -h"SEND nodtrain" -wdr dr_nodtrain=\
  /set dr_trains=no

; Empty hands.
/def dr_emptyhands=/dr stow left=stow right=wear right

; slr: Stow left and right.
/def -p10 -h"SEND slr" -wdr dr_slr=\
  /dr_stow %{dr_lhand} %;\
  /dr_stow %{dr_rhand}

; wl: wield longbow
/def -p10 -h"SEND wl" -wdr dr_wl=/dr remove longbow=load

; dw: dual wield sword and dagger
/def -p10 -h"SEND dw" -wdr dr_dw=/dr get sword=get dagger

; rah: retreat, aim, hide
/def -p10 -h"SEND lrah" -wdr dr_lrah=/dr retreat=retreat=load=~=aim=retreat=retreat=hide
/def -p10 -h"SEND rah" -wdr dr_rah=/dr aim=retreat=hide

/def -p10 -h"SEND asl" -wdr dr_asl=/dr arrange for skin=~=skin=~=loot
/def -p10 -h"SEND sa" -wdr dr_sa=/dr stow long arrow=stow long arrow=stow long arrow
/def -p10 -h"SEND sr" -wdr dr_sr=/dr stow small rock=stow small rock=stow small rock
/def -p10 -h"SEND gc" -wdr dr_gc=/dr get coin=get coin

/def -p10 -h"SEND strip" -wdr dr_strip=\
  /dr remove coat=stow coat=remove aventail=stow aventail=remove gloves=stow gloves %;\
  /dr remove greaves=stow greaves=remove helm=stow helm=remove buckler=stow buckler

/def -p10 -h"SEND gearup" -wdr dr_gearup=\
  /dr get coat=wear coat=get aventail=wear aventail=get gloves=wear gloves %;\
  /dr get greaves=wear greaves=get helm=wear helm=get buckler=wear buckler

; autofire:
/def -t"You think you have your best shot possible now." -wdr drt_fire=/dr poach=fire

; A chance for a stun can be inflicted upon the enemy by landing a jab, a slice and a thrust.
; Armor reduction can be inflicted upon the enemy by landing a lunge, a lunge and a draw.
/def -wdr -mregexp -t"can be inflicted.*?by landing an? (.*)\\.$" drt_analyzed=\
  /let moves=$[replace(", an ","=~=",replace(", a ","=~=",replace(" and",",",%{P1})))] %;\
  /drc ~=%{moves}

; Auto-switch to block when telek gets lodged.
; The telek lodges itself shallowly into the cougar!
/def -t"The telek lodges itself shallowly into the *" -mglob -wdr drt_autoblock=/dr stance set 100 0 80 100

; Clear queue and cycle
; There is nothing else to face!
/def -t"There is nothing else to face!" -mglob -wdr drt_stopcycle_fighting=\
  /set dr_cycle=

; Auto-approach:
; You must be closer to use tactical abilities on your opponent.
/def -t"You must be closer to use tactical abilities on your opponent." -mglob -wdr drt_cant_analyze=\
  /dr advance

/set dr_autofollow=no

/def -wdr -mregexp -t"^Directions towards.*?: (.*?)(\.|, and you're there\\.)" drt_autofollow=\
  /if (dr_autofollow =~ "yes") \
    /set dr_autofollow=no %;\
    /let moves=$[replace(", ","=",replace(" and","",%{P1}))] %;\
    /dr ~=dir stop %;\
    /dr %{moves} %;\
  /endif

; autofollow directions
/def -p10 -h"SEND goto (.*)" -mregexp -wdr dr_goto=\
  /set dr_autofollow=yes %;\
  /dr dir %{P1} 14

/def -p10 -h"SEND vault (.*)" -mregexp -wdr dr_vault=\
  /dr_vaultit %{P1}

/def dr_vaultit=\
  /if (strlen(%{*})) \
    /split %{*} %;\
    /let rest=%{P2} %;\
    /dr get %{P1} from back=put %{P1} in vault %;\
    /dr_vaultit %{rest} %;\
  /endif
