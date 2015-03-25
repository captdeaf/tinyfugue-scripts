; Queue management for dragonrealms.
;

; By default, ignore all the junk we get for the wizard.
; This is last in priority so we can other stuff we want as needed.
/def -ag -p0 -mregexp -wdr -t"^\034?GS" dr_gag_special

; time now and end of next roundtime.
/if (%{dr_tnow} =~ "") \
  /set dr_tnow=0 %;\
  /set dr_tnowset=0 %;\
  /set dr_tnext=0 %;\
  /set dr_queue= %;\
  /set dr_cqueue= %;\
  /set dr_cycle= %;\
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
  /set dr_idle=$[time()-%{dr_lasttypetime}] %;\
  /if (tleft <= 0) \
    /set timeleft= %;\
    /dr_dequeue %;\
  /else \
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
/eval /set dr_lasttypetime=$[time()]

/def dr_dequeue=\
  /if (%{dr_idle} < 600) \
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
/def -F -q -p1000 -h"SEND *" -mglob -wdr dr_recordlasttimestamp=\
  /set dr_lasttypetime=$[time()]

; Repeat if we get a "... wait" bit. Stick it on front of queue.
; This most often applies to what we send, rather than what was sent
; by /dr_dequeue. But maybe we should pay attention to that, too.
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
  /echo -wdr ## spells: %{dr_spell_queue} (casting: %{dr_spell_casting}) %;\
  /echo -wdr ## spell cycle: %{dr_spell_cycle} %;\
  /echo -wdr ## %;\
  /echo -wdr ## Idle time: $[trunc(%{dr_idle})] seconds. %;\
  /echo -wdr ## Left hand: '%{dr_lhand}', right hand: '%{dr_rhand}'

; oops - clear all queues.
/def -p10 -h"SEND oops" -wdr dr_oops=\
  /echo -wdr Oops, clearing queue! %;\
  /dr_dq %;\
  /set dr_queue= %;\
  /set dr_cycle= %;\
  /set dr_cqueue= %;\
  /set dr_spell_queue= %;\
  /set dr_spell_cycle=

