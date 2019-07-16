_TITLE "Pokefectionist"

' HTML HELPER VARIABLES
ALI_CEN$ = "ALIGN='CENTER'"
TABLE$ = "<TABLE BORDER='3' STYLE='BORDER: 3; WIDTH: 100%' " + ALI_CEN$ + ">"
TH$ = "<TH COLSPAN='3' STYLE='FONT-FAMILY: COURIER NEW; FONT-SIZE: 2EM'>PAGE "
TD_STYLE$ = "STYLE='BORDER: 1; WIDTH: 33%;"
COLLECTED_POKEMON$ = "<TD " + ALI_CEN$ + " " + TD_STYLE$ + " BACKGROUND-COLOR: #90EE90;'>"
UNCOLLECTED_POKEMON$ = "<TD " + ALI_CEN$ + " " + TD_STYLE$ + "'>"
BLANK_SPOT$ = "<TD " + ALI_CEN$ + " " + TD_STYLE$ + "'>---</TD>"

' SPLASH SCREEN
SPLASH:
COLOR 11
PRINT "                _ __"
PRINT "               ' )  )   /      /)      _/_                 _/_"
PRINT "                /--'__ /_  _  // _  _. /  o __ ____  o _   /"
PRINT "               /   (_)/ <_</_//_</_(__<__<_(_)/ / <_<_/_)_<__"
PRINT "                            />   a Pokemon collector's tool"
PRINT "                           </        By EthanThatOneKid"
PRINT

' GET NUMBER OF POKEMON
LOAD:
DIM GIMME_LAST_POKEMON AS STRING
HOW_MANY_POKEMON = 0
OPEN "save/pokemon.txt" FOR INPUT AS #1
DO UNTIL EOF(1)
    LINE INPUT #1, GIMME_LAST_POKEMON
    HOW_MANY_POKEMON = HOW_MANY_POKEMON + 1
LOOP
CLOSE #1

' GET POKEMON NAMES
DIM POKEMON(HOW_MANY_POKEMON) AS STRING
COUNTER = 1
OPEN "save/pokemon.txt" FOR INPUT AS #1
DO UNTIL EOF(1)
    LINE INPUT #1, POKEMON(COUNTER)
    COUNTER = COUNTER + 1
LOOP
CLOSE #1

' GET COMPLETION DATA
DIM HAS_POKEMON(HOW_MANY_POKEMON) AS STRING
IF _FILEEXISTS("save/save.txt") THEN
    OPEN "save/save.txt" FOR INPUT AS #1
    FOR i = 1 TO HOW_MANY_POKEMON
        IF EOF(1) THEN
            HAS_POKEMON(i) = "0"
        ELSE
            LINE INPUT #1, HAS_POKEMON(i)
        END IF
    NEXT
    CLOSE #1
ELSE
    FOR i = 1 TO HOW_MANY_POKEMON
        HAS_POKEMON(i) = "0"
    NEXT
END IF

' SAVE PROGRESS
SAVE:
OPEN "save/save.txt" FOR OUTPUT AS #1
FOR i = 1 TO HOW_MANY_POKEMON
    PRINT #1, HAS_POKEMON(i)
NEXT
CLOSE #1

' GENERATE_HTML
GENERATE_HTML:
DIM GIMME_LINE AS STRING
OPEN "output/pokefectionist.html" FOR OUTPUT AS #1
CURRENT_POKEMON = 1
FOR page = 1 TO _CEIL(HOW_MANY_POKEMON / 9)
    PRINT #1, TABLE$
    PRINT #1, TH$ + STR$(page) + "</TH>"
    FOR i = 1 TO 3
        PRINT #1, "<TR>"
        FOR j = 1 TO 3
            IF CURRENT_POKEMON <= HOW_MANY_POKEMON THEN
                IF HAS_POKEMON(CURRENT_POKEMON) = "1" THEN
                    PRINT #1, COLLECTED_POKEMON$
                ELSEIF HAS_POKEMON(CURRENT_POKEMON) = "0" THEN
                    PRINT #1, UNCOLLECTED_POKEMON$
                END IF
                PRINT #1, "(" + LTRIM$(STR$(CURRENT_POKEMON)) + ") " + POKEMON(CURRENT_POKEMON)
                PRINT #1, "</TD>"
                CURRENT_POKEMON = CURRENT_POKEMON + 1
            ELSE
                PRINT #1, BLANK_SPOT$
            END IF
        NEXT j
        PRINT #1, "</TR>"
    NEXT i
    PRINT #1, "</TABLE>"
NEXT page
CLOSE #1

' MAIN SELECTION
MAIN_MENU:
ADDING = 1
COLOR 15
PRINT "[A]dd or [D]elete or [E]xit: ";
DO: K$ = UCASE$(INKEY$)
LOOP UNTIL K$ = "A" OR K$ = "D" OR K$ = "E"
PRINT K$
IF K$ = "A" THEN ADDING = 1
IF K$ = "D" THEN ADDING = 0
IF K$ = "E" THEN END
INPUT "Pokedex number? ", POKEDEX_NUMBER
'POKEDEX_NUMBER                          = VAL(POKEDEX_NUMBER_STRING)
IF POKEDEX_NUMBER > 0 AND POKEDEX_NUMBER <= HOW_MANY_POKEMON THEN
    IF ADDING = 1 THEN
        HAS_POKEMON(POKEDEX_NUMBER) = "1"
        PRINT "Successfully added " + POKEMON(POKEDEX_NUMBER)
    ELSEIF ADDING = 0 THEN
        HAS_POKEMON(POKEDEX_NUMBER) = "0"
        PRINT "Successfully deleted " + POKEMON(POKEDEX_NUMBER)
    END IF
    GOTO SAVE
ELSE PRINT "Pokedex number is out of range"
END IF
GOTO MAIN_MENU
