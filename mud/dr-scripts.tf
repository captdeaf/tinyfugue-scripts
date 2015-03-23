; Just stuff in here that should eventually be made into a script.
;
; Generic loaded-aimed-fired weapon in combat:

/set dr_cycle=load=~=aim=~=hunt=~=hide=~=hunt

; Ditto, but throwing with left hand.
/set dr_cycle=load=~=aim=~=get throwing dagger=~=lob left=~=hide=~=hunt

; Throwing both hammer and dagger in combat, with hide and appraise trained.
/set dr_cycle=get hammer=get throwing dagger=hide=~=lob right=~=lob left=~=appraise ENEMY

; Melee
/set dr_cycle=hide=~=analyze=~=prep ec 4=~=hunt


; In-town, train almost everything not combat-related.
; Need to be holding a runestone and wearing coat.
; Need to be in a place to collect rocks.

/set dr_cycle=hunt=~=collect rock=~=prep stw 4=~=kick pile=~=scout cover my tracks=~=appraise runestone=~=collect rock=~=kick pile=hunt=~=focus runestone=~=prep compost 4=~=focus runestone=~=appraise coat=~=perceive=~=collect rock=~=kick pile=~=prep ey 5=~=focus runestone=~=appraise buckler
