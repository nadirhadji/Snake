public class Maillon {

    public Direction direction;
    public int colonne;
    public int range;
    public Maillon precedent = null;

    public Maillon() {
        direction = Direction.NULL;
        colonne = -1;
        range = -1;
    }

    public Maillon(int colonne, int range) {
        this.direction = Direction.EST;
        validerColonne(colonne);
        validerRange(range);
    }

    public Maillon(Direction direction, int colonne, int range) {
        this.direction = direction;
        validerColonne(colonne);
        validerRange(range);
    }

    public void validerColonne(int colonne) {
        if( colonne >= 0 && colonne <= 17)
            this.colonne = colonne;
        else {
            Pep8.stro(Texte.MSG_DEAD_SNAKE);
            Pep8.stop();
        }
    }

    public void validerRange(int range) {
        if(range >= 0 && range <= 8)
            this.range = range;
        else {
            Pep8.stro(Texte.MSG_DEAD_SNAKE);
            Pep8.stop();
        }
    }

    public void setDirection(Direction direction) {
        this.direction = direction;
    }

    public void setPrecedent(Maillon precedent) {
        this.precedent = precedent;
    }
}
