FROM quay.io/keycloak/keycloak:23.0.3 as builder

#ENV KC_HEALTH_ENABLED=true
ENV KC_FEATURES=token-exchange
#ENV KC_HTTP_RELATIVE_PATH="/auth"

# Install custom providers

# Apple Social Identity Provider - https://github.com/klausbetz/apple-identity-provider-keycloak
ADD --chown=keycloak:keycloak https://github.com/klausbetz/apple-identity-provider-keycloak/releases/download/1.7.0/apple-identity-provider-1.7.0.jar /opt/keycloak/providers/apple-identity-provider-1.7.0.jar

# build optimized image
RUN /opt/keycloak/bin/kc.sh build 

FROM quay.io/keycloak/keycloak:23.0.3

COPY --from=builder /opt/keycloak/ /opt/keycloak/
WORKDIR /opt/keycloak

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]