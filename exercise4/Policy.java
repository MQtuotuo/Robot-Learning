package exercise4;

import java.util.Random;

import exercise4.GridWorld.Move;

public class Policy{
    double moveProbability[][][];
   

    public Policy(double[] prob){
        moveProbability = new double [GridWorld.HEIGHT][GridWorld.WIDTH][8];
        for (int i = 0; i<GridWorld.HEIGHT; i++)
            for (int j = 0; j<GridWorld.WIDTH; j++)
                for(int k = 0; k<8; k++)
                 moveProbability[i][j][k] = prob[k];
         GridWorld.rand = new Random();
     }

     public Move nextAction(int i, int j){
         double moveProb = GridWorld.rand.nextDouble();
         int moveIndex = -1;
         double prevProbs = 0.0;
         for(int k = 0; k<8; k++){
             if(prevProbs <= moveProb && moveProb < prevProbs + moveProbability[i][j][k]) {
                 moveIndex = k;
                 break;
             }
             prevProbs += moveProbability[i][j][k];
         }

         return Move.values()[moveIndex];
     }

 }