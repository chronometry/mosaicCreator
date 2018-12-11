PImage faith;
PImage smaller;
PImage[] pics = new PImage[81];


float[] brightness = new float[pics.length];
float[] hue        = new float[pics.length];
float[] saturation = new float[pics.length];

//brightness, hue, saturation because fuck
PImage[][][] imageTable = new PImage[256][256][256];


int scl = 3;
int h, w;
void setup() {
  colorMode(HSB);
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

    float avgb = 0;
    float avgh = 0;
    float avgs = 0;
    for (int j = 0; j < pics[i].pixels.length; j++) {
      float b = brightness(pics[i].pixels[j]);
      avgb += b;
      float h = hue(pics[i].pixels[j]);
      avgh += h;
      float s = saturation(pics[i].pixels[j]);
      avgs += s;
    }

    avgb /= pics[i].pixels.length;
    brightness[i] = avgb;

    avgh /= pics[i].pixels.length;
    hue[i]        = avgh;

    avgs /= pics[i].pixels.length;
    saturation[i] = avgs;
  }

  for (int b = 0; b < imageTable.length; b++) {
    for (int h = 0; h < imageTable.length; h++) {
      for (int s = 0; s < imageTable.length; s++) {
        float closest = 256*3;
        int record = 0;
        for (int j = 0; j < brightness.length; j++) {
          float diff = abs(b-brightness[j]) + abs(h-hue[j]) + abs(s-saturation[j]);
          
          if(diff<closest) {
            closest = diff;
            record = j;
          }
        }
        
        imageTable[b][h][s] = pics[record];
      }
    }
  }

  printArray(imageTable);
}

void draw() {
  background(0);
  smaller.loadPixels();
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      int index = x + y * w;
      color c = smaller.pixels[index];
      int b = int(brightness(c));
      int h = int(hue(c)); 
      int s = int(saturation(c));
      image(imageTable[b][h][s], x*scl, y*scl, scl, scl);
      
      if (mouseX > x*scl && mouseX < (x+1)*scl && mouseY > y*scl && mouseY < (y+1)*scl
        && mousePressed) {
          image(imageTable[b][h][s], 0, 0);
      }
    }
  }
}
