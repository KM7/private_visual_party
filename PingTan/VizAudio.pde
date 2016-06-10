/**
  * An FFT object is used to convert an audio signal into its frequency domain representation. This representation
  * lets you see how much of each frequency is contained in an audio signal. Sometimes you might not want to 
  * work with the entire spectrum, so it's possible to have the FFT object calculate average frequency bands by 
  * simply averaging the values of adjacent frequency bands in the full spectrum. There are two different ways 
  * these can be calculated: <b>Linearly</b>, by grouping equal numbers of adjacent frequency bands, or 
  * <b>Logarithmically</b>, by grouping frequency bands by <i>octave</i>, which is more akin to how humans hear sound.
  * <br/>
  * This sketch illustrates the difference between viewing the full spectrum, 
  * linearly spaced averaged bands, and logarithmically spaced averaged bands.
  * <p>
  * From top to bottom:
  * <ul>
  *  <li>The full spectrum.</li>
  *  <li>The spectrum grouped into 30 linearly spaced averages.</li>
  *  <li>The spectrum grouped logarithmically into 10 octaves, each split into 3 bands.</li>
  * </ul>
  *
  * Moving the mouse across the sketch will highlight a band in each spectrum and display what the center 
  * frequency of that band is. The averaged bands are drawn so that they line up with full spectrum bands they 
  * are averages of. In this way, you can clearly see how logarithmic averages differ from linear averages.
  * <p>
  * For more information about Minim and additional features, visit http://code.compartmental.net/minim/
  */

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
    
  AudioInput in;
  FFT fftLin;
  FFT fftLog;
  
  VizAudio(Minim minim) {
    in = minim.getLineIn();
    fftLin = new FFT(in.bufferSize(), in.sampleRate());
    fftLin.linAverages(30);
    fftLog = new FFT(in.bufferSize(), in.sampleRate());
    fftLog.logAverages(22, 3);
  }
  
  void draw(boolean flag) {
    int  i;
    fftLin.forward(in.mix);
    fftLog.forward(in.mix);

    fill(0);
    stroke(0);
    strokeWeight(1);
    rectMode(CORNERS);
    if(flag) {    
      for(i=0; i<in.bufferSize()-1; i++) 
        line(startX+i, leftY+in.left.get(i)*scaleY, startX+i+1, leftY+in.left.get(i+1)*scaleY);
  
      for(i=0; i<fftLin.specSize(); i++) 
        rect(i*sw, specY, i*sw+sw, specY-fftLin.getBand(i)*spectrumScale);
  
      for(i=0; i<fftLog.avgSize(); i++) {
        float centerFrequency = fftLog.getAverageCenterFrequency(i);
        float averageWidth = fftLog.getAverageBandWidth(i);   
        float lowFreq  = centerFrequency - averageWidth/2;
        float highFreq = centerFrequency + averageWidth/2;
        int xl = (int)fftLog.freqToIndex(lowFreq);
        int xr = (int)fftLog.freqToIndex(highFreq);
        rect(xl, logY, xr, logY-fftLog.getAvg(i)*spectrumScale);
      }
      text("faudioX "+(int)(m_faudioX*100.), 15, height-330);
      text("faudioY "+(int)(m_faudioY*100.), 15, height-360);
    }
    
    for(i=0; i<fftLin.avgSize(); i++) {
      faudio[i]=fftLin.getAvg(i);
      if(flag) rect(i*aw, avgY, i*aw+aw, avgY-faudio[i]*spectrumScale);
    }
    m_faudioY=(faudio[0]+faudio[1])/2.;
    m_faudioX=(faudio[3]+faudio[4])/2.;    
  }

  float getValue() {
    return in.left.get(0);
  }  
}

/*
  ArrayList<MovingMark> movingMarks;
  int      i, markType=0, handType=0, lineType=0, currentIndex;
  int      maxMarkType=7, maxLineType=3;
 
  movingMarks = new ArrayList<MovingMark>();
  
  for(i=0; i<markNumber; i++) {
    x = random(margin, width-margin);
    y = random(margin, height-margin);
    theta = random(0, 2*PI);
    radius = random(12, 24);
    hue = random(0, 360);
    movingMarks.add(new MovingMark(x, y, theta, radius, hue));
  }  
  
  void add() {
    theta = random(0, 2*PI);
    radius = random(12, 32);
    hue = random(0, 360);
    movingMarks.add(new MovingMark(mouseX, mouseY, theta, radius, hue));
    markNumber++;
  }

  void draw() {
    for(i=0; i<markNumber; i++) { 
      movingMarks.get(i).draw(markType);
    }  
  }  
*/

