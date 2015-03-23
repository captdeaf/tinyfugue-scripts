;; Main account - Connects by default
/def -p9999 -mglob -h'CONNECT dr' \
	hook_DR=/quote -S -wdr \
        !"~/.tf/mud/dragonrealms.login.pl ACCOUNTNAME PASSWORD CHARACTER 2>/dev/null" %; \
        /send -wdr "/FE:WIZARD /VERSION:2.02 /P:WIN32" %;\
        /send -wdr %;\
        /send -wdr %;\
	/set emulation=ansi_attr
