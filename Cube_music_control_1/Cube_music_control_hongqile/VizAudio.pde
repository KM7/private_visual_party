class VizAudio {

  int startX = 10;
  int leftY = height-20;
  int rightY = height-200;
  int specY = height-100;
  int avgY = height-180;
  int logY = height-260;
  int scaleY = 200;
  int spectrumScale = 4;
  int avgSize=30;
  int aw = 512/avgSize;
  int sw = 2;
  float[] faudio = new float[avgSize];
  AudioPlayer song;
  AudioInput in;
  FFT fftLin;
  FFT fftLog;

  VizAudio(Minim minim) {
    song = minim.loadFile("Pixel³ - 4.mp3");
    song.play();
    in = minim.getLineIn();
    fftLin = new FFT(song.bufferSize(), song.sampleRate());
    fftLin.linAverages(30);
    fftLog = new FFT(song.bufferSize(), song.sampleRate());
    fftLog.logAverages(22, 3);
  }

  void draw() {
    int  i;
    fftLin.forward(song.mix);
    fftLog.forward(song.mix);
    text("faudioX "+(int)(m_faudioX*100.), 15, height-330);
    text("faudioY "+(int)(m_faudioY*100.), 15, height-360);
    for (i=0; i<fftLin.avgSize(); i++) {
      faudio[i]=fftLin.getAvg(i);
    }
    m_faudioY=(faudio[0]+faudio[1])/2.;
    m_faudioX=(faudio[3]+faudio[4])/2.;
  }

float getLevel(float level){
  return in.left.level()*level;
}

  float[] getValue(int size) {
    //println(in.bufferSize());
    int temp_value=in.bufferSize()/size;
    float[] temp_float=new float[size];
    
      for(int i = 0; i <temp_float.length; i++)
  {
    temp_float[i] =in.left.get(temp_value*i);
  }
  println(temp_float[size-10]);
    return temp_float;
  }
}