package exercise3;
/**
 * The grid architecture 
 * @author Ming
 *
 */
public class Grid {
    int[][] rewardGrid;
    double[][] valueGrid;

    public Grid(double initVal) {
        rewardGrid = new int[9][9];
        valueGrid = new double[9][9];
        for (int i = 0; i < 9; i++)
            for (int j = 0; j < 9; j++)
                rewardGrid[i][j] = -1;
        rewardGrid[4][8] = 100;
        rewardGrid[1][5] = -20;
        rewardGrid[2][1] = -20;
        rewardGrid[2][2] = -20;
        rewardGrid[2][3] = -20;
        rewardGrid[2][5] = -20;
        rewardGrid[2][6] = -20;
        rewardGrid[3][7] = -20;
        rewardGrid[4][2] = -20;
        rewardGrid[4][3] = -20;
        rewardGrid[4][4] = -20;
        rewardGrid[4][5] = -20;
        rewardGrid[4][7] = -20;
        rewardGrid[5][7] = -20;
        rewardGrid[6][1] = -20;
        rewardGrid[6][2] = -20;
        rewardGrid[6][3] = -20;
        rewardGrid[6][5] = -20;
        rewardGrid[6][6] = -20;           
        rewardGrid[7][8] = -20;
        rewardGrid[8][8] = -20;
        
        for (int i = 7; i < 9; i++)
            for (int j = 1; j <= 6; j++)
                rewardGrid[i][j] = 5;
        for (int i = 0; i < 9; i++)
            for (int j = 0; j < 9; j++) {
                valueGrid[i][j] = initVal;
            }
        
        rewardGrid[8][4] = -20;
        
    }
}
