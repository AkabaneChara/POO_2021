int cell[];
int scale = 15; // Tamaño de Celdas
int size;

boolean pause = false; // Estado de Pausa
boolean deleted = false; // Estado de Eliminar

float chance = 0.5; // Probabilidad de Vivencia

int fr = 10; // Velocidad Inicial de Frames

void setup() {  
  size(750, 750);
  size = width/scale;
  
  cell = new int[size * size];
  
  commands();
  reboot();
  
}

// Lista de comandos que se pueden usar para el juego
void commands(){
  println("Commands For Use");
  println("W : Speed Up");
  println("S : Slow Down");
  println("Space : Pause");
  println("D : Delete Drawing");
  println("Mouse Dragged : Drawing");
  println("Z : Eliminate Life");
  println("A : Pattern Still Lifes");
  println("B : Pattern Oscillators");
  println("C : Pattern Spaceships");
  println("R : Reboot");
}

// Función que genera automaticamente la vida en el juego
void reboot(){
  for(int i = 0; i<cell.length; i ++) {
    if(random(1)<chance) {
      cell[i] = 1;
    } else {
      cell[i] = 0;
    }
  }
}

// Función que lleva a cabo e juego
void draw() {
  background(255);
  drawCell();
  drawGrid();
  
  if(frameCount % fr == 0 && !pause) {
    nextcell();
  }
}


int numN(int i, int j) {
  int num = 0;
  
  for(int x = -1; x <= 1; x ++) {
    for(int y = -1; y <= 1; y ++) {
      if(x == 0 && y == 0) continue;
      int ni = i + x;
      int nj = j + y;
      num += cell[pos(ni, nj)];
    }
  }
  return num;
}

// Función que genera la proxima generación de celulas
void nextcell() {
  int[] next = cell.clone();
  for(int i = 0; i<size; i ++) {
    for(int j = 0; j<size; j ++) {
      int n = numN(i, j);
      if(cell[pos(i, j)] == 1) {
        if(n<2 || n > 3) {
          next[pos(i, j)] = 0;
        }
      } else {
        if(n == 3) {
          next[pos(i, j)] = 1;
        }
      }
    }
  }
  cell = next.clone();
}

// Función que dibuja la cuadricula
void drawGrid() {
  stroke(150);
  for(int i = 0; i<size; i ++) {
    line(i * scale, 0, i * scale, height);
    line(0, i * scale, width, i * scale);
  }
  noFill();
  stroke(255, 0, 0);
  int x = mouseX/scale;
  int y = mouseY/scale;
  rect(x * scale, y * scale, scale, scale);
}

void drawCell() {
  noStroke();
  fill(0);
  for(int i = 0; i<size; i ++) {
    for(int j = 0; j<size; j ++) {
      if(cell[pos(i, j)] == 1) {
        rect(i * scale, j * scale, scale, scale);
      }
    }
  }
}

// Función que elimina toda la vida
void zero() {
  for(int i = 0; i<cell.length; i ++) {
    cell[i] = 0;
  }  
}

// Función que genera los patrones "Still Lifes"
void still(){
  zero();
  for(int i=0; i<cell.length; i++){
    if(i == ((size)+1)){
      cell[i] = 1;
      cell[i+1] = 1;
    }
    if(i == ((size*2)+1)){
      cell[i] = 1;
      cell[i+1] = 1;
    }
    if(i == ((size*6)+2)){
      cell[i] = 1;
      cell[i+1] = 1;
    }
    if(i == ((size*7)+1)){
      cell[i] = 1;
      cell[i+3] = 1;
    }
    if(i == ((size*8)+2)){
      cell[i] = 1;
      cell[i+1] = 1;
    }
    if(i == ((size*12)+2)){
      cell[i] = 1;
    }
    if(i == ((size*13)+1)){
      cell[i] = 1;
      cell[i+2] = 1;
    }
    if(i == ((size*14)+2)){
      cell[i] = 1;
    }
  }
}

// Función que genera los patrones "Oscillators"
void oscillators(){
  zero();
  for(int i=0; i<cell.length; i++){
    if(i == ((size*2)+1)){
      cell[i] = 1;
      cell[i+1] = 1;
      cell[i+2] = 1;
    }
    if(i == ((size*6)+1)){
      cell[i] = 1;
      cell[i+1] = 1;
    }
    if(i == ((size*7)+1)){
      cell[i] = 1;
      cell[i+1] = 1;
    }
    if(i == ((size*8)+3)){
      cell[i] = 1;
      cell[i+1] = 1;
    }
    if(i == ((size*9)+3)){
      cell[i] = 1;
      cell[i+1] = 1;
    }
    if(i == ((size*13)+2)){
      cell[i] = 1;
      cell[i+1] = 1;
      cell[i+2] = 1;
    }
    if(i == ((size*14)+1)){
      cell[i] = 1;
      cell[i+1] = 1;
      cell[i+2] = 1;
    }
  }
}

// Función que genera los patrones "Spaceships"
void spaceships(){
  zero();
   for(int i=0; i<cell.length; i++){
     if(i == ((size*2)+3)){
       cell[i] = 1;
     }
     if(i == ((size*3)+1)){
       cell[i] = 1;
       cell[i+2] = 1;
     }
     if(i == ((size*4)+2)){
       cell[i] = 1;
       cell[i+1] = 1;
     }
     if(i == ((size*20)+3)){
       cell[i] = 1;
       cell[i+1] = 1;
       cell[i+2] = 1;
       cell[i+3] = 1;
     }
     if(i == ((size*21)+2)){
       cell[i] = 1;
       cell[i+4] = 1;
     }
     if(i == ((size*22)+6)){
       cell[i] = 1;
     }
     if(i == ((size*23)+2)){
       cell[i] = 1;
       cell[i+3] = 1;
     }
   }
}

int pos(int i, int j) {
  i = constrain(i, 0, size - 1);
  j = constrain(j, 0, size - 1);
  
  return i + j * size;
}

void setCell(int i, int j, int v) {
  cell[pos(i, j)] = v;
}

// Función para el dibujo o borrador en el juego
void mouseDragged() {
  if(deleted) {
    setCell(mouseX/scale, mouseY/scale, 0);
  } else {
    setCell(mouseX/scale, mouseY/scale, 1);
  }
}

// Funcion donde se encuentran todos los comandos
void keyPressed() {
  if(key == 'w') {
    fr = constrain(fr - 1, 1, 20);
  }
  if(key == 's') {
    fr = constrain(fr + 1, 1, 20);
  }
  if(key == ' ') {
    pause = !pause;
  }
  if(key == 'd') {
    deleted = !deleted;
  }
  if(key == 'z') {
    zero();
  }
  if(key == 'a') {
    still();
  }
  if(key == 'b'){
    oscillators();
  }
  if(key == 'c'){
    spaceships();
  }
  if(key == 'r'){
    reboot();
  }
}

// Algunas funciones de este codigo han sido inspiradas en el video explicativo de Barney relacionado al Juego de Conway.
