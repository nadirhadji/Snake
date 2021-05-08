; Document ecrit par :
; Nadir Hadji   ( HADN08069703 )

;main
snake:           STRO        intro,d
                 CALL        prntTab

                 LDA         0,i
while:           CPA         0,i
                 BRNE        resultat

                 STRO        msgSoll,d
                 CALL        creerS
                 CALL        chargerS
                 CALL        prntTab
                 CALL        verifFin
                 BR          while

resultat:        CALL        score
                 STOP

;Fonction qui sert a afficher le plateau de jeu
prntTab: SUBSP   10,i ;WARNING: Number of bytes allocated (10) not equal to number of bytes listed in trace tag (0).
         STRO    msgX,d
         LDA     0,i
         STA     iPrint,s
         LDX     iPrint,s
         STX     iPrint,s

i_loop2: CPX     16,i
         BRGT    fin2
         LDA     iPrint,s
         ADDA    2,i
         ASRA
         STA     compteur,s
         DECO    compteur,s
         CHARO   '|',i
         LDX     0,i
         STX     jPrint,s

j_loop2: CPX     36,i
         BRGE    next_i2     ;    for(X=0;X<18;X+=1) {
         LDX     iPrint,s
         LDA     plateau,x
         STA     ptr2,s       ;       ptr -> vecteur[i]
         LDX     ptr2,s
         ADDX    jPrint,s     ;       X -> vecteur[i][j]
         STX     ptr2,s

         LDA     ptr2,sf
         STA     ptr2,s
         CPA     0,i
         BREQ    nulle
         BR      nonNulle

nulle:   CHARO   ' ',i
         BR      suite

nonNulle:LDX     ptr2,s
         CHARO   0,x
         BR      suite

suite:   LDX     jPrint,s
         ADDX    2,i
         STX     jPrint,s
         BR      j_loop2      ;   } //fin for j

next_i2: LDX     iPrint,s
         ADDX    2,i
         STX     iPrint,s
         CHARO   '|',i
         CHARO   '\n',i
         BR      i_loop2      ; } // fin for i

fin2:    STRO    msgLigne,d
         ADDSP   10,i ;WARNING: Number of bytes deallocated (10) not equal to number of bytes listed in trace tag (0).
         RET0

compteur: .EQUATE 0            ; #2d affichage numero de la rangée
ptr2:     .EQUATE 2            ; #2h
iPrint:   .EQUATE 4            ; #2d itétareur iPrint pour afficher la partie
jPrint:   .EQUATE 6            ; #2d itétareur jPrint pour afficher la partie
tab:      .EQUATE 8

;Creer le maillon de depart d'un serpent ( en sortant de la methode, le registre X va contenir l'adresse de la queue du serpent)
departS:  SUBSP  4,i ;WARNING: Number of bytes allocated (4) not equal to number of bytes listed in trace tag (0).

          CHARI    collBuff,d
          LDBYTEA  collBuff,d
          SUBA     65,i
          CALL     vldColl
          STA      collSP,s

          CHARI    rangBuff,d
          LDBYTEA  rangBuff,d
          SUBA     49,i
          CALL     vldRang
          STA      rangSP,s

          LDA     mLength,i
          CALL    new
          STX     head,d

          LDA     0,i
          LDBYTEA est,d
          STBYTEA 0,x
          ADDX    1,i
          LDA     rangSP,s
          STA     0,x
          ADDX    2,i
          LDA     collSP,s
          STA     0,x
          ADDX    2,i
          LDA     0,i
          STA     0,x
          SUBX    5,i
          STX     head,d

          ADDSP  4,i ;WARNING: Number of bytes deallocated (4) not equal to number of bytes listed in trace tag (0).
          RET0

collSP:          .EQUATE 0
rangSP:          .EQUATE 2

;creer le serpent
creerS:          SUBSP   6,i ;WARNING: Number of bytes allocated (6) not equal to number of bytes listed in trace tag (0).

                 CALL    departS
                 STX     ombre1,s
                 LDA     0,i
                 STA     courant1,s

