Shape[] shapes;
boolean drawGrid = true, drawBorder = true;            // Dibujar Grilla y Borde
float scale = 20;                                      // Tamaño de Escala
int state = 0;                                         // Pantalla Actual
float rotation = 0;                                    // Rotacion Auxiliar
color comparison;                                      // Color A Comparar
PVector position = new PVector (mouseX, mouseY);       // Posición Actual De Mouse
PImage start, menu, levels, bg, finish, instructions;  // Imagenes de Pantalla
PImage newLevel;                                       // Imagen Para Nuevo Nivel
PImage[] level;                                        // Imagenes De Niveles
int counter = 7;                                       // Contador Auxiliar
boolean saved = false;                                 // Interruptor De Guardado
int level_current = 0;                                 // Nivel Actual En Juego
int black_pixels = 5000;                               // Pixeles Negros En Pantalla
boolean complete = false;                              // Nivel Completado

/*--------------------------------------------------------------------------------------------------*/

void setup() {
  size(1280, 720);
  shapes = new Shape[7];
  level = new PImage[10];
  
  smooth(0);
  
  reboot();
  
  start = loadImage("start.png");
  menu = loadImage("menu.png");
  levels = loadImage("levels.png");
  bg = loadImage("background.png");
  finish = loadImage("perfect.png");
  instructions = loadImage("instrucciones.png");
  
  int i;
  
  for (i=1; i<level.length; i++){
    level[i] = loadImage("level_"+i+".png");
  }
  
}

/*--------------------------------------------------------------------------------------------------*/
                                                       
void drawGrid(float scale) {                           
  push();                                              // Funcion para dibujar una
  strokeWeight(1);                                     // cuadricula para apoyar
  int i;                                               // una mejor linealizacion 
  for (i=0; i<=width; i++) {                           // al momento de armar el 
    stroke(0, 0, 0, 20);                               // Tangram.
    line(i*scale*2, 50, i*scale*2, height-50);
  }
  for (i=0; i<=height; i++) {
    stroke(0, 0, 0, 20);
    line(50, i*scale*2, width-50, i*scale*2);
  }
  pop();
}

/*--------------------------------------------------------------------------------------------------*/

void drawBorder(){
  image(bg,0,0);
  stroke(65,70,140);
  strokeWeight(2);
  fill(255);
  rect(50, 50,width-100, height-100, 10);
}

/*--------------------------------------------------------------------------------------------------*/

void draw() {
  background(255, 255, 255);
  
  menu();  
}

/*--------------------------------------------------------------------------------------------------*/

void drawShapes(){
  
  if (drawBorder) { drawBorder(); }                    // Activa o desactiva el borde
  if (drawGrid) { drawGrid(10); }                      // Activa o desactiva la grilla
  
  actualLevel(level_current);
  
  for (Shape shape : shapes) { shape.draw(); }         // Dibuja las piezas del Tangram
  
  if (comprobation()){
    complete = true;
  }
  
  if (complete){
    image(finish,0,0);
  }
}

/*--------------------------------------------------------------------------------------------------*/

void reboot(){                                         // Crea las figuras del Tangram
  shapes[0] = new Triangle(6*sqrt(2)*scale);           // Triangulo Grande 1
  shapes[1] = new Triangle(6*sqrt(2)*scale);           // Triangulo Grande 2
  shapes[2] = new Triangle(6*scale);                   // Triangulo Mediano
  shapes[3] = new Triangle(3*sqrt(2)*scale);           // Triangulo Pequeño 1
  shapes[4] = new Triangle(3*sqrt(2)*scale);           // Triangulo Pequeño 2
  shapes[5] = new Square(3*sqrt(2)*scale);             // Cuadrado
  shapes[6] = new Rhomboid(6*scale);                   // Romboide 
}

/*--------------------------------------------------------------------------------------------------*/

void menu(){
  if (state == 0){
    image(start,0,0);                                  // Pantalla Inicial
  } else if (state == 1) {
    image(menu,0,0);                                   // Pantalla Opciones
  } else if (state == 2) {
    image(levels,0,0);                                 // Pantalla Niveles
  } else if (state == 3) {
    drawShapes();                                      // Pantalla Juego
  } else if (state == 4) {
    image(instructions,0,0);                           // Pantalla Instrucciones
  }
}

/*--------------------------------------------------------------------------------------------------*/

void actualLevel(int level_current){
  int i;                                               // Comprueba el nivel que el
  for (i=1; i<level.length; i++){                      // usuario a elegido, en caso de
    if (i == level_current){                           // no elegirse alguno no mostrará
      image(level[i],0,0);                             // imagen, sino, mostrará la
    }                                                  // imagen correspondiente
  }
  
  
}

/*--------------------------------------------------------------------------------------------------*/

