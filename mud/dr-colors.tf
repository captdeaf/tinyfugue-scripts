;; Skills

; Wipe all previously set colors.
/purge dra_*

; Used for marking all colorations dra_##
/set dra_id=0

; /dra_color_it <color>=<regexp>
/def dra_color_it=\
  /split %{*} %;\
  /let color=%{P1} %;\
  /let text=%{P2} %;\
  /set dra_id=$[1+%{dra_id}] %;\
  /def -wdr -F -p66 -PhC%{color} -mregexp -t'%{text}' dra_%{dra_id} 

; /dra_color_many <color>=<pattern1>=<pattern2>=<pattern3>, separated by =.
; If you need = in the pattern, then use dra_color_it.
/def dra_color_many=\
  /split %{*} %;\
  /let color=%{P1} %;\
  /let items=%{P2} %;\
  /split %{items} %;\
  /let cur=%{P1} %;\
  /let rest=%{P2} %;\
  /dra_color_it %{color}=%{cur} %;\
  /if (strlen(%{rest})) \
    /repeat -0 1 /dra_color_many %{color}=%{rest} %;\
  /endif

; Color all skills to be yellow
/dra_color_many yellow=Shield Usage:=Light Armor:=Chain Armor:=Brigandine:=Plate Armor:=Defending:=Parry Ability:
/dra_color_many yellow=Small Edged:=Large Edged:=Twohanded Edged:=Small Blunt:=Large Blunt:=Twohanded Blunt:
/dra_color_many yellow=Slings:=Bow:=Crossbow:=Staves:=Polearms:=Light Thrown:=Heavy Thrown:=Brawling:
/dra_color_many yellow=Offhand Weapon:=Melee Mastery:=Missile Mastery:
/dra_color_many yellow=Life Magic:=Attunement:=Arcana:=Targeted Magic:
/dra_color_many yellow=Augmentation:=Debilitation:=Utility:=Warding:=Sorcery:
/dra_color_many yellow=Evasion:=Athletics:=Perception:=Stealth:=Locksmithing:=First Aid:
/dra_color_many yellow=Outdoorsmanship:=Skinning:=Scouting:=Engineering:=Outfitting:=Scholarship:
/dra_color_many yellow=Mechanical Lore:=Appraisal:=Performance:=Tactics:

/dra_color_it red=mind lock\\s+\\(34/34\\)

; Color paths and exits. These are regexps.
/dra_color_it yellow=^Obvious paths:.*
/dra_color_it yellow=^Obvious exits:.*

; Room / area title.
/dra_color_it magenta=^\\[.*\\]

; You speaking, in green.
/dra_color_it green=^\\w+ \\w*\\s*(say|hiss|ask|exclaim|growl|yell)(\\sin \\w+)?,

; Somebody else speaking, in green.
/dra_color_it green=^\\w+ \\w*\\s*(says|hisses|asks|exclaims|yells|growls)(\\sin \\w+)?,

; No significant injuries
/dra_color_it cyan=^You have no significant injuries.
/dra_color_it cyan=^Your body feels at full strength.
/dra_color_it cyan=^Your spirit feels full of life.
/dra_color_it red=^.* touches you.$

/dra_color_it cyan=^Also in (the )?room: 
/dra_color_it cyan=^Also here: 
/dra_color_it cyan=^\\s*You also see

; Best shot:
/dra_color_it bgred=^You think you have your best shot possible now.
