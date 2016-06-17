class RotatingCubes
{
	float[] angle = new float[6];
	float[] increase = new float[6];
	
	RotatingCubes()
	{
		for(int i = 0; i < angle.length; i++) 
		{
			angle[i]=random(PI);
			increase[i]=random(-.02, .02);
		}
	}
	
	void draw()
	{
		pushMatrix();
		translate(width/2, height/2);
		rotateX(angle[0]);
		rotateY(angle[1]);
		rotateZ(angle[2]);
		noFill();
		strokeWeight(2);
		stroke(255);
		box(300);
		popMatrix();
		
		pushMatrix();
		translate(width/2, height/2);
		rotateX(angle[3]);
		rotateY(angle[4]);
		rotateZ(angle[5]);
		fill(200, 100);
		strokeWeight(2);
		box(150);
		popMatrix();
		
		for(int i = 0; i < angle.length; i++) 
		{
			angle[i]+=increase[i];
		}
	}
}