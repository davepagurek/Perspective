class GeneticPlotter {
  private class BoxGene {
    public float x, y, z, r, aX, aY;
    public float get(int property) {
      if (property == 0) return x/SIZE;
      if (property == 1) return y/SIZE;
      if (property == 2) return z/SIZE;
      if (property == 3) return (r-10)/30;
      if (property == 4) return aX/(2*PI);
      return aY/(2*PI);
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
  private ArrayList<BoxGene> spheres;
  private float s = 0;

  public GeneticPlotter(int numSpheres, PImage a, PImage b) {
    this.a = a;
    this.b = b;
    this.spheres = new ArrayList<BoxGene>();

    for (int i=0; i<numSpheres; i++) {
      BoxGene s = new BoxGene();
      s.x = random(0, SIZE);
      s.y = random(0, SIZE);
      s.z = random(0, SIZE);
      s.r = random(0, 30) + 10;
      s.aX = random(0, 2*PI);
      s.aY = random(0, 2*PI);
      spheres.add(s);
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
    for (BoxGene s : spheres) {
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
    int i = (int)random(0, spheres.size());
    int property = (int)random(0, 6);
    float old = spheres.get(i).get(property);
    spheres.get(i).set(property, random(0, 1));

    float newS = similarity();
    if (newS <= s) {
      s = newS;
    } else {
      spheres.get(i).set(property, old);
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
    //background(#FFFFFF);
    //image(side.get(), 0, 0);
    //println(s);
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
