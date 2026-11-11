import http from 'k6/http';
import { check, sleep } from 'k6';

// Configuración de Prueba de Estrés Agresiva (500 VUs)
export const options = {
  stages: [
    { duration: '10s', target: 500 }, // Sube violentamente a 500 usuarios
    { duration: '30s', target: 500 }, // Mantiene el bombardeo masivo por medio minuto
    { duration: '10s', target: 0 },   // Rampa de bajada
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // El 95% debe responder en menos de 500ms bajo estrés máximo
    http_req_failed: ['rate<0.05'],   // Tolerancia de hasta 5% de errores por saturación
  },
};

export default function () {
  const res = http.get('http://localhost:8080/actuator/health');

  check(res, {
    'Status HTTP es 200 OK': (r) => r.status === 200,
  });

  // Reducimos la pausa a medio segundo para duplicar la agresividad del ataque
  sleep(0.5);
}
