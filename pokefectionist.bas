_TITLE "Pokefectionist"

' HEAD
HEAD$ = "<HEAD>"
HEAD$ = HEAD$ + "<TITLE>Pok&eacute;fectionist</TITLE>"
HEAD$ = HEAD$ + "<link rel='shortcut icon' href='favicon.ico'>"
HEAD$ = HEAD$ + "</HEAD>"
HEAD$ = HEAD$ + "<STYLE>html, body { margin: 0; text-align: center; font-family: courier new; } h1 { margin: 0; }</STYLE>"
HEAD$ = HEAD$ + "<H1>Pok&eacute;fectionist</H1>"
HEAD$ = HEAD$ + "<SMALL ID='pc'></SMALL><BR>"
HEAD$ = HEAD$ + "<SMALL>see <A HREF='#legend'>legend</A></SMALL>"

' COLORS
COLLECTED_COLOR$ = "#8FFF91"
REVERSE_HOLOGRAPHIC_COLOR$ = "#82FFCB"
HOLOGRAPHIC_COLOR$ = "#E4FF82"

' HTML HELPER VARIABLES
ALI_CEN$ = "ALIGN='CENTER'"
TABLE$ = "<TABLE BORDER='3' STYLE='BORDER: 3; WIDTH: 100%' " + ALI_CEN$ + ">"
TH$ = "<TH COLSPAN='3' STYLE='FONT-FAMILY: COURIER NEW; FONT-SIZE: 2EM'>PAGE "
TD_STYLE$ = "STYLE='BORDER: 1; WIDTH: 33%;"
COLLECTED_POKEMON$ = "<TD " + ALI_CEN$ + " " + TD_STYLE$ + " BACKGROUND-COLOR: " + COLLECTED_COLOR$ + ";'>"
REVERSE_HOLOGRAPHIC_POKEMON$ = "<TD " + ALI_CEN$ + " " + TD_STYLE$ + " BACKGROUND-COLOR: " + REVERSE_HOLOGRAPHIC_COLOR$ + ";'>"
HOLOGRAPHIC_POKEMON$ = "<TD " + ALI_CEN$ + " " + TD_STYLE$ + " BACKGROUND-COLOR: " + HOLOGRAPHIC_COLOR$ + ";'>"
UNCOLLECTED_POKEMON$ = "<TD " + ALI_CEN$ + " " + TD_STYLE$ + "'>"
BLANK_SPOT$ = "<TD " + ALI_CEN$ + " " + TD_STYLE$ + "'>---</TD>"
SCRIPT$ = "<script>document.querySelector('#pc').textContent = `completion: ${Math.round(100 * [...document.querySelectorAll('td')].filter(el => !!el.style['background-color']).length / [...document.querySelectorAll('td')].length)}%`;</script>"

' LEGEND
LEGEND$ = "<TABLE ID='legend' BORDER='3' STYLE='BORDER: 3; WIDTH: 33%'>"
LEGEND$ = LEGEND$ + "<TH>Legend</TH>"
LEGEND$ = LEGEND$ + "<TR><TD " + ALI_CEN$ + " " + TD_STYLE$ + "'>Uncollected</TD></TR>"
LEGEND$ = LEGEND$ + "<TR>" + COLLECTED_POKEMON$ + "Collected</TD></TR>"
LEGEND$ = LEGEND$ + "<TR>" + REVERSE_HOLOGRAPHIC_POKEMON$ + "Collected (reverse holographic)</TD></TR>"
LEGEND$ = LEGEND$ + "<TR>" + HOLOGRAPHIC_POKEMON$ + "Collected (holographic)</TD></TR>"
LEGEND$ = LEGEND$ + "</TABLE>"

' SPLASH SCREEN
SPLASH:
COLOR 11
PRINT "                _ __"
PRINT "               ' )  )    /  /   /)      __/_ .       .    __/_"
PRINT "                /--'_  /_  _  / /_  __, /    _  __    _   /"
PRINT "               /   (_)/ <_</_//_</_(___<__<_(_)/ /_<_/_)_<__"
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
PRINT #1, HEAD$
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
                ELSEIF HAS_POKEMON(CURRENT_POKEMON) = "2" THEN
                    PRINT #1, REVERSE_HOLOGRAPHIC_POKEMON$
                ELSEIF HAS_POKEMON(CURRENT_POKEMON) = "3" THEN
                    PRINT #1, HOLOGRAPHIC_POKEMON$
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
PRINT #1, LEGEND$
PRINT #1, SCRIPT$
CLOSE #1

' MAIN SELECTION
MAIN_MENU:
ADDING = 1
COLOR 15
PRINT "[A]dd or add [R]everse or add [H]olo or [D]elete or [E]xit: ";
DO: K$ = UCASE$(INKEY$)
LOOP UNTIL K$ = "A" OR K$ = "R" OR K$ = "H" OR K$ = "D" OR K$ = "E"
PRINT K$
IF K$ = "A" THEN ADDING$ = "1"
IF K$ = "R" THEN ADDING$ = "2"
IF K$ = "H" THEN ADDING$ = "3"
IF K$ = "D" THEN ADDING$ = "0"
IF K$ = "E" THEN END
INPUT "Pokedex number? ", POKEDEX_NUMBER
IF POKEDEX_NUMBER > 0 AND POKEDEX_NUMBER <= HOW_MANY_POKEMON THEN
    IF ADDING$ = "1" OR ADDING$ = "2" OR ADDING$ = "3" THEN
        HAS_POKEMON(POKEDEX_NUMBER) = ADDING$
        PRINT "Successfully added " + POKEMON(POKEDEX_NUMBER)
    ELSEIF ADDING$ = "0" THEN
        HAS_POKEMON(POKEDEX_NUMBER) = "0"
        PRINT "Successfully deleted " + POKEMON(POKEDEX_NUMBER)
    END IF
    GOTO SAVE
ELSE PRINT "Pokedex number is out of range"
END IF
GOTO MAIN_MENU
