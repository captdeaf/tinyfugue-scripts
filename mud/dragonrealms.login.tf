;; Main account - Connects by default
/def -p9999 -mglob -h'CONNECT dr' \
	hook_DR=/quote -S -wdr \
        !"~/.tf/mud/dragonrealms.login.pl ACCOUNTNAME PASSWORD CHARACTER 2>/dev/null" %; \
        /repeat -1 1 send -wdr "/FE:WIZARD /VERSION:2.02 /P:WIN32" %;\
        /repeat -2 2 send -wdr %;\
	/set emulation=ansi_attr
