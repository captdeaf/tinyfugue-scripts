; Dragonrealms crafting scripts.
;

; /set dr_crafting=

;;; Outfitting
; craft item, maybe eventually macro it.
; /def -p10 -h"SEND craft *" -wdr dr_craft=???

; Added "get %{dr_crafting}" for stonecarving.
/def dr_craft_bundle=\
  /drc get logbook=get %{dr_crafting}=bundle my %{dr_crafting} with my logbook=stow my logbook=get book

/def -mglob -t"Applying the final touches, you complete working*" -wdr dr_craft_complete=\
  /set dr_cycle= %;\
  /repeat -1 1 /echo Crafting %{dr_crafting} complete. Clearing cycle. %;\
  /dr_craft_bundle

/def -t"That tool does not seem suitable for that task." -wdr dr_craft_stop=\
  /set dr_cycle= %;\
  /repeat -1 1 /echo Crafting incomplete - Wrong tool? Cycle cleared.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Tanning, for tailoring leather armor from my own kills.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/def -p10 -h"SEND tan *" -mglob -wdr dr_craft_tan_item=\
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
; tcut 1 8 leather # will make 1 strip of leather 8 yards long.
; You should be holding nothing.
/def -p10 -h"SEND tcut * * *" -mglob -wdr dr_craft_tailor_cut=\
  /let mat=%{-3} %;\
  /let count=%{2} %;\
  /let len=%{3} %;\
  /drc get %{mat} from back %;\
  /repeat -1 %{count} /drc get yardstick=mark my %{mat} to %{len} yards=stow my yardstick=get scissors=cut my %{mat} with my scissors=stow my scissors %;\
  /repeat -$[1+%{count}] 1 /drc stow my %{mat}=~$[strrep(strcat("=stow ",%{mat}), %{count})]

/def -p10 -h"SEND tailor * *" -mglob -wdr dr_craft_tailor_start=\
  /set dr_crafting=%{-2} %;\
  /echo Crafting '%{-2}', from '%{2}' %;\
  /drc study my book=~=stow my book=get scissors=cut my %{2} with my scissors=~=stow my scissors %;\
  /set dr_cycle=/dr_craft_sew_it

; Tailoring needs
/def -p10 -h"SEND sew *" -mglob -wdr dr_craft_sew=\
  /set dr_crafting=%{-1} %;\
  /set dr_cycle=/dr_craft_sew_it

/def dr_craft_sew_it=\
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
  /repeat -1 1 /echo Crafting %{dr_crafting} complete, badly?. Clearing cycle.

/def -mglob -t"You realize that cannot be repaired, and stop*" -wdr dr_craft_complete_2=\
  /set dr_cycle= %;\
  /repeat -1 1 /echo Crafting %{dr_crafting} complete, badly?. Clearing cycle.

/def -mglob -t"*not damaged enough to*" -wdr dr_craft_complete_3=\
  /set dr_cycle= %;\
  /repeat -1 1 /echo Crafting %{dr_crafting} complete, badly?. Clearing cycle.

; Knitting needs
/def -p10 -h"SEND knit *" -mglob -wdr dr_craft_knit=\
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
; unstack 1 3 will create one stack of 3 bones.
/def -p10 -h"SEND unstack * *" -mglob -wdr dr_craft_carving_unstack=\
  /let count=%{2} %;\
  /let num=%{3} %;\
  /drc get stack from back=get bone saw %;\
  /repeat -1 %{count} /drc mark my stack at %{num} pieces=cut my stack with my bone saw %;\
  /repeat -$[1+%{count}] 1 /drc stow my bone saw=stow my stack=~$[strrep("=stow stack",%{count})]

; Bonecarving loop.
/def -p10 -h"SEND bcarve *" -mglob -wdr dr_craft_carve_bones=\
  /set dr_crafting=%{-1} %;\
  /echo Crafting '%{dr_crafting}', from 'bone stack' %;\
  /drc study my book=~=stow my book=get bone saw=~=carve my stack with my bone saw=~=stow my bone saw %;\
  /set dr_cycle=/dr_craft_saw_it

; Stonecarving loop
/def -p10 -h"SEND scarve * *" -mglob -wdr dr_craft_carve_stones=\
  /let mat=%{2} %;\
  /set dr_crafting=%{-2} %;\
  /echo Crafting '%{dr_crafting}', from '%{mat}' %;\
  /drc study my book=~=stow my book=get chisel=tap deed=~=carve %{mat} with my chisel=~=stow my chisel %;\
  /set dr_cycle=/dr_craft_chisel_it

/def dr_craft_chisel_it=\
  /drc get chisel=carve %{dr_crafting} with my chisel=~=stow my chisel

/def dr_craft_saw_it=\
  /drc get bone saw=carve my %{dr_crafting} with my bone saw=~=stow my bone saw

/def -mglob -t"Once finished you realize the * has developed an uneven texture along its surface." -wdr dr_craft_rasp=\
  /drc get rasp=scrape my %{dr_crafting} with my rasp=~=stow rasp

/def -mglob -t"When you have finished working you determine the * is uneven." -wdr dr_craft_rasp_2=\
  /dr_craft_rasp

; Haven't seen this yet, but it's there..
/def -mglob -t"Upon finishing you see some discolored areas on the *" -wdr dr_craft_polish=\
  /drc get polish=apply polish to %{dr_crafting}=~=stow polish

; Or this:
; If the carving results in jagged edges, RUB <item> WITH RIFFLERS.

/def -mglob -t"Upon completion you notice several rough, jagged *" -wdr dr_craft_riffler=\
  /drc get rifflers=rub %{dr_crafting} with rifflers=~=stow rifflers

