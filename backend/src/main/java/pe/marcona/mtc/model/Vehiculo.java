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
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Entidad JPA representativa de la tabla {@code vehicles}.
 * Mapeo ORM Code-First para el parque automotor registrado y habilitado (mototaxis, colectivos, taxis, carga).
 */
@Entity
@Table(name = "vehicles")
public class Vehiculo implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", columnDefinition = "INT UNSIGNED")
    private Long id;

    @Column(name = "driver_id", columnDefinition = "INT UNSIGNED")
    private Long driverId;

    @Column(name = "company_id", columnDefinition = "INT UNSIGNED")
    private Long companyId;

    @Column(name = "tipo_propiedad", length = 50)
    private String tipoPropiedad = "empresa";

    @Column(name = "tipo_servicio", length = 50)
    private String tipoServicio;

    @Column(name = "categoria", length = 20)
    private String categoria = "L5";

    @Column(name = "placa", nullable = false, unique = true, length = 7)
    private String placa;

    @Column(name = "marca", nullable = false, length = 50)
    private String marca;

    @Column(name = "modelo", nullable = false, length = 50)
    private String modelo;

    @Column(name = "color", nullable = false, length = 30)
    private String color;

    @Column(name = "ano_fabricacion")
    private Integer anoFabricacion;

    @Column(name = "numero_vin", length = 17)
    private String numeroVin;

    @Column(name = "numero_motor", length = 20)
    private String numeroMotor;

    @Column(name = "combustible", length = 50)
    private String combustible;

    @Column(name = "soat_poliza", length = 15)
    private String soatPoliza;

    @Column(name = "soat_aseguradora", length = 100)
    private String soatAseguradora;

    @Column(name = "soat_vencimiento")
    private LocalDate soatVencimiento;

    @Column(name = "rt_entidad", length = 100)
    private String rtEntidad;

    @Column(name = "rt_certificado", length = 50)
    private String rtCertificado;

    @Column(name = "rt_vencimiento")
    private LocalDate rtVencimiento;

    @Column(name = "estado", length = 50)
    private String estado = "activo";

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    public Vehiculo() {
    }

    public Vehiculo(String placa, String marca, String modelo, String color, String categoria) {
        this.placa = placa;
        this.marca = marca;
        this.modelo = modelo;
        this.color = color;
        this.categoria = categoria != null ? categoria : "L5";
        this.estado = "activo";
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
            estado = "activo";
        }
        if (tipoPropiedad == null) {
            tipoPropiedad = "empresa";
        }
        if (categoria == null) {
            categoria = "L5";
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

    public Long getDriverId() {
        return driverId;
    }

    public void setDriverId(Long driverId) {
        this.driverId = driverId;
    }

    public Long getCompanyId() {
        return companyId;
    }

    public void setCompanyId(Long companyId) {
        this.companyId = companyId;
    }

    public String getTipoPropiedad() {
        return tipoPropiedad;
    }

    public void setTipoPropiedad(String tipoPropiedad) {
        this.tipoPropiedad = tipoPropiedad;
    }

    public String getTipoServicio() {
        return tipoServicio;
    }

    public void setTipoServicio(String tipoServicio) {
        this.tipoServicio = tipoServicio;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getPlaca() {
        return placa;
    }

    public void setPlaca(String placa) {
        this.placa = placa;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getModelo() {
        return modelo;
    }

    public void setModelo(String modelo) {
        this.modelo = modelo;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public Integer getAnoFabricacion() {
        return anoFabricacion;
    }

    public void setAnoFabricacion(Integer anoFabricacion) {
        this.anoFabricacion = anoFabricacion;
    }

    public String getNumeroVin() {
        return numeroVin;
    }

    public void setNumeroVin(String numeroVin) {
        this.numeroVin = numeroVin;
    }

    public String getNumeroMotor() {
        return numeroMotor;
    }

    public void setNumeroMotor(String numeroMotor) {
        this.numeroMotor = numeroMotor;
    }

    public String getCombustible() {
        return combustible;
    }

    public void setCombustible(String combustible) {
        this.combustible = combustible;
    }

    public String getSoatPoliza() {
        return soatPoliza;
    }

    public void setSoatPoliza(String soatPoliza) {
        this.soatPoliza = soatPoliza;
    }

    public String getSoatAseguradora() {
        return soatAseguradora;
    }

    public void setSoatAseguradora(String soatAseguradora) {
        this.soatAseguradora = soatAseguradora;
    }

    public LocalDate getSoatVencimiento() {
        return soatVencimiento;
    }

    public void setSoatVencimiento(LocalDate soatVencimiento) {
        this.soatVencimiento = soatVencimiento;
    }

    public String getRtEntidad() {
        return rtEntidad;
    }

    public void setRtEntidad(String rtEntidad) {
        this.rtEntidad = rtEntidad;
    }

    public String getRtCertificado() {
        return rtCertificado;
    }

    public void setRtCertificado(String rtCertificado) {
        this.rtCertificado = rtCertificado;
    }

    public LocalDate getRtVencimiento() {
        return rtVencimiento;
    }

    public void setRtVencimiento(LocalDate rtVencimiento) {
        this.rtVencimiento = rtVencimiento;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
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
        return "Vehiculo{" +
                "id=" + id +
                ", placa='" + placa + '\'' +
                ", marca='" + marca + '\'' +
                ", modelo='" + modelo + '\'' +
                ", categoria='" + categoria + '\'' +
                ", estado='" + estado + '\'' +
                '}';
    }
}
