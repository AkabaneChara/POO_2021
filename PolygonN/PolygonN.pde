void setup(){
  size(800, 800);
  background(0);
  fill(#830505);
  translate(width/2, height/2); //Ubicación Central
  polygon(12, 300);
}

void polygon(int size, float radius){
  float angle = 0.0; //Angulo
  float x = 0.0; // Posición X
  float y = 0.0; // Posición Y
  
  beginShape(); //Iniciar Figura
  
  for(int i=0; i<size; i++){
    x = cos(angle) * radius; // Nueva Posición X
    y = sin(angle) * radius; // Nueva Posición Y
    vertex(x,y); // Punto Vertice
    angle += TWO_PI/size; // Nuevo Angulo
  }
  
  endShape(CLOSE); // Terminar Figura Llenado
}
