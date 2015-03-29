; On completion of this specific dtrain:
; /set dr_dtrain_on_complete=...

/def -p10 -h"SEND dtrain" -wdr dr_dtrain=\
  /echo ## Combat options: %;\
  /echo ## %;\
  /echo ## dtrain bow: stance to shield, wield bow. cycle: load, aim, dagger, hammer, hide, hunt. spells: ec 8 %;\
  /echo ## dtrain sling: Like bow, but with a sling. %;\
  /echo ## dtrain melee (weapon): Wield weapon in right hand, stance to parry. cycle: dagger, hammer, hunt, hide, analyze. spells: devi 8%;\
  /echo ## %;\
  /echo ## dtrain outdoor: hold runestone. %;\
  /echo ##                 cycle: collect rock+kick pile, appraise runestone, focus runestone, %;\
  /echo ##                        perceive, appraise buckler, hunt, appraise gweth.%;\
  /echo ##                spells: stw 8, compost 8, ey 8%;\
  /echo ## %;\
  /echo ## dtrain done: The clean way to end these, rather than 'oops' %;\
  /echo ## %;\
  /echo ##

; /set dr_dtrain_on_complete=...
/def dr_dtrain_complete=\
  /if (strlen(%{dr_dtrain_on_complete})) \
    /drc %{dr_dtrain_on_complete} %;\
  /endif %;\
  /set dr_dtrain_on_complete=

/def -p10 -h"SEND dtrain done" -wdr dr_dtrain_done=\
  /drc stance set 100 0 80 100 %;\
  /dr_dtrain_complete %;\
  /set dr_cycle= %;\
  /set dr_spell_cycle= %;\
  /set dr_spell_queue=

/def -p10 -h"SEND dtrain bow" -wdr dr_dtrain_bow=\
  /drc stance set 100 0 80 100 %;\
  /drc /dr_stow_hands %;\
  /drc remove long %;\
  /dr_spell_add prepare stw 8 %;\
  /dr_spell_add prepare ey 8 %;\
  /set dr_spell_cycle=target ec 8 %;\
  /set dr_cycle=load=~=aim=get throwing dagger=lob left=~=get throwing hammer=throw left=~=hide=~=hunt %;\
  /set dr_dtrain_on_complete=stow throwing dagger=stow throwing hammer

/def -p10 -h"SEND dtrain sling" -wdr dr_dtrain_sling=\
  /drc stance set 100 0 80 100 %;\
  /drc /dr_stow_hands %;\
  /drc get sling %;\
  /dr_spell_add prepare stw 8 %;\
  /dr_spell_add prepare ey 8 %;\
  /set dr_spell_cycle=target ec 8 %;\
  /set dr_cycle=load=~=aim=get throwing dagger=lob left=~=get throwing hammer=throw left=~=hide=~=hunt %;\
  /set dr_dtrain_on_complete=stow throwing dagger=stow throwing hammer

/def -p10 -h"SEND dtrain melee *" -wdr dr_dtrain_melee=\
  /let weapon=%{-2} %;\
  /drc /dr_stow_hands %;\
  /drc wield %{weapon} %;\
  /drc stance set 100 80 0 100 %;\
  /dr_spell_add prepare ey 8 %;\
  /set dr_spell_cycle=target devi 8 %;\
  /set dr_cycle=get throwing dagger=lob left=~=get throwing hammer=throw left=~=hunt=~=hide=~=analyze=~=~ %;\
  /set dr_dtrain_on_complete=stow throwing dagger=stow throwing hammer

/def -p10 -h"SEND dtrain outdoor" -wdr dr_dtrain_outdoor=\
  /drc /dr_stow_hands %;\
  /drc get runestone %;\
  /set dr_spell_cycle=prep stw 8=prep compost 8=prep ey 8 %;\
  /set dr_cycle=collect rock=~=kick pile=~=appraise runestone=~=focus runestone=~=appraise buckler=~=perceive=~=hunt=~=appraise gweth %;\
  /set dr_dtrain_on_complete=/dr_stow_hands

; Clear queue, send complete, save cycle to "fight"
; There is nothing else to face!
/def -t"There is nothing else to face!" -mglob -wdr drt_stopcycle_fighting=\
  /set dr_fight_cycle=%{dr_cycle} %;\
  /set dr_fight_spell_cycle=%{dr_spell_cycle} %;\
  /set dr_cycle= %;\
  /set dr_spell_cycle= %;\
  /drc %{dr_dtrain_on_complete}
