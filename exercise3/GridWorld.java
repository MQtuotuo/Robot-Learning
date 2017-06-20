package exercise3;

import java.util.Arrays;
/**
 * The main function containing movement, policy computation and state-action evaluation and iterative algorithm
 * @author Ming
 *
 */
public class GridWorld {
    public static enum Move {
        LEFT, UP, RIGHT, DOWN
    };

    public static enum DiagMove {
        DIAG_LEFT_UP, DIAG_LEFT_DOWN, DIAG_RIGHT_UP, DIAG_RIGHT_DOWN
    };

    private Grid grid;
    private Policy policy;

    //constructer 1
    public GridWorld(double initVal) {
        grid = new Grid(initVal);
        policy = new Policy();
    }

    //constructer 2
    public GridWorld(double initVal, double leftProbability,
            double upProbability, double rightProbability,
            double downProbability) {
        grid = new Grid(initVal);
        policy = new Policy(leftProbability, upProbability, rightProbability,
                downProbability);
    }

    //constructer 3
    public GridWorld(double initVal, Policy policy) {
        grid = new Grid(initVal);
        this.policy = policy;
    }

    //get the reward of the grid
    private int reward(int i, int j) {
        return grid.rewardGrid[i][j];
    }

    //get the value grid
    public double value(int i, int j) {
        return grid.valueGrid[i][j];
    }

    private double policyMove(int i, int j, Move a) {
        return policy.moveProbabilities[i][j][a.ordinal()];
    }

    //return the move address [i, j]
    private int[] move(int i, int j, Move a) {
        int[] result = { i, j };

        switch (a) {
        case LEFT: {
            if (j != 0)
                result[1] = j - 1;
            return result;
        }
        case UP: {
            if (i != 0)
                result[0] = i - 1;
            return result;
        }
        case RIGHT: {
            if (j != 8)
                result[1] = j + 1;
            return result;
        }
        case DOWN: {
            if (i != 8)
                result[0] = i + 1;
            return result;
        }
        }
        return result;
    }

    
    //return the dialogonal move address [i, j]
    private int[] diagMove(int i, int j, DiagMove a) {
        int[] result = { i, j };
        switch (a) {
        
        case DIAG_LEFT_DOWN: {
            if (j == 0)
                result[1] = 0;
            else {
                result[1] = j - 1;
                if (i == 8)
                    result[0] = 8;
                else
                    result[0] = i + 1;
            }

            return result;
        }
        case DIAG_LEFT_UP: {
            if (j == 0)
                result[1] = 0;
            else {
                result[1] = j - 1;
                if (i == 0)
                    result[0] = 0;
                else
                    result[0] = i - 1;
            }
            return result;
        }
        case DIAG_RIGHT_DOWN: {
            if (j == 8)
                result[1] = 8;
            else {
                result[1] = j + 1;
                if (i == 8)
                    result[0] = 8;
                else
                    result[0] = i + 1;
            }

            return result;
        }
        case DIAG_RIGHT_UP: {
            if (j == 8)
                result[1] = 8;
            else {
                result[1] = j + 1;
                if (i == 0)
                    result[0] = 0;
                else
                    result[0] = i - 1;
            }
            return result;
        }
        }
        return result;
    }

    
    
    public double getStateExpectedValue(int i, int j) {
    	
        if (i == 4 && j == 8)
            return 100;
        if (reward(i, j) == -20)
            return -20;
        
        double stateValue = 0.0;
        int[] nextState;
        int reward;
        for (Move a : Move.values()) {
            nextState = move(i, j, a);
            if (nextState[0] == i && nextState[1] == j)
                reward = -10;
            else {
                reward = reward(nextState[0], nextState[1]);
                if (reward == -20) {
                    nextState[0] = i;
                    nextState[1] = j;
                }
            }
            //Bellmann equation/policy iteration
            stateValue += policyMove(i, j, a) * (reward + 0.9 * value(nextState[0], nextState[1]));
        }
        return stateValue;
    }
    
    
    
