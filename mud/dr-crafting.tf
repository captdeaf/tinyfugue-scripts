; Dragonrealms crafting scripts.
;

; /set dr_crafting=

;;; Outfitting
; craft item, maybe eventually macro it.
; /def -p10 -h"SEND craft *" -wdr dr_craft=???

; Swapping backpacks in the vault.
; I have:
;   tan: Tailoring
;   red: forging
;   black: engineering
;   green: adventuring (default)
;
; vaultswap <color>, while standing in carousel, will go through ironwood
; arch, pull lever, etc etc, place all backpacks in vaults, then get
; the desired backpack. It also auto-sets the "store default"
/def -p10 -h"SEND vaultswap *" -mglob -wdr dr_vault_swap_backpack=\
  /let color=%{-1} %;\
  /dr_stow %{dr_lhand} %;\
  /dr_stow %{dr_rhand} %;\
  /drc go ironwood arch=pull lever=go door=open vault %;\
  /drc remove backpack=put my backpack in vault%;\
  /drc get %{color} backpack from vault %;\
  /drc wear my backpack=store default in my backpack %;\
  /drc close vault=go door=go arch

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Tanning, for tailoring leather armor from my own kills.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/def -p10 -h"SEND tan *" -mglob -wdr dr_tan_item=\
  /let item=%{-1} %;\
  /set dr_crafting=$(/last %{item}) %;\
  /echo "Scraping '%{item}'" %;\
  /dr get %{item} from bundle %;\
  /dr get hide scraper %;\
  /dr scrape %{dr_crafting} with scraper careful %;\
  /set dr_cycle=scrape %{dr_crafting} with scraper careful

; Complete tanning.
/def -mglob -t"The * looks as clean as you can make it." -wdr dr_craft_scrape_done=\
  /drc stow my hide scraper %;\
  /drc get tanning lotion=pour tanning lotion on %{dr_crafting}=~=stow tanning lotion=stow %{dr_crafting} %;\
  /set dr_cycle=

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Tailoring.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/def -p10 -h"SEND tcut * * *" -mglob -wdr dr_tailor_cut=\
  /let mat=%{-3} %;\
  /let count=%{2} %;\
  /let len=%{3} %;\
  /drc get %{mat} from back %;\
  /repeat -1 %{count} /drc get yardstick=mark my %{mat} to %{len} yards=stow my yardstick=get scissors=cut my %{mat} with my scissors=stow my scissors %;\
  /repeat -$[1+%{count}] 1 /drc stow my %{mat}=/repeat -1 %{count} \drc stow %{mat}

/def -p10 -h"SEND tailor * *" -mglob -wdr dr_tailor_start=\
  /set dr_crafting=%{-2} %;\
  /echo Crafting '%{-2}', from '%{2}' %;\
  /drc study my book=~=stow my book=get scissors=cut my %{2} with my scissors=~=stow my scissors %;\
  /set dr_cycle=/dr_sew_it

/def dr_tailor_done=\
  /drc get logbook=bundle my %{dr_crafting} with my logbook=stow my logbook=get book

; Tailoring needs
/def -p10 -h"SEND sew *" -mglob -wdr dr_sew=\
  /set dr_crafting=%{-1} %;\
  /set dr_cycle=/dr_sew_it

/def dr_sew_it=\
  /drc get sewing needles=push my %{dr_crafting} with my needles=~=stow my sewing needles

/def -mglob -t"* dimensions appear to have shifted and could benefit from some remeasuring." -wdr dr_craft_measure=\
  /drc get yardstick=~=measure my %{dr_crafting} with my yardstick=~=stow my yardstick

/def -mglob -t"With the measuring complete, now it is time to cut away more*" -wdr dr_craft_cut=\
  /drc get scissors=~=cut my %{dr_crafting} with my scissors=~=stow my scissors

/def -mglob -t"* and could use some pins to *" -wdr dr_craft_pin=\
  /drc get pins=~=poke my %{dr_crafting} with my pins=~=stow my pins

/def -mglob -t"* deep crease develops along *" -wdr dr_craft_slickstone=\
  /drc get slickstone=~=rub my %{dr_crafting} with my slickstone=~=stow my slickstone

/def -mglob -t"* wrinkles from all the handling and could use *" -wdr dr_craft_slickstone_2=\
  /dr_craft_slickstone

/def -mglob -t"*One leather piece is too thick for the needle to penetrate *" -wdr dr_craft_awl=\
  /drc get awl=~=poke my %{dr_crafting} with my awl=~=stow my awl

