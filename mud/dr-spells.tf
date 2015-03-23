; Dragonrealms scripts.
;

;;; Spell queue.
/set dr_spellqueue=
/set dr_casting=

; ecc: eagle's cry at chest
/def -p10 -h"SEND ecc" -wdr dr_ecc=/dr prep ec 5=target

; autocasts: Cast and pop off casting
/def -mglob -t"Your formation of a targeting*has completed." -wdr drt_cast_target=\
  /dr cast %;\
  /dr_spell_dequeue

/def -t"You feel fully prepared to cast your spell." -wdr drt_cast_area=\
  /dr cast %;\
  /dr_spell_dequeue

; spell failure, or runout.
/def -t"Your concentration slips for a moment, and your spell is lost." -wdr drt_spell_lost=\
  /dr_spell_dequeue

/def dr_spell_dequeue=/echo -wdr Spell complete.

; Rebuffs:
; See the wind
; /set dr_stw=4
; /def -t"The glowing lines fade away along with the See the Wind spell." -wdr drt_recast_stw=/dr prep stw %{dr_stw}

; Athleticism
; /set dr_ath=4
; /def -t"You feel a sudden drain of energy, for a moment barely able to keep yourself upright." -wdr drt_recast_ath=/dr prep ath %{dr_ath}


; Ease Burden (divine charm)
; You feel a weight settle over you, and realize the magic that has been easing your burden has faded.

