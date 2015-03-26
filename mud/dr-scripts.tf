; On completion of this specific dtrain:
; /set dr_dtrain_on_complete=...

/def -p10 -h"SEND dtrain" -wdr dr_dtrain=\
  /echo ## Combat options: %;\
  /echo ## %;\
  /echo ## dtrain bow: stance to shield, wield bow. cycle: load, aim, dagger, hammer, hide, hunt. spells: ec 8 %;\
  /echo ## dtrain sling: Like bow, but with a sling. %;\
  /echo ## dtrain edge: Wield telek in right hand, stance to parry. cycle: dagger, hammer, hunt, hide, analyze. spells: devi 8%;\
  /echo ## dtrain blunt: Wield cudgel in right hand, stance to parry. cycle: dagger, hammer, hunt, hide, analyze. spells: devi 8%;\
  /echo ## %;\
  /echo ## dtrain outdoor: hold runestone. %;\
  /echo ##                 cycle: collect rock+kick pile, appraise runestone, focus runestone, appraise coat,%;\
  /echo ##                        perceive, appraise buckler, hunt, perform.%;\
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
  /set dr_cycle=load=~=aim=get throwing dagger=lob left=get throwing hammer=throw left=~=hide=~=hunt %;\
  /set dr_dtrain_on_complete=stow throwing dagger=stow throwing hammer

/def -p10 -h"SEND dtrain sling" -wdr dr_dtrain_sling=\
  /drc stance set 100 0 80 100 %;\
  /drc /dr_stow_hands %;\
  /drc get sling %;\
  /dr_spell_add prepare stw 8 %;\
  /dr_spell_add prepare ey 8 %;\
  /set dr_spell_cycle=target ec 8 %;\
  /set dr_cycle=load=~=aim=get throwing dagger=lob left=get throwing hammer=throw left=~=hide=~=hunt %;\
  /set dr_dtrain_on_complete=stow throwing dagger=stow throwing hammer

/def -p10 -h"SEND dtrain edge" -wdr dr_dtrain_edge=\
  /drc /dr_stow_hands %;\
  /drc wield telek %;\
  /drc stance set 100 80 0 100 %;\
  /dr_spell_add prepare ey 8 %;\
  /set dr_spell_cycle=target devi 8 %;\
  /set dr_cycle=get throwing dagger=lob left=get throwing hammer=throw left=~=hunt=~=hide=~=analyze=~=~ %;\
  /set dr_dtrain_on_complete=stow throwing dagger=stow throwing hammer

/def -p10 -h"SEND dtrain blunt" -wdr dr_dtrain_blunt=\
  /drc /dr_stow_hands %;\
  /drc wield cudgel %;\
  /drc stance set 100 80 0 100 %;\
  /dr_spell_add prepare ey 8 %;\
  /set dr_spell_cycle=target devi 8 %;\
  /set dr_cycle=get throwing dagger=lob left=get throwing hammer=throw left=~=hunt=~=hide=~=analyze=~=~ %;\
  /set dr_dtrain_on_complete=stow throwing dagger=stow throwing hammer

/def -p10 -h"SEND dtrain outdoor" -wdr dr_dtrain_outdoor=\
  /drc /dr_stow_hands %;\
  /drc get runestone %;\
  /set dr_spell_cycle=prep stw 8=prep compost 8=prep ey 8 %;\
  /set dr_cycle=collect rock=~=kick pile=~=appraise runestone=~=focus runestone=~=appraise buckler=~=perceive=~=hunt=~=appraise gweth %;\
  /set dr_dtrain_on_complete=/dr_stow_hands