/def -mglob -t"*A critical section of leather needs holes punched*" -wdr dr_craft_awl_2=\
  /dr_craft_awl

/def -mglob -t"You need another finished small cloth padding*" -wdr dr_craft_padding_small=\
  /drc get small padding=~=assemble my %{dr_crafting} with my padding

/def -mglob -t"You need another finished a large cloth padding*" -wdr dr_craft_padding_large=\
  /drc get large padding=~=assemble my %{dr_crafting} with my padding

/def -mglob -t"You need another finished leather shield handle*" -wdr dr_craft_shield=\
  /drc get shield handle=~=assemble my %{dr_crafting} with my shield handle

/def -mglob -t"You need another finished long leather cord*" -wdr dr_craft_cord=\
  /drc get long cord=~=assemble my %{dr_crafting} with my long cord

/def -mglob -t"You cannot figure out how to do that*" -wdr dr_craft_complete_1=\
  /set dr_cycle= %;\
  /echo Crafting %{dr_crafting} complete, badly?. Clearing cycle.

/def -mglob -t"You realize that cannot be repaired, and stop*" -wdr dr_craft_complete_2=\
  /set dr_cycle= %;\
  /echo Crafting %{dr_crafting} complete, badly?. Clearing cycle.

/def -mglob -t"*not damaged enough to*" -wdr dr_craft_complete_3=\
  /set dr_cycle= %;\
  /echo Crafting %{dr_crafting} complete, badly?. Clearing cycle.

/def -mglob -t"Applying the final touches, you complete working*" -wdr dr_craft_complete_4=\
  /set dr_cycle= %;\
  /echo Crafting %{dr_crafting} complete. Clearing cycle. %;\
  /dr_tailor_done

; Knitting needs
/def -p10 -h"SEND knit *" -mglob -wdr dr_knit=\
  /set dr_crafting=%{-1} %;\
  /drc study book=~=stow my book=get knitting needles=get yarn=knit my yarn with my needles=~=stow my yarn %;\
  /set dr_cycle=knit my needles

/def -mglob -t"Now the needles must be turned*" -wdr dr_craft_knit_turn=\
  /drc turn my needles

/def -mglob -t"Some ribbing should be added next*" -wdr dr_craft_knit_turn_2=\
  /dr_craft_knit_turn

/def -mglob -t"Next the needles must be pushed" -wdr dr_craft_knit_push=\
  /drc push my needles

/def -mglob -t"* ready to be pushed *" -wdr dr_craft_knit_push_2=\
  /dr_craft_knit_push

/def -mglob -t"The garment is nearly complete and now must be cast off*" -wdr dr_craft_knit_cast=\
  /drc cast my needles=~=stow my needles

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Engineering - Carving, bone and stone.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/def -p10 -h"SEND unstack *" -mglob -wdr dr_carving_unstack=\
  /let count=%{2} %;\
  /drc get stack=mark stack at %{count} pieces %;\
  /drc get bone saw=cut my stack with my bone saw=stow my bone saw %;\
  /drc stow stack=get stack

; Bonecarving loop.
/def -p10 -h"SEND bcarve *" -mglob -wdr dr_carve_bones=\
  /set dr_crafting=%{-1} %;\
  /echo Crafting '%{dr_crafting}', from 'bone stack' %;\
  /drc study my book=~=stow my book=get bone saw=~=carve my stack with my bone saw=~=stow my bone saw %;\
  /set dr_cycle=/dr_saw_it

/def dr_saw_it=\
  /drc get bone saw=carve my %{dr_crafting} with my bone saw=~=stow my bone saw

/def -mglob -t"Once finished you realize the * has developed an uneven texture along its surface." -wdr dr_craft_rasp=\
  /drc get rasp=scrape my %{dr_crafting} with my rasp=~=stow rasp

/def -mglob -t"When you have finished working you determine the * is uneven." -wdr dr_craft_rasp_2=\
  /dr_craft_rasp

; Haven't seen this yet, but it's there..
/def -mglob -t"nomatchmefoo" -wdr dr_craft_polish_1=\
  /drc get polish=apply polish to %{dr_crafting}=~=stow polish

; Or this:
; If the carving results in jagged edges, RUB <item> WITH RIFFLERS.

/def -mglob -t"nomatchmefoo2" -wdr dr_craft_riffler_1=\
  /drc get rifflers=rub %{dr_crafting} with rifflers=~=stow rifflers
