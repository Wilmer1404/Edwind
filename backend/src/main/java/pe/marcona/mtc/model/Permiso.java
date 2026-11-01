package pe.marcona.mtc.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Entidad JPA representativa de la tabla {@code permits}.
 * Mapeo ORM Code-First para las Tarjetas Únicas de Circulación (TUC) y permisos municipales emitidos.
 */
@Entity
@Table(name = "permits")
public class Permiso implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", columnDefinition = "INT UNSIGNED")
    private Long id;

    @Column(name = "assignment_id", columnDefinition = "INT UNSIGNED")
    private Long assignmentId;

    @Column(name = "driver_id", columnDefinition = "INT UNSIGNED")
    private Long driverId;

    @Column(name = "vehicle_id", nullable = false, columnDefinition = "INT UNSIGNED")
    private Long vehicleId;

    @Column(name = "company_id", columnDefinition = "INT UNSIGNED")
    private Long companyId;

    @Column(name = "tipo_permiso", nullable = false, length = 50)
    private String tipoPermiso = "libre_transito";

    @Column(name = "numero_permiso", nullable = false, unique = true, length = 20)
    private String numeroPermiso;

    @Column(name = "fecha_emision", nullable = false)
    private LocalDate fechaEmision;

    @Column(name = "fecha_vencimiento", nullable = false)
    private LocalDate fechaVencimiento;

    @Column(name = "qr_code", nullable = false, columnDefinition = "LONGTEXT")
    private String qrCode;

    @Column(name = "estado", length = 50)
    private String estado = "vigente";

    @Column(name = "numero_recibo", length = 50)
    private String numeroRecibo;

    @Column(name = "monto_pagado", precision = 10, scale = 2)
    private BigDecimal montoPagado;

    @Column(name = "observaciones", columnDefinition = "TEXT")
    private String observaciones;

    @Column(name = "created_by", nullable = false, columnDefinition = "INT UNSIGNED")
    private Long createdBy;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    public Permiso() {
    }

    public Permiso(Long vehicleId, String numeroPermiso, LocalDate fechaEmision, LocalDate fechaVencimiento, String qrCode, Long createdBy) {
        this.vehicleId = vehicleId;
        this.numeroPermiso = numeroPermiso;
        this.fechaEmision = fechaEmision;
        this.fechaVencimiento = fechaVencimiento;
        this.qrCode = qrCode;
        this.createdBy = createdBy;
        this.estado = "vigente";
        this.tipoPermiso = "libre_transito";
    }

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (updatedAt == null) {
            updatedAt = LocalDateTime.now();
        }
        if (estado == null) {
            estado = "vigente";
        }
        if (tipoPermiso == null) {
            tipoPermiso = "libre_transito";
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(Long assignmentId) {
        this.assignmentId = assignmentId;
    }

    public Long getDriverId() {
        return driverId;
    }

    public void setDriverId(Long driverId) {
        this.driverId = driverId;
    }

    public Long getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(Long vehicleId) {
        this.vehicleId = vehicleId;
    }

    public Long getCompanyId() {
        return companyId;
    }

    public void setCompanyId(Long companyId) {
        this.companyId = companyId;
    }

    public String getTipoPermiso() {
        return tipoPermiso;
    }

    public void setTipoPermiso(String tipoPermiso) {
        this.tipoPermiso = tipoPermiso;
    }

    public String getNumeroPermiso() {
        return numeroPermiso;
    }

    public void setNumeroPermiso(String numeroPermiso) {
        this.numeroPermiso = numeroPermiso;
    }

    public LocalDate getFechaEmision() {
        return fechaEmision;
    }

    public void setFechaEmision(LocalDate fechaEmision) {
        this.fechaEmision = fechaEmision;
    }

    public LocalDate getFechaVencimiento() {
        return fechaVencimiento;
    }

    public void setFechaVencimiento(LocalDate fechaVencimiento) {
        this.fechaVencimiento = fechaVencimiento;
    }

    public String getQrCode() {
        return qrCode;
    }

    public void setQrCode(String qrCode) {
        this.qrCode = qrCode;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getNumeroRecibo() {
        return numeroRecibo;
    }

    public void setNumeroRecibo(String numeroRecibo) {
        this.numeroRecibo = numeroRecibo;
    }

    public BigDecimal getMontoPagado() {
        return montoPagado;
    }

    public void setMontoPagado(BigDecimal montoPagado) {
        this.montoPagado = montoPagado;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public Long getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Long createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Permiso{" +
                "id=" + id +
                ", numeroPermiso='" + numeroPermiso + '\'' +
                ", vehicleId=" + vehicleId +
                ", tipoPermiso='" + tipoPermiso + '\'' +
                ", estado='" + estado + '\'' +
                ", fechaVencimiento=" + fechaVencimiento +
                '}';
    }
}