    public double getStateMaximumValue(int i, int j) {  	
        if (i == 4 && j == 8)
            return 100;
        if (reward(i, j) == -20)
            return -20;
        
        double stateActionValue;
        int[] nextState;
        int reward;
        double maximumValue = -Double.MAX_VALUE;
        for (Move a : Move.values()) {
            nextState = move(i, j, a);
            if (nextState[0] == i && nextState[1] == j)
                reward = -10;
            else {
                reward = reward(nextState[0], nextState[1]);
                if (reward == -20) {
                    nextState[0] = i;
                    nextState[1] = j;
                }
            }
            //value iteration
            stateActionValue = reward + 0.9 * value(nextState[0], nextState[1]);
            
            if (stateActionValue > maximumValue)
                maximumValue = stateActionValue;
        }
        return maximumValue;
    }

   
    
   //define the new optimal policy 
    public Policy computePolicy() {
        grid.valueGrid[4][8] = Double.MAX_VALUE;
        Policy result = new Policy();
        double maximum;
        double value;
        for (int i = 0; i < 9; i++)
            for (int j = 0; j < 9; j++) {
                maximum = Double.MIN_VALUE;
                if (i == 4 && j == 8)
                    continue;
                if (reward(i, j) == -20)
                    continue;

                // check neighbors
                if (j > 0) {
                    value = value(i, j - 1);
                    if (value > maximum) {
                        Arrays.fill(result.moveProbabilities[i][j], 0);
                        result.moveProbabilities[i][j][Move.LEFT.ordinal()] = 1;
                        maximum = value;
                    }
                }
                if (i > 0) {
                    value = value(i - 1, j);
                    if (value > maximum) {
                        Arrays.fill(result.moveProbabilities[i][j], 0);
                        result.moveProbabilities[i][j][Move.UP.ordinal()] = 1;
                        maximum = value;
                    }
                }

                if (j < 8) {
                    value = value(i, j + 1);
                    if (value > maximum) {
                        Arrays.fill(result.moveProbabilities[i][j], 0);
                        result.moveProbabilities[i][j][Move.RIGHT.ordinal()] = 1;
                        maximum = value;
                    }
                }
                if (i < 8) {
                    value = value(i + 1, j);
                    if (value > maximum) {
                        Arrays.fill(result.moveProbabilities[i][j], 0);
                        result.moveProbabilities[i][j][Move.DOWN.ordinal()] = 1;
                        maximum = value;
                    }
                }
            }
        return result;
    }

    public void setValues(double[][] temp) {
        for (int i = 0; i < 9; i++)
            for (int j = 0; j < 9; j++)
                grid.valueGrid[i][j] = temp[i][j];
    }

