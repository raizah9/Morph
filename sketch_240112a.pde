import controlP5.*;

ControlP5 cp5;
float morphSpeed = 0.1;
boolean etat = false; // Variable pour suivre l'état de morphing (cercle vers carré ou vice versa)
int derniereTouchePressee = 0; // Variable pour stocker la dernière touche pressée
color couleurCourante; // Variable pour stocker la couleur de trait actuelle

ArrayList<PVector> cercle = new ArrayList<PVector>(); // Vertices pour le cercle
ArrayList<PVector> carre = new ArrayList<PVector>(); // Vertices pour le carré
ArrayList<PVector> morphing = new ArrayList<PVector>(); // Vertices pour la morphing

void setup() {
  size(640, 360);
  cp5 = new ControlP5(this);
  cp5.addSlider("morphSpeed")
     .setPosition(10, height + 10)
     .setRange(0.01, 1.0)
     .setValue(morphSpeed);
  initialiserFormes();
  couleurCourante = color(255, 0, 0); // Couleur initiale : rouge
}

void keyPressed() {
  // Changer l'état (morphing de cercle à carré ou vice versa) lorsqu'une touche est pressée
  if (key != derniereTouchePressee) {
    etat = !etat;
    derniereTouchePressee = key;
    
    // Changer la couleur en fonction de la touche pressée
    if (key == 'r' || key == 'R') {
      couleurCourante = color(255, 0, 0); // Rouge
    } else if (key == 'v' || key == 'V') {
      couleurCourante = color(0, 255, 0); // Vert
    } else if (key == 'b' || key == 'B') {
      couleurCourante = color(0, 0, 255); // Bleu
    }
  }
}

void draw() {
  background(51);

  float distanceTotale = 0;

  stroke(couleurCourante); // Définir la couleur du trait

  for (int i = 0; i < cercle.size(); i++) {
    PVector v1;
    if (etat) {
      v1 = cercle.get(i);
    } else {
      v1 = carre.get(i);
    }
    PVector v2 = morphing.get(i);
    v2.lerp(v1, morphSpeed);
    distanceTotale += PVector.dist(v1, v2);
  }

  if (distanceTotale < 0.1) {
    // Pas besoin de basculer l'état ici
  }

  translate(width/2, height/2);
  strokeWeight(4);
  beginShape();
  noFill();
  for (PVector v : morphing) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);
}

void initialiserFormes() {
  // Initialiser les points pour le cercle
  for (int angle = 0; angle < 360; angle += 9) {
    PVector v = PVector.fromAngle(radians(angle - 135));
    v.mult(100);
    cercle.add(v);
    morphing.add(new PVector());
  }

  // Initialiser les points pour le carré
  for (int x = -50; x < 50; x += 10) {
    carre.add(new PVector(x, -50));
  }

  for (int y = -50; y < 50; y += 10) {
    carre.add(new PVector(50, y));
  }

  for (int x = 50; x > -50; x -= 10) {
    carre.add(new PVector(x, 50));
  }

  for (int y = 50; y > -50; y -= 10) {
    carre.add(new PVector(-50, y));
  }
}
