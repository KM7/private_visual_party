class Wind
{
  float noiseX = random(123456);
  float noiseY = random(123456);
  float NOISE_SPEED = .12;
  float SPEED_MAX = 2;
  float COEFF = 700;

  PVector speed = new PVector(0, 0);

  void update()
  {
    noiseX += NOISE_SPEED;
    noiseY += NOISE_SPEED;
  }
  
  float speed(float p_x, float p_y)
  {
    return (.45 - noise(noiseX + p_x/50, noiseY + p_y/50)) / COEFF;
  }
}

