; Dragonrealms scripts.
;

;;; Spell queue.
/set dr_spell_queue=

; Are we currently casting a spell?
; /set dr_spell_casting=no

; ecc: eagle's cry at chest
/def dr_spell_add=\
  /if (strlen(%{dr_spell_queue})) \
    /set dr_spell_queue=%{dr_spell_queue}=%{*} %;\
  /else \
    /set dr_spell_queue=%{*} %;\
  /endif

/def -i dr_spell_waiting=\
  /if (%{dr_spell_casting} =~ "yes") \
    /return 0 %;\
  /elseif (%{dr_spell_queue} =~ "") \
    /if (strlen(%{dr_spell_cycle}) > 0) \
      /return 1 %;\
    /else \
      /return 0 %;\
    /endif %;\
  /else \
    /return 1 %;\
  /endif

/def dr_spell_cast=\
  /if (strlen(%{dr_spell_queue}) < 1) \
    /set dr_spell_queue=%{dr_spell_cycle} %;\
  /endif %;\
  /if (strlen(%{dr_spell_queue}) > 0) \
    /split %{dr_spell_queue} %;\
    /set dr_spell_queue=%{P2} %;\
    /dr %{P1} %;\
  /endif

/def -p10 -h"SEND zp *" -wdr dr_spell_notarget=\
  /dr_spell_add prep %{-1}

/def -p10 -h"SEND zt *" -wdr dr_spell_target=\
  /dr_spell_add target %{-1}

; Identify when I start casting.
/def -mglob -t"With * movements you prepare your body*" -wdr drt_spell_casting=\
  /set dr_spell_casting=yes

; autocasts: Cast and pop off casting
/def -mglob -t"Your formation of a targeting*has completed." -wdr drt_cast_target=\
  /dr cast %;\
  /set dr_spell_casting=no

/def -t"You feel fully prepared to cast your spell." -wdr drt_cast_area=\
  /dr cast %;\
  /set dr_spell_casting=no

; spell failure, or runout.
/def -t"Your concentration slips for a moment, and your spell is lost." -wdr drt_spell_lost=\
  /set dr_spell_casting=no
