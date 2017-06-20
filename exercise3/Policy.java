package exercise3;

import exercise3.GridWorld.Move;
/**
 * The policy class containing movement probability
 * @author Ming
 *
 */
public class Policy {
    double[][][] moveProbabilities;

    public Policy() {
        moveProbabilities = new double[9][9][4];

    }

    public Policy(double leftProbability, double upProbability,
            double rightProbability, double downProbability) {
        moveProbabilities = new double[9][9][4];
        for (int i = 0; i < 9; i++)
            for (int j = 0; j < 9; j++) {
                moveProbabilities[i][j][0] = leftProbability;
                moveProbabilities[i][j][1] = upProbability;
                moveProbabilities[i][j][2] = rightProbability;
                moveProbabilities[i][j][3] = downProbability;
            }
    }

    //draw the graph
    public void output() {
        Move currentMove;
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++) {
                if (i == 4 && j == 8) {
                    System.out.print(" * ");
                    continue;
                }
                currentMove = detectMove(i, j);
                if (currentMove == null)
                    System.out.print(" - ");
                else
                    switch (currentMove) {
                    case LEFT: {
                        System.out.print(" < ");
                        break;
                    }
                    case UP: {
                        System.out.print(" ^ ");
                        break;
                    }
                    case RIGHT: {
                        System.out.print(" > ");
                        break;
                    }
                    case DOWN: {
                        System.out.print(" v ");
                        break;
                    }
                    }
            }
            System.out.println();
        }
        System.out.println();
    }

    public Move detectMove(int i, int j) {
        if (moveProbabilities[i][j][Move.LEFT.ordinal()] == 1)
            return Move.LEFT;
        if (moveProbabilities[i][j][Move.UP.ordinal()] == 1)
            return Move.UP;
        if (moveProbabilities[i][j][Move.RIGHT.ordinal()] == 1)
            return Move.RIGHT;
        if (moveProbabilities[i][j][Move.DOWN.ordinal()] == 1)
            return Move.DOWN;
        return null;
    }

}