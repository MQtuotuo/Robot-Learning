package exercise1;

import java.lang.Math;

public class Random4{
	public static void main(String args[]){
		double i = 0.0;
		//input
		double k1 = 7.0;
		double k2 = 7.0;
		double k3 = 7.0;
		double k4 = 7.0;
		double k5 = 7.0;
		//average of output
		double e = 0.0;
		//greed stratege

		double a1 = 0.0;
		double a2 = 0.0;
		double a3 = 0.0;
		double a4 = 0.0;
		double a5 = 0.0;

		for (int j = 0; j<1000; j++){
			e = Math.random();
			if(e<0.1){
				i = Math.random();
				if(i<0.2){
					k1=k1+(Math.random()*3+1-k1)*0.02;
					a1++;
				}else if(i<0.4){
					k2=k2+(Math.random()*5-2-k2)*0.02;
					a2++;				
				}else if(i<0.6){
					k3=k3+(Math.random()*6-k3)*0.02;
					a3++;				
				}else if(i<0.8){
					k4=k4+(Math.random()+2-k4)*0.02;
					a4++;				
				}else{
					k5=k5+(Math.random()*3-1-k4)*0.02;
					a5++;
				}
			}else{
				if(k1==k2&&k1==k3&&k1==k4&&k1==k5){
					i = Math.random();
					if(i<0.2){
						k1=k1+(Math.random()*3+1-k1)*0.02;
						a1++;
					}else if(i<0.4){
						k2=k2+(Math.random()*5-2-k2)*0.02;
						a2++;				
					}else if(i<0.6){
						k3=k3+(Math.random()*6-k3)*0.02;
						a3++;				
					}else if(i<0.8){
						k4=k4+(Math.random()+2-k4)*0.02;
						a4++;				
					}else{
						k5=k5+(Math.random()*3-1-k4)*0.02;
						a5++;
					}
				}else if(k1>=k2&&k1>=k3&&k1>=k4&&k1>=k5){

					k1=k1+(Math.random()*3+1-k1)*0.02;
					a1++;

				}else if(k2>=k1&&k2>=k3&&k2>=k4&&k2>=k5){

					k2=k2+(Math.random()*5-2-k2)*0.02;
					a2++;				

				}else if(k3>=k1&&k3>=k2&&k3>=k4&&k3>=k5){

					k3=k3+(Math.random()*6-k3)*0.02;
					a3++;				
	
				}else if(k4>=k1&&k4>=k2&&k4>=k3&&k4>=k5){

					k4=k4+(Math.random()+2-k4)*0.02;
					a4++;	
			
				}else{
					k5=k5+(Math.random()*3-1-k4)*0.02;
					a5++;
				}
			}
			if((j+1)%100==0){

				System.out.println(k1);
				System.out.println(k2);
				System.out.println(k3);
				System.out.println(k4);
				System.out.println(k5);
				System.out.println("\n");
				System.out.println(a1/(j+1));
				System.out.println(a2/(j+1));
				System.out.println(a3/(j+1));
				System.out.println(a4/(j+1));
				System.out.println(a5/(j+1));
				System.out.println("\n");												
			}
		}

	}
}