public class Snake {

    public static Maillon[][] plateau = new Maillon[9][18];

    public static Maillon departSnake() {

        int colonne = Pep8.chari() - 65;
        System.out.println(colonne);
        Pep8.chari();
        int range = Pep8.deci() - 1;
        System.out.println(range);
        Pep8.chari();

        Maillon premierMaillon = new Maillon(Direction.EST,colonne,range);
        premierMaillon.setPrecedent(null);

        return premierMaillon;
    }

    public static Maillon creerSnake() {

        Maillon ombre = departSnake();
        Maillon courant = null;
        char direction = Pep8.chari();

        while ( direction != '\n' ) {

            switch (direction) {
                case '-' -> courant = devant(ombre);
                case 'd' -> courant = droite(ombre);
                case 'g' -> courant = gauche(ombre);
                default -> {
                    Pep8.stro(Texte.MSG_ERR);
                    Pep8.stro(Texte.MSG_SOLL);
                    return null;
                }
            }
            ombre = courant;
            Pep8.chari();
            direction = Pep8.chari();
        }

        return courant;
    }

    public static Maillon devant(Maillon ombre) {

        Maillon resultat;

        int colonne = ombre.colonne;
        int range = ombre.range;
        Direction direction = ombre.direction;

        switch (direction) {
            case EST -> resultat = new Maillon(Direction.EST, colonne + 1, range);
            case SUD -> resultat = new Maillon(Direction.SUD, colonne, range + 1);
            case OUEST -> resultat = new Maillon(Direction.OUEST, colonne - 1, range);
            case NORD -> resultat = new Maillon(Direction.NORD, colonne, range - 1);
            default -> resultat = new Maillon();
        }

        resultat.setPrecedent(ombre);
        return resultat;
    }

    public static Maillon droite(Maillon ombre) {

        Maillon resultat;

        int colonne = ombre.colonne;
        int range = ombre.range;
        Direction direction = ombre.direction;

        switch (direction) {
            case EST -> resultat = new Maillon(Direction.SUD, colonne, range+1);
            case SUD -> resultat = new Maillon(Direction.OUEST, colonne-1, range);
            case NORD -> resultat = new Maillon(Direction.EST, colonne +1, range);
            case OUEST -> resultat = new Maillon(Direction.NORD, colonne, range-1);
            default -> resultat = new Maillon();
        }

        resultat.setPrecedent(ombre);
        return resultat;
    }

    public static Maillon gauche(Maillon ombre) {

        Maillon resultat;

        int colonne = ombre.colonne;
        int range = ombre.range;
        Direction direction = ombre.direction;

        switch (direction) {
            case EST -> resultat = new Maillon(Direction.NORD, colonne, range-1);
            case SUD -> resultat = new Maillon(Direction.EST, colonne + 1, range);
            case NORD -> resultat = new Maillon(Direction.OUEST, colonne - 1, range);
            case OUEST -> resultat = new Maillon(Direction.SUD, colonne, range+1);
            default -> resultat = new Maillon();
        }

        resultat.setPrecedent(ombre);
        return resultat;
    }

    public static void placerMaillon(Maillon maillon) {

        int colonne = maillon.colonne;
        int range = maillon.range;

        if (plateau[range][colonne].direction != Direction.NULL){
            Pep8.stro(Texte.MSG_DEAD_SNAKE);
            Pep8.stop();
        }
        else {
            plateau[range][colonne] = maillon;
        }
    }

    public static void chargerPlateau(Maillon snakeHead) {

        Maillon courant = snakeHead;

        while (courant.precedent != null) {

            placerMaillon(courant);
            afficherTableau(plateau);
            courant = courant.precedent;
        }

        placerMaillon(courant);
        afficherTableau(plateau);
    }

    public static boolean verifierVictoire() {

        boolean resultat = false;

        //Maillon a la position R5
        Maillon courant = plateau[4][17];

        if( courant.direction == Direction.EST) {

            courant = teteDeSnake(courant);

            if(courant.colonne == 0 && courant.range == 4)
                resultat = true;
            else{
                Maillon west = getMallionWest(courant);

                if(west.direction != Direction.NULL) {
                    courant.setPrecedent(west);
                    resultat = verifierVictoire();
                }
            }
        }

        return resultat;
    }

    public static Maillon getMallionWest(Maillon courant) {

        int colonneWest = (courant.colonne - 1);
        int rangeWest = courant.range;
        return plateau[rangeWest][colonneWest];
    }

    public static Maillon teteDeSnake(Maillon snake) {
        Maillon tete = snake;

        while (tete.precedent != null)
            tete = tete.precedent;

        return tete;
    }

    /**
     * Methode utilisable uniquement lorsque la victoire est assuée.
     *
     * @return le nombre de maillon chainée entre A5 et R5
     */
    public static int calculerScore() {

        int score = 0;
        Maillon courant = plateau[4][17];

        while(courant.precedent != null){
            score++;
            courant = courant.precedent;
        }

        score++;

        return score;
    }
    /**
     * méthode qui initialiser un tableau vide avec la constante 'ocean'
     * dans toute les cases
     *
     * @param plateau un tableau de jeu de type {@code char[][]}
     */
    private static void initPlateau(Maillon[][] plateau) {

        Pep8.stro(Texte.MSG_X);

        for (int i = 0 ; i < plateau.length ; i++)
        {
            Pep8.stro(i+1+"|");
            for (char j = 0 ; j < plateau[i].length ; j++)
            {
                plateau[i][j] = new Maillon();
                Pep8.charo(plateau[i][j].direction.toChar());
            }
            Pep8.stro("|\n");
        }

        Pep8.stro(Texte.LIGNE_FIN);
    }

    private static void afficherTableau(Maillon[][] plateau) {
        Pep8.stro(Texte.MSG_X);

        for (int i = 0 ; i < plateau.length ; i++)
        {
            Pep8.stro(i+1+"|");
            for (char j = 0 ; j < plateau[i].length ; j++)
            {
                Pep8.charo(plateau[i][j].direction.toChar());
            }
            Pep8.stro("|\n");
        }

        Pep8.stro(Texte.LIGNE_FIN);

    }

    public static void main(String[] args) {

        int score = 0;
        boolean finDejeu = false;

        Pep8.stro(Texte.INTRO);

        initPlateau(plateau);

        while(!finDejeu) {
            Pep8.stro(Texte.MSG_SOLL);

            Maillon snakeHead = creerSnake();

            chargerPlateau(snakeHead);

            finDejeu = verifierVictoire();

            if(finDejeu) {
                Pep8.stro(Texte.MSG_SCORE);
                score = calculerScore();
                Pep8.deco(score);
            }
        }
        Pep8.stop();
    }
}
