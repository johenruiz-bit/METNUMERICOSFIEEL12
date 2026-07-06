// --- ADQUISICION DE DATOS ---

unsigned long tiempoAnterior = 0;
// Bajamos el intervalo a 200 microsegundos (0.2 ms) para alta resolución
const unsigned long intervaloMuestreo = 200; 

int contadorMuestras = 0;           

const int maxMuestras = 30;        

void setup() {
  Serial.begin(250000); 
  Serial.println("Tiempo(us),Vin_V,Vout_V"); 
}

void loop() {
  if (contadorMuestras < maxMuestras) {
    
    unsigned long tiempoActual = micros(); 
    
    if (tiempoActual - tiempoAnterior >= intervaloMuestreo) {
      tiempoAnterior = tiempoActual; 
      
      int lecturaIn = analogRead(A0);   
      int lecturaOut = analogRead(A1);  
      
      float voltajeIn = (lecturaIn * 5.0) / 1023.0;
      float voltajeOut = (lecturaOut * 5.0) / 1023.0;
      
      Serial.print(tiempoActual);
      Serial.print(",");
      Serial.print(voltajeIn, 4); 
      Serial.print(",");
      Serial.println(voltajeOut, 4);
      
      contadorMuestras++; 
      
      if (contadorMuestras == maxMuestras) {
        Serial.println("--- CAPTURA FINALIZADA ---");
      }
    }
  }
}