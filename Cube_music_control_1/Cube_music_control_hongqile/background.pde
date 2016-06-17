//class BackGround {
//  int Y_AXIS = 1;
//  int X_AXIS = 2;
//  color[] ctable = {
//    color(#FFFFFF),
//    color(#C0C0C0),
//    color(#808080),
//    color(#000000),
//    color(#800000),
//    color(#FFFF00),
//    color(#808000),
//    color(#00FF00),
//    color(#008000),
//    color(#00FFFF),
//    color(#008080),
//    color(#0000FF),
//    color(#000080),
//    color(#FF00FF),
//    color(#800080)};  
//  color c1 = color(#555555);
//  color c2 = color(#FFFFFF);

//  PImage img, bimg;  // Declare variable "a" of type PImage
//  float v = 1.0 / 9.0;
//  float[][] kernel = {{ v, v, v }, 
//                      { v, v, v }, 
//                      { v, v, v }};

//  BackGround() {
//    img = loadImage("mountain.jpg");  // Load the image into the program  
//    smootingImage();
//  }

    
//  void draw(int type)  {
//    if(type<colorCount)
//      background(ctable[type]);
//    else if(type==colorCount)    
//      gradientBackground(c1, c2);
//    else if(type==colorCount+1)    
//      setGradient(0, 0, width, height, c1, c2, Y_AXIS);
//    else if(type==colorCount+2) {
//      if(drawSlidingFlag) {
//        int count=frameCount-startFrame;
//        if(count%slidingStep==0) slidingImage();
//        if(count>256*slidingStep) {
//          drawSlidingFlag=false;
//          drawFluidFlag=true;
//          smootingImage();
//        }  
//        println(count);  
//      }  
////      tint(255, 127);  // Display at half opacity
//      image(bimg, 0, 0, width, height);
//    }
//    else if(type<256)
//      background(type);
//  }

//  void slidingImage() {
//    int  i, c, size;    
//    bimg.loadPixels();

//    size=bimg.width*bimg.height;
//    for(i=0; i<size; i++) {
//      c=(int)red(bimg.pixels[i])-1;
//      c=constrain(c, 0, 255);
//      bimg.pixels[i]=color(c);
//    }
//    bimg.updatePixels();
//  }

//  void smootingImage() {                    
//    img.loadPixels();
//    bimg = createImage(img.width, img.height, RGB);
  
//    // Loop through every pixel in the image
//    for (int y = 1; y < img.height-1; y++) {   // Skip top and bottom edges
//      for (int x = 1; x < img.width-1; x++) {  // Skip left and right edges
//        float sum = 0; // Kernel sum for this pixel
//        for (int ky = -1; ky <= 1; ky++) {
//          for (int kx = -1; kx <= 1; kx++) {
//            // Calculate the adjacent pixel for this kernel point
//            int pos = (y + ky)*img.width + (x + kx);
//            // Image is grayscale, red/green/blue are identical
//            float val = red(img.pixels[pos]);
//            // Multiply adjacent pixels based on the kernel values
//            sum += kernel[ky+1][kx+1] * val;
//          }
//        }
//        // For this pixel in the new image, set the gray value
//        // based on the sum from the kernel
//        bimg.pixels[y*img.width + x] = color(sum/4+128);
//      }
//    }
//    // State that there are changes to edgeImg.pixels[]
//    bimg.updatePixels();
//    img.updatePixels();
//  }
  
//  void gradientBackground(color c1, color c2) {
//    for(int i=0; i<=width; i++){
//      for(int j=0; j<=height; j++){
//        color c = color((red(c1)+(j)*((red(c2)-red(c1))/height)),
//        (green(c1)+(j)*((green(c2)-green(c1))/height)),
//        (blue(c1)+(j)*((blue(c2)-blue(c1))/height)));
//        set(i, j, c);
//      }
//    }
//  } 

//  void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {
//    noFill();
//    if (axis == Y_AXIS) {  // Top to bottom gradient
//      for(int i = y; i <= y+h; i++) {
//        float inter = map(i, y, y+h, 0, 1);
//        color c = lerpColor(c1, c2, inter);
//        stroke(c, 128);
//        line(x, i, x+w, i);
//      }
//    }  
//    else if (axis == X_AXIS) {  // Left to right gradient
//      for(int i=x; i<=x+w; i++) {
//        float inter = map(i, x, x+w, 0, 1);
//        color c = lerpColor(c1, c2, inter);
//        stroke(c, 128);
//        line(i, y, i, y+h);
//      }
//    }
//  }
//}