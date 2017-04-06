class GeneticPlotter {
  private class BoxGene {
    public float x, y, z, r, aX, aY;

    public BoxGene() {}

    public BoxGene(BoxGene other) {
      x = other.x;
      y = other.y;
      z = other.z;
      r = other.r;
      aX = other.aX;
      aY = other.aY;
    }

    public void set(int property, float value) {
      if (property == 0) {
        x = value*SIZE;
      } else if (property == 1) {
        y = value*SIZE;
      } else if (property == 2) {
        z = value*SIZE;
      } else if (property == 3) {
        r = value*30 + 10;
      } else if (property == 4) {
        aX = value*2*PI;
      } else if (property == 5) {
        aY = value*2*PI;
      }
    }
  }

  public static final int SIZE = 100;
  public PImage a, b;
  private ArrayList<BoxGene> genes;
  private float s = 0;

  public GeneticPlotter(int numgenes, PImage a, PImage b) {
    this.a = a;
    this.b = b;
    this.genes = new ArrayList<BoxGene>();

    for (int i=0; i<numgenes; i++) {
      BoxGene s = new BoxGene();
      s.x = random(0, SIZE);
      s.y = random(0, SIZE);
      s.z = random(0, SIZE);
      s.r = random(0, 30) + 10;
      s.aX = random(0, 2*PI);
      s.aY = random(0, 2*PI);
      genes.add(s);
    }

    s = similarity();
  }

  public void optimize(int iterations) {
    for (int i=0; i<iterations; i++) {
      runGeneration();
    }
  }

  public void draw(PGraphics graphics) {
    graphics.background(0xFFFFFF); //<>//
    graphics.pushMatrix();
    graphics.translate(0, 0, -SIZE);

    graphics.fill(0x000000);
    graphics.noStroke();
    for (BoxGene s : genes) {
      graphics.pushMatrix();
      graphics.translate(s.x, s.y, s.z);
      graphics.rotateY(s.aY);
      graphics.rotateX(s.aX);
      graphics.box(4, 4, s.r);
      graphics.popMatrix();
    }

    graphics.popMatrix();
    graphics.endDraw();
  }

  private void runGeneration() {
    ArrayList<BoxGene> oldGenes = genes;
    genes = new ArrayList<BoxGene>();
    for (BoxGene g : oldGenes) {
      genes.add(new BoxGene(g));
    }
    int numMutations = (int)random(1, 8);
    for (int m = 0; m < numMutations; m++) {
      int numProperties = (int)random(1, 3);
      for (int p = 0; p < numProperties; p++) {
        int i = (int)random(0, genes.size());
        int property = (int)random(0, 6);
        genes.get(i).set(property, random(0, 1));
      }
    }

    float newS = similarity();
    if (newS <= s) {
      s = newS;
    } else {
      genes = oldGenes;
    }
  }

  private float similarity() {
    PGraphics front = createGraphics(SIZE, SIZE, P3D);
    PGraphics side = createGraphics(SIZE, SIZE, P3D);
    
    front.beginDraw();
    draw(front);
    front.endDraw();
    
    side.beginDraw();
    side.translate(SIZE/2, 0, -SIZE/2);
    side.rotateY(PI/2);
    //side.rotateY((float(mouseX) - width/2) / float(width) * 2*PI + PI/2);
    side.translate(-SIZE/2, 0, SIZE/2);
    draw(side);
    side.endDraw();

    float s = 0;
    s += distance(front.get(), a);
    s += distance(side.get(), b);
    return s;
  }

  private float distance(PImage from, PImage to) {
    from.loadPixels();
    to.loadPixels();
    float r = 0, g = 0, b = 0;
    for (int i=0; i<from.pixels.length; i++) {
      color c1 = from.pixels[i];
      color c2 = to.pixels[i];
      r += abs((c1>>16&0xFF) - (c2>>16&0xFF));
      g += abs((c1>>8&0xFF) - (c2>>8&0xFF));
      b += abs((c1&0xFF) - (c2&0xFF));
    }
    r /= from.pixels.length;
    g /= from.pixels.length;
    b /= from.pixels.length;
    return (r+g+b)/3;
  }
}