    public void printValues() {
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++)
                System.out.printf("%.2f ", grid.valueGrid[i][j]);
            System.out.println();
        }
        System.out.println();
    }

    //with prob
    public double getStateMaximumValueNonDeterm(int i, int j) {
        if (i == 4 && j == 8)
            return 100;
        if (reward(i, j) == -20)
            return -20;

        double stateActionValue;
        int[] nextState;
        int[] nextStateD1;
        int[] nextStateD2;
        
        int reward;
        int rewardD1;
        int rewardD2;
        double maximumValue = -Double.MAX_VALUE;
        DiagMove diagAct1, diagAct2;    

        for (Move a : Move.values()) {

            switch (a) {
            case LEFT: {
                diagAct1 = DiagMove.DIAG_LEFT_DOWN;
                diagAct2 = DiagMove.DIAG_LEFT_UP;
                break;
            }
            case RIGHT: {
                diagAct1 = DiagMove.DIAG_RIGHT_DOWN;
                diagAct2 = DiagMove.DIAG_RIGHT_UP;
                break;
            }
            case DOWN: {
                diagAct1 = DiagMove.DIAG_LEFT_DOWN;
                diagAct2 = DiagMove.DIAG_RIGHT_DOWN;
                break;
            }
            case UP: {
                diagAct1 = DiagMove.DIAG_RIGHT_UP;
                diagAct2 = DiagMove.DIAG_LEFT_UP;
                break;
            }
            default: {
                diagAct1 = null;
                diagAct2 = null;
            }
            }
                      
            nextState = move(i, j, a);
            nextStateD1 = diagMove(i, j, diagAct1);
            nextStateD2 = diagMove(i, j, diagAct2);
            
            if (nextState[0] == i && nextState[1] == j)
                reward = -10;
            else {
                reward = reward(nextState[0], nextState[1]);
                if (reward == -20) {
                    nextState[0] = i;
                    nextState[1] = j;
                }
            }
           
            if (nextStateD1[0] == i && nextStateD1[1] == j)
                rewardD1 = -10;
            else {
                rewardD1 = reward(nextStateD1[0], nextStateD1[1]);
                if (rewardD1 == -20) {
                    nextStateD1[0] = i;
                    nextStateD1[1] = j;
                }
            }
            
            if (nextStateD2[0] == i && nextStateD2[1] == j)
                rewardD2 = -10;
            else {
                rewardD2 = reward(nextStateD2[0], nextStateD2[1]);
                if (rewardD2 == -20) {
                    nextStateD2[0] = i;
                    nextStateD2[1] = j;
                }
            }
            
          
            stateActionValue = 0.7 * (reward + 0.9 * value( nextState[0], nextState[1]))
                    + 0.15 * (rewardD1 + 0.9 * value( nextStateD1[0], nextStateD1[1]))
                    + 0.15 * (rewardD2 + 0.9 * value( nextStateD2[0], nextStateD2[1]));

            if (stateActionValue > maximumValue)
                maximumValue = stateActionValue;
        }
        return maximumValue;
    }

   
    public static void main(String[] Args) {
        double initValue = 0.0;
        double leftProbability = 0.125;
        double upProbability = 0.125;
        double rightProbability = 0.625;
        double downProbability = 0.125;
        GridWorld gw = new GridWorld(initValue, leftProbability, upProbability, rightProbability, downProbability);
        double epsilon = 0.01;
        double[][] tempGrid = new double[9][9];
        double maximum = 0.0;
        double delta;
        //gw.printValues();
        
        //task1
        //iterative policy evaluation
        do {
            maximum = 0;
            for (int i = 0; i < 9; i++)
                for (int j = 0; j < 9; j++) {
                    tempGrid[i][j] = gw.getStateExpectedValue(i, j);
                    delta = Math.abs(tempGrid[i][j] - gw.value(i, j));
                    if (delta > maximum)
                        maximum = delta;
                       
                }
            gw.setValues(tempGrid);
        } while (maximum > epsilon);
        gw.printValues();

      
        //task2 
        //value iteration algorithm
        GridWorld gw1 = new GridWorld(initValue, leftProbability, upProbability, rightProbability, downProbability);
        do {
            maximum = 0;
            for (int i = 0; i < 9; i++)
                for (int j = 0; j < 9; j++) {
                    tempGrid[i][j] = gw1.getStateMaximumValue(i, j);
                    delta = Math.abs(tempGrid[i][j] - gw1.value(i, j));
                   // System.out.println(delta); 
                    if (delta > maximum)
                        maximum = delta;                 
                }
            gw1.setValues(tempGrid);              
           // System.out.println("--------------"+maximum);   
        } while (maximum > epsilon);
        gw1.printValues();
        Policy optimal = gw1.computePolicy();
        optimal.output();

        //task3
        //value iteration algorithm
        
        GridWorld gw3 = new GridWorld(initValue, leftProbability, upProbability, rightProbability, downProbability);
        do {
            maximum = 0;
            for (int i = 0; i < 9; i++)
                for (int j = 0; j < 9; j++) {
                    tempGrid[i][j] = gw3.getStateMaximumValueNonDeterm(i, j);
                    delta = Math.abs(tempGrid[i][j] - gw3.value(i, j));
                   // System.out.println(delta); 
                    if (delta > maximum)
                        maximum = delta;                 
                }
            gw3.setValues(tempGrid);              
           // System.out.println("--------------"+maximum);   
        } while (maximum > epsilon);
        gw3.printValues();
        Policy optimalNonDetermenistic = gw3.computePolicy();
        optimalNonDetermenistic.output();

        
    }
}