loop:            LDA     0,i
                 STA     dir22,s
                 CHARI   direBuff,d
                 LDBYTEA direBuff,d
                 STA     dir22,s

                 LDX     head,d

                 CPA     10,i
                 BREQ    fCreerS
                 CPA     45,i             ; -
                 BREQ    callDS
                 CPA     100,i            ; d
                 BREQ    callD
                 CPA     103,i            ; g
                 BRNE    creerErr
                 BR      callG

callDS:          CALL    devantS
                 STX     courant1,s
                 BR      nextM

callD:           CALL    droite
                 STX     courant1,s
                 BR      nextM

callG:           CALL    gauche
                 STX     courant1,s
                 BR      nextM

nextM:           LDX     courant1,s
                 STX     ombre1,s
                 BR      loop

creerErr:        STRO        msgErr,d
                 STRO        msgSoll,d
                 LDA         0,i
                 STA         courant1,d
                 BR          fCreerS

fCreerS:         LDA         courant1,s
                 ADDSP       6,i ;WARNING: Number of bytes deallocated (6) not equal to number of bytes listed in trace tag (0).
                 RET0

ombre1:          .EQUATE     0
courant1:        .EQUATE     2
dir22:           .EQUATE     4


;A l'entrée il y'a dans A : le caractere en entrée /et/ dans X : l'adresse du maillon precedent.
;Creer et lier un maillon apres le courant ( caractere - ) ( mettre dans le registre X l'adresse du nouveau maillon creer)
devantS:         SUBSP       9,i ;WARNING: Number of bytes allocated (9) not equal to number of bytes listed in trace tag (0).

                 LDA         head,d
                 STA         prevDS,s

                 LDA         0,i
                 LDBYTEA     head,n
                 STBYTEA     dirDS,s

                 ADDX        1,i
                 STX         rangDS,s
                 LDA         rangDS,sf
                 STA         rangDS,s

                 ADDX        2,i
                 STX         collDS,s
                 LDA         collDS,sf
                 STA         collDS,s

                 LDBYTEA     dirDS,s
                 CPA         62,i
                 BREQ        newEST
                 CPA         118,i
                 BREQ        newSUD
                 CPA         60,i
                 BREQ        newWest
                 CPA         94,i
                 BREQ        newNORD

                 STRO        zebi,d
                 STOP

newEST:          LDA         collDS,s
                 ADDA        1,i
                 CALL        vldColl
                 STA         collDS,s
                 BR          nextMS

newSUD:          LDA         rangDS,s
                 ADDA        1,i
                 CALL        vldRang
                 STA         rangDS,s
                 BR          nextMS

newWest:         LDA         collDS,s
                 SUBA        1,i
                 CALL        vldColl
                 STA         collDS,s
                 BR          nextMS


newNORD:         LDA         rangDS,s
                 SUBA        1,i
                 CALL        vldRang
                 STA         rangDS,s
                 BR          nextMS

nextMS:          LDA         mLength,i
                 CALL        new
                 STX         head,d

                 LDA         0,i
                 LDBYTEA     dirDS,s
                 STBYTEA     0,x

                 ADDX        1,i
                 LDA         rangDS,s
                 STA         0,x

                 ADDX        2,i
                 LDA         collDS,s
                 STA         0,x

                 ADDX        2,i
                 LDA         prevDS,s
                 STA         0,x

                 SUBX        5,i

                 ADDSP       9,i ;WARNING: Number of bytes deallocated (9) not equal to number of bytes listed in trace tag (0).
                 RET0

dirDS:           .EQUATE     0
collDS:          .EQUATE     1
rangDS:          .EQUATE     3
courtDS:         .EQUATE     5
prevDS:          .EQUATE     7

;Creer et lier un maillon a droite du courant ( caractere d )
droite:          SUBSP       9,i ;WARNING: Number of bytes allocated (9) not equal to number of bytes listed in trace tag (0).

                 LDA         head,d
                 STA         prevD,s

                 LDA         0,i
                 LDBYTEA     head,n
                 STBYTEA     dirD,s

                 ADDX        1,i
                 STX         rangD,s
                 LDA         rangD,sf
                 STA         rangD,s

                 ADDX        2,i
                 STX         collD,s
                 LDA         collD,sf
                 STA         collD,s

                 LDBYTEA     dirD,s
                 CPA         62,i
                 BREQ        newESTD
                 CPA         118,i
                 BREQ        newSUDD
                 CPA         60,i
                 BREQ        newWestD
                 CPA         94,i
                 BREQ        newNORDD

newESTD:         LDBYTEA     sud,d
                 STBYTEA     dirD,s
                 LDA         rangD,s
                 ADDA        1,i
                 CALL        vldRang
                 STA         rangD,s
                 BR          nextMSD


newSUDD:         LDBYTEA     ouest,d
                 STBYTEA     dirD,s
                 LDA         collD,s
                 SUBA        1,i
                 CALL        vldColl
                 STA         collD,s
                 BR          nextMSD

newWestD:        LDBYTEA     nord,d
                 STBYTEA     dirD,s
                 LDA         rangD,s
                 SUBA        1,i
                 CALL        vldRang
                 STA         rangD,s
                 BR          nextMSD


newNORDD:        LDBYTEA     est,d
                 STBYTEA     dirD,s
                 LDA         collD,s
                 ADDA        1,i
                 CALL        vldColl
                 STA         collD,s
                 BR          nextMSD

nextMSD:         LDA         mLength,i
                 CALL        new
                 STX         head,d

                 LDA         0,i
                 LDBYTEA     dirD,s
                 STBYTEA     0,x

                 ADDX        1,i
                 LDA         rangD,s
                 STA         0,x

                 ADDX        2,i
                 LDA         collD,s
                 STA         0,x

                 ADDX        2,i
                 LDA         prevD,s
                 STA         0,x

                 SUBX        5,i

                 ADDSP       9,i ;WARNING: Number of bytes deallocated (9) not equal to number of bytes listed in trace tag (0).
                 RET0

dirD:           .EQUATE     0
collD:          .EQUATE     1
rangD:          .EQUATE     3
courtD:         .EQUATE     5
prevD:          .EQUATE     7

;Creer et lier un maillon a gauche de courant ( caracete g)
gauche:          SUBSP       9,i ;WARNING: Number of bytes allocated (9) not equal to number of bytes listed in trace tag (0).

                 LDA         head,d
                 STA         prevG,s

                 LDA         0,i
                 LDBYTEA     head,n
                 STBYTEA     dirG,s

                 ADDX        1,i
                 STX         rangG,s
                 LDA         rangG,sf
                 STA         rangG,s

                 ADDX        2,i
                 STX         collG,s
                 LDA         collG,sf
                 STA         collG,s

                 LDBYTEA     dirG,s
                 CPA         62,i
                 BREQ        newESTG
                 CPA         118,i
                 BREQ        newSUDG
                 CPA         60,i
                 BREQ        newWestG
                 CPA         94,i
                 BREQ        newNORDG

newESTG:         LDBYTEA     nord,d
                 STBYTEA     dirG,s
                 LDA         rangG,s
                 SUBA        1,i
                 CALL        vldRang
                 STA         rangG,s
                 BR          nextMSG


newSUDG:         LDBYTEA     est,d
                 STBYTEA     dirG,s
                 LDA         collG,s
                 ADDA        1,i
                 CALL        vldColl
                 STA         collG,s
                 BR          nextMSG

newWestG:        LDBYTEA     sud,d
                 STBYTEA     dirG,s
                 LDA         rangG,s
                 ADDA        1,i
                 CALL        vldRang
                 STA         rangG,s
                 BR          nextMSG


newNORDG:        LDBYTEA     ouest,d
                 STBYTEA     dirG,s
                 LDA         collG,s
                 SUBA        1,i
                 CALL        vldColl
                 STA         collG,s
                 BR          nextMSG

nextMSG:         LDA         mLength,i
                 CALL        new
                 STX         head,d

                 LDA         0,i
                 LDBYTEA     dirG,s
                 STBYTEA     0,x

                 ADDX        1,i
                 LDA         rangG,s
                 STA         0,x

                 ADDX        2,i
                 LDA         collG,s
                 STA         0,x

                 ADDX        2,i
                 LDA         prevG,s
                 STA         0,x

                 SUBX        5,i

                 ADDSP       9,i ;WARNING: Number of bytes deallocated (9) not equal to number of bytes listed in trace tag (0).
                 RET0

dirG:           .EQUATE     0
collG:          .EQUATE     1
rangG:          .EQUATE     3
courtG:         .EQUATE     5
prevG:          .EQUATE     7


;Placer un le serpent qui a pour tete 'head' sur le plateau de jeux
chargerS:        SUBSP       10,i ;WARNING: Number of bytes allocated (10) not equal to number of bytes listed in trace tag (0).

                 LDX         head,d
                 STX         snakHead,s

plc:             LDX         snakHead,s
                 ADDX        1,i
                 STX         setRang,s
                 LDA         setRang,sf
                 ASLA
                 STA         setRang,s

                 ADDX        2,i
                 STX         setColl,s
                 LDA         setColl,sf
                 ASLA
                 STA         setColl,s

                 ADDX        2,i
                 STX         setPrev,s

                 LDX         setRang,s
                 LDA         plateau,x
                 ADDA        setColl,s
                 STA         caseCour,s

                 LDA         caseCour,sf
                 CPA         0,i
                 BRNE        deadSnak
                 LDX         caseCour,s
                 LDA         snakHead,s
                 STA         0,x

                 LDA         setPrev,sf
                 CPA         0,i
                 BRNE        nextMall
                 BR          endPlc


nextMall:        LDA         snakHead,s
                 SUBA        7,i
                 STA         snakHead,s
                 BR          plc

deadSnak:        STRO        msgFin,d
                 STOP

endPlc:          ADDSP       10,i ;WARNING: Number of bytes deallocated (10) not equal to number of bytes listed in trace tag (0).
                 RET0

setColl:         .EQUATE     0
setRang:         .EQUATE     2
snakHead:        .EQUATE     4
caseCour:        .EQUATE     6
setPrev:         .EQUATE     8



;Verifier que le joueur n'a pas gagner la partie. A la fin de son execution, place 1 dans l'accumulateur si
;fin de la partie, sinon place 0 dans l'accumulateur et la partie continue.
verifFin:        SUBSP       10,i ;WARNING: Number of bytes allocated (10) not equal to number of bytes listed in trace tag (0).

chk:             LDX         8,i
                 LDA         plateau,x
                 ADDA        34,i
                 STA         courFin,s

                 LDA         courFin,sf

                 CPA         0,i
                 BREQ        noWin



                 CALL        queue
                 STA         queuSnak,s

                 ADDA        1,i
                 STA         rangQ,s
                 ADDA        2,i
                 STA         collQ,s

                 LDA         rangQ,sf
                 CPA         4,i
                 BRNE        else
                 LDA         collQ,sf
                 CPA         0,i
                 BRNE        else
                 BR          win



else:            LDA         queuSnak,s
                 CALL        westM
                 STA         westQ,s

                 LDA         westQ,sf
                 CPA         0,i
                 BREQ        noWin

                 LDX         queuSnak,s
                 ADDX        5,i
                 LDA         westQ,sf
                 STA         0,x

                 CALL        verifFin
                 CPA         0,i
                 BREQ        noWin
                 CPA         1,i
                 BREQ        win


noWin:           LDA         0,i
                 BR          finVerif

win:             LDA         1,i
                 BR          finVerif

finVerif:        ADDSP       10,i ;WARNING: Number of bytes deallocated (10) not equal to number of bytes listed in trace tag (0).
                 RET0

courFin:         .EQUATE     0
queuSnak:        .EQUATE     2
collQ:           .EQUATE     4
rangQ:           .EQUATE     6
westQ:           .EQUATE     8


;Recuperer le maillon Ouest ; place dans l'accumulateur l'adresse du maillon a louest de celui donnee dans l'accumulateur a lentree de la fonction
westM:           SUBSP       6,i ;WARNING: Number of bytes allocated (6) not equal to number of bytes listed in trace tag (0).

                 STA         malCourW,s

                 ADDA        1,i
                 STA         rangWest,s
                 LDA         rangWest,sf
                 STA         rangWest,s

                 LDA         malCourW,s
                 ADDA        3,i
                 STA         collWest,s
                 LDA         collWest,sf
                 STA         collWest,s

                 LDA         collWest,s
                 SUBA        1,i
                 STA         collWest,s

                 LDA         collWest,s
                 ASLA
                 STA         collWest,s

                 LDA         rangWest,s
                 ASLA
                 STA         rangWest,s

                 LDX         rangWest,s
                 LDA         plateau,x
                 ADDA        collWest,s
                 STA         malCourW,s

                 LDA         malCourW,s
                 ADDSP       6,i ;WARNING: Number of bytes deallocated (6) not equal to number of bytes listed in trace tag (0).
                 RET0

collWest:        .EQUATE     0
rangWest:        .EQUATE     2
malCourW:        .EQUATE     4

;Recuperer la queue d'un serpent : placer ladresse de la queue du serpend dans l'accumulateur A
queue:           SUBSP       6,i ;WARNING: Number of bytes allocated (6) not equal to number of bytes listed in trace tag (0).

                 STA         addrCour,s

loopQ:           LDA         addrCour,s
                 ADDA        5,i
                 STA         prevQ,s

                 LDA         prevQ,s
                 STA         prevQQ,s

                 LDX         prevQQ,sf
                 CPX         0,i
                 BREQ        endQ

                 STX         addrCour,s

                 BR          loopQ


endQ:            LDA         addrCour,s
                 ADDSP       6,i ;WARNING: Number of bytes deallocated (6) not equal to number of bytes listed in trace tag (0).
                 RET0

addrCour:        .EQUATE     0
prevQ:           .EQUATE     2
prevQQ:          .EQUATE     4

;Valider le rang
vldRang:         CPA         0,i
                 BRLT        collErr
                 CPA         8,i
                 BRGT        collErr
                 RET0

;Valider la collonne
vldColl:         CPA         0,i
                 BRLT        collErr
                 CPA         17,i
                 BRGT        collErr
                 RET0

collErr:         STRO        msgFin,d
                 STOP

;Calculer le score final de la partie (utilisable seulement apres verification de victoire)et l'afficher
score:           SUBSP       8,i ;WARNING: Number of bytes allocated (8) not equal to number of bytes listed in trace tag (0).

                 LDX         8,i
                 LDA         plateau,x
                 ADDA        34,i
                 STA         courentS,s

                 LDA         0,i
                 STA         scoreF,s

loopS:           LDA         courentS,sf
                 ADDA        5,i
                 STA         prevS,s

                 LDA         prevS,s
                 STA         prevIn,s

                 LDX         prevIn,sf
                 CPX         0,i
                 BREQ        endS

                 STA         courentS,s

                 LDA         scoreF,s
                 ADDA        1,i
                 STA         scoreF,s

                 BR          loopS

endS:            LDA         scoreF,s
                 ADDA        1,i
                 STA         scoreF,s

                 STRO        msgScore,d
                 DECO        scoreF,s

                 ADDSP       8,i ;WARNING: Number of bytes deallocated (8) not equal to number of bytes listed in trace tag (0).
                 RET0


courentS:        .EQUATE     0
prevS:           .EQUATE     2
prevIn:          .EQUATE     4
scoreF:          .EQUATE     6

;******** Object Maillon
; Chaque maillon contient :
;                            - une valeur desciptive de sa direction
;                            - une valeur pour la colonne ou il se trouve
;                            - une valeur pour la range ou il se trouve
;                            - l'adresse du maillon suivant
; fin de liste marquée arbitrairement par l'adresse 0

directn:    .EQUATE 0               ; #2d caractere de direction
coll:       .EQUATE 1               ; #2d valeur de la colonne
rang:       .EQUATE 3               ; #2d valeur de la range
mPrev:      .EQUATE 5               ; #2h maillon precedent (0:fin de liste)
mLength:    .EQUATE 7               ; taille d'un maillon en octets

;*************************** Constantes d'affichage ************************************

;Message d'introduction au programme.
intro:   .ASCII  "Bienvenue au serpentin!\n\n\x00"

;Message descriptif de l'axe des X
msgX:    .ASCII  "\n  ABCDEFGHIJKLMNOPQR\n\x00"

;Message de sollicitation
msgSoll: .ASCII  "\nEntrer un serpent qui part vers l'est:"
                .ASCII      "{position initiale et parcours}"
                .ASCII      "avec [-] (tout droit), [g] (virage à gauche),"
                .ASCII      "[d] (virage à droite)\n\x00"

;Message fin de ligne
msgLigne: .ASCII   "  ------------------  \n\x00"

;Message fin de jeu
msgFin:  .ASCII  "Le serpent est mort! Fin du jeu.\n\x00"

;Message d'erreur lors de la sollicitation
msgErr:  .ASCII     "Erreur d'entrée. Veuillez recommencer.\n\x00"

;Message pour le score
msgScore: .ASCII   "Fin! Score: \x00"

;Caractère sur une case vide
null:    .BYTE   ' '

;Caractère sur une case Est
est:     .BYTE   '>'

;Caractère sur une case Ouest
ouest:     .BYTE   '<'

;Caractère sur une case Nord
nord:     .BYTE   '^'

;Caractère sur une case Sud
sud:     .BYTE   'v'

zebi:    .ASCII  "Erreur persistente \x00"

;Le plateau de jeu (matrice 9x18)
;Chaque case du plateau contient l'adresse d'un maillon
plateau:        .ADDRSS        rang1 ; #2d
                .ADDRSS        rang2 ; #2d
                .ADDRSS        rang3 ; #2d
                .ADDRSS        rang4 ; #2d
                .ADDRSS        rang5 ; #2d
                .ADDRSS        rang6 ; #2d
                .ADDRSS        rang7 ; #2d
                .ADDRSS        rang8 ; #2d
                .ADDRSS        rang9 ; #2d

rang1:          .BLOCK      36 ;
rang2:          .BLOCK      36 ;
rang3:          .BLOCK      36 ;
rang4:          .BLOCK      36 ;
rang5:          .BLOCK      36 ;
rang6:          .BLOCK      36 ;
rang7:          .BLOCK      36 ;
rang8:          .BLOCK      36 ;
rang9:          .BLOCK      36 ;

;Variable servant a stocker la tete d'un serpent
head:            .BLOCK      2

;Variables servant a la saisie
collBuff:       .BLOCK      2
rangBuff:       .BLOCK      2
direBuff:       .BLOCK      1

;******* operator new
;        Precondition: A contains number of bytes
;        Postcondition: X contains pointer to bytes
new:     LDX     hpPtr,d     ;returned pointer
         ADDA    hpPtr,d     ;allocate from heap
         STA     hpPtr,d     ;update hpPtr
         RET0
hpPtr:   .ADDRSS heap        ;address of next free byte
heap:    .BLOCK  1           ;first byte in the heap
.END



