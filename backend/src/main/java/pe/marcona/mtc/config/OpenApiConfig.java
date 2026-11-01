package pe.marcona.mtc.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Configuración OpenAPI 3 (Swagger UI) para la documentación interactiva de la API TRANSIGOVAI.
 * Configura los metadatos institucionales y el esquema de seguridad global JWT (Bearer Token)
 * para habilitar el botón "Authorize" en Swagger UI y probar endpoints protegidos.
 */
@Configuration
public class OpenApiConfig {

    public static final String SECURITY_SCHEME_NAME = "BearerAuth";

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("API TRANSIGOVAI - MTC Marcona")
                        .version("1.0")
                        .description("Documentación interactiva de la API REST para el Sistema de Gestión de Transporte Urbano, " +
                                "Vehículos, Conductores, Empresas y Tarjetas Únicas de Circulación (TUC) de la Municipalidad Distrital de Marcona.")
                        .contact(new Contact()
                                .name("Subgerencia de Transporte y Seguridad Vial - Marcona")
                                .email("soporte@marcona.gob.pe")
                                .url("https://marcona.gob.pe"))
                        .license(new License()
                                .name("Uso Académico e Institucional")
                                .url("https://marcona.gob.pe")))
                .addSecurityItem(new SecurityRequirement().addList(SECURITY_SCHEME_NAME))
                .components(new Components()
                        .addSecuritySchemes(SECURITY_SCHEME_NAME,
                                new SecurityScheme()
                                        .name(SECURITY_SCHEME_NAME)
                                        .type(SecurityScheme.Type.HTTP)
                                        .scheme("bearer")
                                        .bearerFormat("JWT")
                                        .description("Ingrese su token de autenticación JWT (formato Bearer Token) obtenido al iniciar sesión en /api/auth/login.php")));
    }
}
