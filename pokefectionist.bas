'a save file that contains a list of all the pokemon numbers that have been collected
'an html file that renders all the pokemon in 3x3 grids with a green background color if collected
'forever loop that asks if u wanna add or delete
'upon asking and deleting, save the new data and use that data to update the save file and the html file

ALI_CEN$ = "ALIGN='CENTER'"
TABLE$ = "<TABLE BORDER='3' STYLE='BORDER: 3; WIDTH: 100%' " + ALI_CEN$ + ">"
TH$ = "<TH COLSPAN='3' STYLE='FONT-FAMILY: COURIER NEW; FONT-SIZE: 2EM'>PAGE "
BORDER$ = "BORDER: 1"
COLLECTED_POKEMON$ = "<TD " + ALI_CEN$ + " STYLE='BACKGROUND-COLOR: GREEN; " + BORDER$ + "'>"
UNCOLLECTED_POKEMON$ =          "<TD " + ALI_CEN$ + " STYLE='" + BORDER$ + "'>"
BLANK_SPOT$ = "<TD " + ALI_CEN$ + " STYLE='" + BORDER$ + "'>---</TD>"

' GET NUMBER OF POKEMON
DIM GIMME_LAST_POKEMON AS STRING
HOW_MANY_POKEMON = 0
OPEN "pokemon.txt" FOR INPUT AS #1
DO UNTIL EOF(1)
    LINE INPUT #1, GIMME_LAST_POKEMON
    HOW_MANY_POKEMON = HOW_MANY_POKEMON + 1
LOOP
CLOSE #1

' GET POKEMON NAMES
DIM POKEMON(HOW_MANY_POKEMON) AS STRING
COUNTER = 1
OPEN "pokemon.txt" FOR INPUT AS #1
DO UNTIL EOF(1)
    LINE INPUT #1, POKEMON(COUNTER)
    COUNTER = COUNTER + 1
LOOP
CLOSE #1


' GET COMPLETION DATA
DIM HAS_POKEMON(HOW_MANY_POKEMON) AS STRING
OPEN "save.txt" FOR INPUT AS #1
FOR i = 1 TO HOW_MANY_POKEMON
    IF EOF(1) THEN
        HAS_POKEMON(i) = "0"
    ELSE
        LINE INPUT #1, HAS_POKEMON(i)
    END IF
NEXT
CLOSE #1

SAVE:
OPEN "save.txt" FOR OUTPUT AS #1
FOR i = 1 TO HOW_MANY_POKEMON
    PRINT #1, HAS_POKEMON(i)
NEXT
CLOSE #1

' GENERATE_HTML
DIM GIMME_LINE AS STRING
OPEN "pokefectionist.html" FOR OUTPUT AS #1
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
                PRINT #1, POKEMON(CURRENT_POKEMON)
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

