'a save file that contains a list of all the pokemon numbers that have been collected
'an html file that renders all the pokemon in 3x3 grids with a green background color if collected
'forever loop that asks if u wanna add or delete
'upon asking and deleting, save the new data and use that data to update the save file and the html file

' GET NUMBER OF POKEMON
DIM GIMME_LAST_POKEMON AS STRING
HOW_MANY_POKEMON = 0
OPEN "pokemon.txt" FOR INPUT AS #1
DO UNTIL EOF(1)
    LINE INPUT #1, GIMME_LAST_POKEMON
    HOW_MANY_POKEMON = HOW_MANY_POKEMON + 1
LOOP
CLOSE #1

' GET COMPLETION DATA
DIM POKEMON(HOW_MANY_POKEMON) AS STRING
OPEN "save.txt" FOR INPUT AS #1
FOR i = 1 TO HOW_MANY_POKEMON
    IF EOF(1) THEN
        POKEMON(i) = "0"
    ELSE
        LINE INPUT #1, POKEMON(i)
    END IF
NEXT



