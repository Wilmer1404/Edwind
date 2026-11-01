package pe.marcona.mtc.service.scheduler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import pe.marcona.mtc.service.IPermisoService;

import java.util.List;

/**
 * Tarea programada (Cron Job) para la automatización del ciclo de vida de los permisos de circulación (TUC).
 * Requerimiento de la Unidad 4: Monitoreo y Mantenimiento Operacional.
 * Verifica periódicamente y marca como vencidos los permisos cuya fecha de vencimiento ha expirado.
 */
@Component
public class PermisoScheduler {

    private static final Logger log = LoggerFactory.getLogger(PermisoScheduler.class);

    private final IPermisoService permisoService;

    public PermisoScheduler(IPermisoService permisoService) {
        this.permisoService = permisoService;
    }

    /**
     * Tarea programada que se ejecuta todos los días a la medianoche (00:00:00).
     * Invoca la lógica de negocio para marcar como inactivos/vencidos los permisos caducados
     * y registra la operación en los logs del sistema mediante SLF4J.
     */
    @Scheduled(cron = "0 0 0 * * ?")
    public void verificarPermisosVencidos() {
        log.info("[CRON SCHEDULER] Iniciando verificación automática de permisos vencidos...");
        try {
            // Se utiliza el actor del sistema (ID 1) y solicitud null para ejecuciones de fondo
            List<Long> permisosActualizados = permisoService.marcarExpirados(1L, null);
            if (permisosActualizados == null || permisosActualizados.isEmpty()) {
                log.info("[CRON SCHEDULER] Verificación finalizada. No se hallaron permisos vencidos pendientes.");
            } else {
                log.warn("[CRON SCHEDULER] Se actualizaron exitosamente {} permisos a estado 'vencido'. IDs: {}",
                        permisosActualizados.size(), permisosActualizados);
            }
        } catch (Exception ex) {
            log.error("[CRON SCHEDULER ERROR] Fallo durante la ejecución de verificarPermisosVencidos()", ex);
        }
    }
}
