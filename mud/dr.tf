; Dragonrealms scripts. Macros and convenience here.
;

; Ignore the prompts.
/def -wdr -h"PROMPT *" -ag -mglob dr_prompt=

; What's carried in my hands?

/def -ag -F -p9 -mregexp -wdr -t"^\034?GSm.{30}(\S.*\S)\s*$" dr_get_rhand=\
  /set dr_rhand=%{P1}

/def -ag -F -p9 -mregexp -wdr -t"^\034?GSl.{30}(\S.*\S)\s*$" dr_get_lhand=\
  /set dr_lhand=%{P1}

/def -ag -F -p20 -mregexp -wdr -t"^\034?GSmEmpty\s*$" dr_get_rhand_empty=\
  /set dr_rhand=

/def -ag -F -p20 -mregexp -wdr -t"^\034?GSlEmpty\s*$" dr_get_lhand_empty=\
  /set dr_lhand=

/def dr_stow=\
  /if (%{*} !~ "") \
    /if (%{*} =~ "longbow") \
      /dr unload=~=stow my arrow=wear my longbow %;\
    /elseif (%{*} =~ "sling") \ \
      /dr unload=~=stow my rock=stow my sling %;\
    /else \
      /dr stow my %{*} %;\
    /endif %;\
  /endif

/def dr_stow_hands=\
  /dr_stow %{dr_lhand} %;\
  /dr_stow %{dr_rhand}

; Who am I facing?
/def -F -p9 -mregexp -wdr -t"You turn to face (\S.+?)[,.]" dr_get_enemy=\
  /set dr_enemy=%{P1}

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
