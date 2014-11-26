import remixlab.proscene.*;

PShader PixelShader, colorShader;
PGraphics PixelGraphics, SrcGraphics, colorGraphics;
Scene PixelScene, SrcScene, colorScene;
boolean original;
color cols[];
float posns[];

public void setup() {
  size(700, 700, P2D);
  colorMode(HSB, 255);
  cols = new color[100];
  posns = new float[300];
  
  for (int i = 0; i<100; i++){
    posns[3*i]=random(-1000, 1000);
    posns[3*i+1]=random(-1000, 1000);
    posns[3*i+2]=random(-1000, 1000);
    cols[i]= color(255 * i / 100.0, 255, 255, 255);
  }
  
  SrcGraphics = createGraphics(width, height, P3D);
  SrcScene = new Scene(this, SrcGraphics);
  SrcScene.setRadius(1000);
  SrcScene.showAll();
  
  //colorShader = loadShader("colorfrag.glsl");
  colorGraphics = createGraphics(width, height, P3D);
  //colorGraphics.shader(colorShader);
  colorScene = new Scene(this, colorGraphics);
  colorScene.setRadius(1000);
  colorScene.showAll();
  colorScene.setCamera(SrcScene.camera());
  colorScene.disableMouseAgent();
  colorScene.disableKeyboardAgent();
    
  PixelShader = loadShader("pixelate.glsl");
  PixelGraphics = createGraphics(width, height, P3D);
  PixelGraphics.shader(PixelShader);
  PixelShader.set("xPixels", 100.0);
  PixelShader.set("yPixels", 100.0);
  
  frameRate(1000);
}

public void draw() {
  background(0);
  drawGeometry(SrcScene);
  drawGeometry(colorScene);

  if (original) {
    image(colorScene.pg(), 0, 0);
  } else {   
    PixelGraphics.beginDraw();
    PixelShader.set("tex", colorGraphics);
    PixelGraphics.image(SrcGraphics, 0, 0);
    PixelGraphics.endDraw();    
    image(PixelGraphics, 0, 0);
  }
}

private void drawGeometry(Scene scene) {
  PGraphics pg = scene.pg();
  pg.beginDraw();
  scene.beginDraw();
  pg.background(0);
  pg.noStroke();
  pg.lights();
  for (int i = 0; i < 100; i++) {
    pg.pushMatrix();
    pg.fill(cols[i]);
    pg.translate(posns[3*i], posns[3*i+1], posns[3*i+2]);
    pg.box(60);
    pg.popMatrix();
  }
  scene.endDraw();
  pg.endDraw();
}

void keyPressed() {
  original = !original;
}