boolean comprobation(){
  black_pixels = 0;
  loadPixels();
  
  for (int i = 0; i <pixels.length; i++){
    if (color(pixels[i]) == color(0)){
      black_pixels++;}
  }
  
  if ((black_pixels<=1500)&&(level_current!=0)){
    for (Shape shape : shapes) {                       // Apagar todos los interruptores
      if (shape.use()){ shape.changeUse();}            // de uso de las piezas
    }
    return true;
  } else { return false; }
}

/*--------------------------------------------------------------------------------------------------*/

void mouseClicked(){
   comparison = get(mouseX, mouseY);                   // Color del pixel bajo el mouse
   
   for (Shape shape : shapes) {                        // Compara el color bajo el pixel
   shape.contains(comparison);                         // con cada pieza, si es igual
 }                                                     // activa el interruptor de movimiento.
}

/*--------------------------------------------------------------------------------------------------*/

void mouseDragged(){
  position = new PVector (mouseX, mouseY);             // Posicion actual de mouse
   
  for (Shape shape : shapes) {
      if (shape.use()){                                // Traslada la figura 
        shape.setPosition(position);                   // seleccionada hasta la
        shape.draw();                                  // posicion actual del mouse
      }
    }
}

/*--------------------------------------------------------------------------------------------------*/

void keyPressed() {
  if (key == 'g' || key == 'G') {
    drawGrid = !drawGrid;                              // Interruptor De La Grila
  }
  
  if (key == 'b' || key == 'B') {
    drawBorder = !drawBorder;                          // Interruptor Del Borde
  }
  
  if (key == ' '){
    if (state == 0){
      state = 1;                                      // Pasar Pantalla 0 a 1
    }
    if (state == 3 && saved == true){
      save("level_"+counter+".png");                  // Guardar la figura actual con
      newLevel = loadImage("level_"+counter+".png");  // filtros para que sea capaz
      newLevel.filter(GRAY);                          // de usarse en algún nivel
      newLevel.filter(THRESHOLD, 1.0);
      newLevel.save("level_"+counter+".png");
      counter ++;
    }
    if (state == 3 && level_current !=0 && complete == true){
      complete = false;
        reboot();
      if (level_current != 9){
        level_current ++;
      } else {
        state = 1;
        level_current = 0;
      }
    }
  }
  
  if (key == '1') {
    if (state == 1){                                  // Pasar pantalla 1 a 3
      state = 3;
      saved = !saved;
    }
    if (state == 2){
      state = 3;
      level_current = 1;                               // Nivel 1
    }
  }
  
  if (key == '2'){
    if (state == 1){                                  // Pasar pantalla 1 a 2
      state = 2;
    } else if (state == 2){
      state = 3;
      level_current = 2;                               // Nivel 2
    }
  }
  
  if (key == '3'){
    if (state == 1){
      state = 4;
    }
    if (state == 2){
      state = 3;
      level_current = 3;                               // Nivel 3
    }
  }
  
  if (key == '4'){
    if (state == 2){
      state = 3;
      level_current = 4;                               // Nivel 4
    }
  }
  
  if (key == '5'){
    if (state == 2){
      state = 3;
      level_current = 5;                               // Nivel 5
    }
  }
  
  if (key == '6'){
    if (state == 2){
      state = 3;
      level_current = 6;                               // Nivel 6
    }
  }
  
  if (key == '7'){
    if (state == 2){
      state = 3;
      level_current = 7;                               // Nivel 7
    }
  }
  
  if (key == '8'){
    if (state == 2){
      state = 3;
      level_current = 8;                               // Nivel 8
    }
  }
  
  if (key == '9'){
    if (state == 2){
      state = 3;
      level_current = 9;                               // Nivel 9
    }
  }
  
  if (key == 'w' || key == 'W') {
    for (Shape shape : shapes) {                      // Aumentar 45°la figura
      if (shape.use()){                               // seleccionada.
        rotation = shape.rotation()+QUARTER_PI;
        shape.setRotation(rotation);
        shape.draw();
      }
    }
  }
  
  if (key == 's' || key == 'S') {
    for (Shape shape : shapes) {                      // Reducir 45°la figura
      if (shape.use()){                               // seleccionada.
        rotation = shape.rotation()-QUARTER_PI;
        shape.setRotation(rotation);
        shape.draw();
      }
    }
  }
  
  if (key == 'd' || key == 'D') {
    for (Shape shape : shapes) {                      // Reflejar la figura 
      if (shape.use()){                               // seleccionada.
        shape.reflect();
        shape.draw();
      }
    }
  }
  
  if (key == 'r' || key == 'R'){
    if (state != 0){                                  // Regresa a pantalla 1
      state = 1;
      reboot();                                       // Recrear las piezas
      drawGrid = true;                                // Volver a dibujar la rejilla
      drawBorder = true;                              // Volver a dibujar el borde
      level_current = 0;
    }
    if (saved){                                       // Quitar la opcion de guardar
      saved = !saved;                                 // imagen
    }
  }
}
