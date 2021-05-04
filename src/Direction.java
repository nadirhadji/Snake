public enum Direction {
    NULL(' '),
    EST('>'),
    OUEST('<'),
    NORD('^'),
    SUD('v');

    char direction;

    Direction(char direction) {
        this.direction = direction;
    }

    public char toChar() {
        return direction;
    }
}
