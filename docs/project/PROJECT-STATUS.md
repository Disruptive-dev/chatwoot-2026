# PROJECT-STATUS — OptimiA

> Fuente de verdad del estado del proyecto. Actualizar al cierre de cada sprint.  
> Última actualización: 2026-11-20 (verificación Super Admin 500 en `develop`)

## Identidad

| Campo | Valor |
|-------|-------|
| **Proyecto** | OptimiA |
| **Base** | Chatwoot |
| **Versión Chatwoot** | 4.10.1 |
| **Versión OptimiA** | 0.2.3 (`Optimia::VERSION`; imagen de este HEAD no publicada por este sprint) |
| **Repositorio actual** | `pablo-paez-dev/chatwoot` |
| **Registry CI activo** | `ghcr.io/disruptive-dev/chatwoot` (fallback de `optimia-build-*.yml` si `OPTIMIA_GHCR_REGISTRY` está vacío) |
| **Registry objetivo** | `ghcr.io/dsw-factory/optimia-chatwoot` (ADR-001 — pendiente GHCR_TOKEN) |
| **Rama activa** | `develop` @ `dbecec644` + verificación Super Admin (ver handoff 2026-11-20) |

## Commits de referencia

| Referencia | SHA | Descripción |
|------------|-----|-------------|
| Commit funcional | `462802c9e` | Optimia Inbox v0.1.2 |
| Sprint 0 docs | `5ab2bb5e4` | Trazabilidad y baseline |
| Sprint 0 continuidad | `86d316283` | Protocolo cross-session |
| Sprint 1 staging | `c3537990d` | Preparación staging aislado |
| Sprint 2 Connection Center | *(ver `git log`)* | Channel Manager + WhatsApp Connection Center |
| Sprint 3 Technical Health | *(ver `git log` tras commit)* | Technical Health Center v0.2.0 |
| Baseline fork | `6a7cbcf5` | Último upstream antes de OptimiA |
| Tag baseline | `chatwoot-base/v4.10.1` → `6a7cbcf5` | Publicado en origin |

## Producción (verificado — NO MODIFICAR)

| Componente | Valor |
|------------|-------|
| Imagen | `ghcr.io/disruptive-dev/chatwoot:v4.10.1-optimia.6` |
| Web | `chatwoot` |
| Worker | `chatwoot-sidekiq` (misma imagen, Sidekiq operativo) |
| PostgreSQL | `chatwoot-db` |
| Redis | `chatwoot-redis` |
| Dominio | `https://app.optimia.spectra-metrics.com` |
| Estado | Clientes reales, operativo |
| Versión OptimiA prod | 0.1.x (sin Technical Health Center) |

## Staging

| Campo | Estado |
|-------|--------|
| **Entorno** | NO CREADO — documentación lista |
| **Dominio propuesto** | `https://staging.optimia.spectra-metrics.com` |
| **Imagen propuesta** | `ghcr.io/pablo-paez-dev/chatwoot:staging-cw-4.10.1-optimia-0.2.0` |
| **Workflow build** | `optimia-build-staging.yml` (manual o tag `staging-cw-*`) |
| **Guía EasyPanel** | `docs/optimia/operations/easypanel-staging-setup-guide.md` |

## Sprints

| Sprint | Estado |
|--------|--------|
| Sprint 0 — Trazabilidad y baseline | **FINALIZADO** |
| Sprint 1 — Preparación staging aislado | **FINALIZADO** (sin deploy) |
| Sprint 1b — Creación staging EasyPanel | **PENDIENTE** (acción humana) |
| Sprint 2 — Channel Manager + Connection Center | **IMPLEMENTADO** (pendiente staging QA) |
| Sprint 3 — Technical Health Center v0.2.0 | **MERGEADO** a develop |
| Sprint v0.2.1 — CI/CD Platform Cleanup | **MERGEADO** a develop (sin deploy desde este sprint) |
| Verificación Super Admin 500 | **CERRADA EN CÓDIGO** (`07747ebd7` ya en develop; specs de regresión). Sin deploy. |

## ADRs

| ADR | Estado |
|-----|--------|
| ADR-001 (repo canónico) | ACEPTADO con fallback `pablo-paez-dev` |
| ADR-002 (CI único) | ACEPTADO — `optimia-ci.yml` |
| ADR-003 (versionado/tags) | ACEPTADO |
| ADR-004 (Channel Manager) | ACEPTADO |
| CI/CD ADR-001–004 | ACEPTADO — ver `docs/optimia/cicd/decisions.md` |

## Bloqueos

1. Staging no desplegado — requiere acción humana en EasyPanel.
2. Imagen staging v0.2.0 pendiente publicación (autorización post-merge PR CI/CD).
3. DSW-Factory GHCR cross-org — requiere `GHCR_TOKEN` org.
4. Sprint 2 y 3 requieren validación en staging.
5. Migración BD Technical Health pendiente hasta deploy staging.

## Próximo paso exacto

1. Merge del PR de specs de regresión Super Admin → `develop`.
2. Autorización humana: `optimia-build-staging.yml` en `develop` con `optimia_version=0.2.3`, `chatwoot_version=4.10.1`, `dry_run=false`.
3. Copiar el digest `sha256:` del job summary / `staging-image-metadata.json`.
4. Autorización humana: `optimia-build-production.yml` con ese digest, `confirm_production=DEPLOY_OPTIMIA` y la misma versión. El workflow **reconstruye** la imagen; el digest a desplegar es el de producción, no el de staging.
5. Backup de Postgres. Migrar con la imagen nueva (`db:chatwoot_prepare`) antes de cambiar servicios. EasyPanel: el **mismo** digest de producción en `chatwoot` y `chatwoot-sidekiq`. No tocar `chatwoot-db` ni `chatwoot-redis`.
6. Verificar `/health`, login Super Admin, dashboard, accounts, users y `/super_admin/technical_health`.

## Documentación clave

- Technical Health Center: `docs/optimia/technical-health/`
- Staging: `docs/optimia/environments/`
- Guía EasyPanel staging: `docs/optimia/operations/easypanel-staging-setup-guide.md`
- Handoff: `docs/project/SPRINT-HANDOFF.md`
- Channel Manager RFC: `docs/optimia/architecture/channel-manager-rfc.md`
- Connection Center runbook: `docs/optimia/operations/staging-connection-center-runbook.md`
