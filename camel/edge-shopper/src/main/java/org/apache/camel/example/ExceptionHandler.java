package org.apache.camel.example;

import io.quarkus.security.ForbiddenException;
import jakarta.enterprise.context.ApplicationScoped;
import io.quarkus.vertx.web.Route;
import io.vertx.ext.web.RoutingContext;

@ApplicationScoped
public class ExceptionHandler {

    @Route(type = Route.HandlerType.FAILURE)
    public void handleForbidden(RoutingContext context) {
        if (context.failure() instanceof ForbiddenException) {
            // Handle 403 Forbidden exceptions here
            context.response().setStatusCode(403)
                .putHeader("content-type", "text/html")
                .sendFile("META-INF/resources/denied.html");  // Serve the denied.html page
        } else {
            context.next();  // Continue with the default failure handler for other exceptions
        }
    }
}

