PImage faith;
PImage smaller;
PImage[] pics = new PImage[81];

float[] brightness = new float[pics.length];
PImage[] brightImages = new PImage[256];

float[] hues = new float[pics.length];
PImage[] hueImages = new PImage[256];

int scl = 4;
int h, w;
void setup() {
  noStroke();
  frameRate =1;
  faith = loadImage("Faith.jpeg");
  surface.setSize(faith.width, faith.height);
  w = faith.width/scl;
  h = faith.height/scl;

  smaller = createImage(w, h, RGB);
  smaller.copy(faith, 0, 0, faith.width, faith.height, 0, 0, w, h);


  for (int i = 0; i < pics.length; i++) {
    String imageName = "data/pics/pic" + nf(i, 3) + ".jpg";
    pics[i] = loadImage(imageName);

    pics[i].loadPixels();
    float avg = 0;
    float avgh = 0;
    for (int j = 0; j < pics[i].pixels.length; j++) {
      float b = brightness(pics[i].pixels[j]);

      avg += b;

      //float h = hue(pics[i].pixels[j]);

      //avgh += h;
    }

    avg /= pics[i].pixels.length;
    brightness[i] = avg;

    //avgh /= pics[i].pixels.length;
    //hues[i] = avgh;
  }

  for (int i = 0; i < brightImages.length; i++) {
    float closest = 256;
    for (int j = 0; j < brightness.length; j++) {
      float diff = abs(i-brightness[j]);
      if (diff<closest) {
        closest = diff;
        brightImages[i] = pics[j];
      }
    }
    
    //float closest2 = 256;
    //for (int j = 0; j < hues.length; j++) {
    //  float diff = abs(i-hues[j]);
    //  if (diff<closest) {
    //    closest = diff;
    //    hueImages[i] = pics[j];
    //  }
    //}
  }
  
  printArray(brightness);
}

void draw() {
  //scl--;
  //image(faith, 0, 0);  
  //image(smaller, 0, 0); 
  background(0);
  smaller.loadPixels();
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      int index = x + y * w;
      color c = smaller.pixels[index];
      int imageIndex = int(brightness(c));
      image(brightImages[imageIndex], x*scl, y*scl, scl, scl);
    }
  }

  //for (int x = 0; x < w; x++) {
  //  for (int y = 0; y < h; y++) {
  //    int index = x + y * w;
  //    color c = smaller.pixels[index];
  //    int imageIndex = int(hue(c));
  //    image(hueImages[imageIndex], x*scl, y*scl, scl, scl);
  //  }
  //}

  //noLoop();
}