GeneticPlotter plotter;

void setup() {
  //size(800, 450, P3D);
  size(100, 100, P3D);
  //pixelDensity(displayDensity());
  plotter = new GeneticPlotter(100, loadImage("img/face.png"), loadImage("img/bro.png"));
}

void draw() {
  plotter.optimize(10);
  pushMatrix();
  
  translate(50, 0, -50);
  rotateY(float(mouseX) / float(2*width) * PI);
  translate(-50, 0, 50);
  
  //translate(0, 0, 100);
  
  
  plotter.draw(getGraphics());
  
  popMatrix();
}
