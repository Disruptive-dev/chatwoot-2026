# SPRINT-HANDOFF — OptimiA

> Registro append-only de handoffs entre sprints y sesiones.  
> No borrar entradas anteriores.

---

## Sprint 0 — Trazabilidad y baseline

| Campo | Valor |
|-------|-------|
| **Sprint** | Sprint 0 — Trazabilidad y baseline |
| **Entorno** | Cursor Online |
| **Rama** | `develop` |
| **Commit inicial** | `462802c9e` |
| **Commit documentación** | `5ab2bb5e4` |
| **Commit continuidad** | Ver `git log` tras cierre Sprint 0 |
| **Deploy** | No |
| **Producción modificada** | No |
| **Push Sprint 0 docs** | Pendiente al inicio del cierre Sprint 0 → completado en cierre |
| **Fecha cierre** | 2026-07-23 |

### Entregables

- 19 archivos en `docs/optimia/` (arquitectura, operaciones, seguridad, inventario, ADRs, upgrades).
- Remote `upstream` configurado: `https://github.com/chatwoot/chatwoot.git`.
- Baseline fork identificado: `6a7cbcf5` (`package.json` 4.10.1, padre de `ac4ec0fbe`).
- Tag local creado: `chatwoot-base/v4.10.1` → `6a7cbcf5`.
- Protocolo de continuidad cross-session (AGENTS.md, `.cursor/rules/`, `docs/project/`, `scripts/project-context.sh`).
- Checklist manual EasyPanel: `docs/optimia/operations/easypanel-production-checklist.md`.

### Controles ejecutados

| Control | Resultado |
|---------|-----------|
| Validación commit `5ab2bb5e4` (solo docs) | ✅ |
| YAML workflows (16 archivos) | ✅ |
| `pnpm audit` | ⚠️ 129 vulnerabilidades |
| `bundle audit` | ⏳ Pendiente |
| `gitleaks` | ⏳ Pendiente |
| Tests Spectra (RSpec) | ⏳ Ruby no disponible en entorno |
| Tests internalCommands (Vitest) | ⏳ node_modules ausente |
| Docker build | ⏳ No ejecutado |
| Búsqueda secretos en repo | ✅ No detectados |

### Riesgos identificados

| # | Riesgo | Severidad |
|---|--------|-----------|
| 1 | Trazabilidad EasyPanel no verificada | Alta |
| 2 | Worker Sidekiq posiblemente ausente en prod | Alta |
| 3 | Dockerfile raíz solo web (sin Sidekiq) | Alta |
| 4 | 713 commits detrás de upstream | Media |
| 5 | 129 vulnerabilidades JS (`pnpm audit`) | Media |
| 6 | Repo en cuenta personal | Media |

### Pendiente

- [ ] Usuario completa checklist EasyPanel.
- [ ] Aprobación ADR-001, ADR-002, ADR-003 por propietario.
- [ ] `bundle audit` y `gitleaks` en CI.
- [ ] Verificar worker en producción.

### Próximo paso exacto

1. Usuario abre EasyPanel y completa `easypanel-production-checklist.md` (solo lectura, sin modificar nada).
2. Usuario envía datos recopilados (sin secretos) + capturas indicadas.
3. **No iniciar Sprint 1 técnico** hasta recibir esa información.
4. Sprint 1 (cuando autorizado): inventario real EasyPanel, backup prod, aprobación ADRs.

---

## Sprint 1 — Preparación staging aislado

| Campo | Valor |
|-------|-------|
| **Sprint** | Sprint 1 — Preparación staging aislado |
| **Entorno** | Cursor Online |
| **Rama** | `develop` |
| **Commit base** | `86d316283` |
| **Deploy** | No |
| **Producción modificada** | No |
| **EasyPanel modificado** | No |
| **Push** | Pendiente aprobación |

### Contexto producción verificado (input usuario)

- Imagen: `ghcr.io/disruptive-dev/chatwoot:v4.10.1-optimia.6`
- Servicios: `chatwoot`, `chatwoot-sidekiq`, `chatwoot-db`, `chatwoot-redis`
- Web y worker: misma imagen; Sidekiq operativo
- Prod con clientes reales — **no tocar**

### Entregables Sprint 1 (preparación, sin deploy)

- `docs/optimia/environments/` — arquitectura, imágenes, variables, web/worker, aislamiento
- `docs/optimia/operations/easypanel-staging-setup-guide.md` — guía manual paso a paso
- `.github/workflows/build-optimia-chatwoot-staging.yml` — build staging solo manual
- Actualización `PROJECT-STATUS.md`, `DECISIONS.md`, `CHANGELOG.md`

### Controles

| Control | Resultado |
|---------|-----------|
| Workflow prod sin modificar | ✅ |
| Tag prod `v4.10.1-optimia.6` sin modificar | ✅ |
| Sin conexión a EasyPanel prod | ✅ |
| YAML workflow staging válido | ✅ |
| Documentación sin secretos | ✅ |

### Próximo paso exacto

1. Push commit Sprint 1 (si aprobado).
2. GitHub Actions → Run workflow → `Build Optimia Chatwoot Staging Image`.
3. Operador: crear proyecto staging en EasyPanel (guía manual).
4. Smoke tests staging.
5. **No** promover a prod hasta validación completa.

---

## Sprint 2 — Channel Manager Foundation + WhatsApp Connection Center

| Campo | Valor |
|-------|-------|
| **Sprint** | Sprint 2 — Channel Manager + Connection Center |
| **Entorno** | Cursor Cloud Agent |
| **Rama** | `develop` (sin rama paralela) |
| **Deploy** | No |
| **Producción modificada** | No |

### Entregables

- Modelo `OptimiaChannelConnection` + auditoría + máquina de estados
- Provider Registry + Evolution Adapter (`lib/integrations/evolution/`, `lib/integrations/optimia/channel_manager/`)
- API `optimia/whatsapp/connections` (CRUD parcial + QR + status + reconnect + disconnect)
- UI `Configuración → WhatsApp` (listado, wizard, QR, polling)
- Provisioning idempotente de inbox Chatwoot (`Channel::Api`)
- Feature flag `optimia_channel_manager`
- RFC, ADR-004, seguridad, runbook staging
- Specs RSpec (modelo, servicio, request)

### Variables ENV nuevas

- `EVOLUTION_API_URL`, `EVOLUTION_API_KEY`
- `OPTIMIA_CHATWOOT_PUBLIC_URL`, `OPTIMIA_EVOLUTION_CHATWOOT_API_TOKEN`
- `OPTIMIA_CHANNEL_MANAGER_ENABLED`, `EVOLUTION_PAIRING_CODE_SUPPORTED`

### Próximo paso exacto

1. Push `develop` y build imagen staging.
2. Configurar ENV Evolution en staging.
3. Smoke tests según `staging-connection-center-runbook.md`.

---

## Sprint 3 — Technical Health Center v0.2.0

| Campo | Valor |
|-------|-------|
| **Sprint** | Sprint 3 — Technical Health Center |
| **Entorno** | Cursor Cloud Agent |
| **Rama** | `cursor/technical-health-center-3da0` |
| **Versión OptimiA** | 0.2.0 |
| **Deploy** | No |
| **Producción modificada** | No |

### Entregables

- NOC Dashboard con 12 componentes monitoreados (`Orchestrator` + checkers).
- Alert Detector (11 reglas) + gestión de alertas e incidentes.
- Diagnostic Center (score 0–100) por plataforma y por conexión WhatsApp.
- Connection Monitor + Timeline Builder integrado con Channel Manager.
- Deployment Center + modelo `OptimiaDeploymentRecord`.
- API interna `/internal/health/*` con autenticación por token.
- UI Super Admin `/super_admin/technical_health`.
- Job `Optimia::TechnicalHealth::CollectHealthJob` (cron `*/5 * * * *`).
- Migración `20260724160000_create_optimia_technical_health_tables` (6 tablas).
- Documentación `docs/optimia/technical-health/` (README, audit, risk-matrix, runbooks, executive-summary).
- Specs RSpec (orchestrator, alert detector, diagnostic, controllers, job).

### Modelos nuevos

- `OptimiaTechnicalHealthCheck`, `OptimiaTechnicalAlert`, `OptimiaTechnicalIncident`
- `OptimiaTechnicalTimelineEvent`, `OptimiaTechnicalMetricSnapshot`, `OptimiaDeploymentRecord`

### Variables ENV nuevas

- `OPTIMIA_INTERNAL_HEALTH_TOKEN`
- `OPTIMIA_DEPLOY_VERSION`, `OPTIMIA_DEPLOY_COMMIT_SHA`, `OPTIMIA_DEPLOY_IMAGE_DIGEST`, `OPTIMIA_DEPLOY_IMAGE_TAG`
- `OPTIMIA_SWARM_SERVICE`, `OPTIMIA_NODE_ROLE`

### Controles

| Control | Resultado |
|---------|-----------|
| Producción sin modificar | ✅ |
| Deploy no ejecutado | ✅ |
| Documentación en español | ✅ |
| Sanitización payloads sensibles | ✅ |
| Specs RSpec añadidos | ✅ |

### Próximo paso exacto

1. Merge a `develop` y build imagen staging `staging-cw-4.10.1-optimia-0.2.0`.
2. Ejecutar migración BD en staging.
3. Configurar `OPTIMIA_INTERNAL_HEALTH_TOKEN` y ENV deploy en EasyPanel staging.
4. Smoke tests según `docs/optimia/technical-health/runbooks.md`.
5. QA staging completo antes de planificar prod.

---

## Sprint v0.2.1 — CI/CD Platform Cleanup

| Campo | Valor |
|-------|-------|
| **Sprint** | v0.2.1 — CI/CD Platform Cleanup |
| **Entorno** | Cursor Cloud Agent |
| **Rama** | `cursor/optimia-cicd-cleanup-ce69` |
| **Commit base** | `1f224c885` (develop) |
| **Deploy** | No |
| **Producción modificada** | No |
| **EasyPanel modificado** | No |
| **Imagen producción publicada** | No |
| **Staging desplegado** | No |

### Causa raíz

- Workflow prod (`build-optimia-chatwoot.yml`) publicaba en `ghcr.io/disruptive-dev/chatwoot` sin permisos.
- Push automático a `develop` disparaba builds prod + upstream Docker Hub.
- 17 workflows activos con duplicación CI y colas de runners.
- Registries fragmentados: `disruptive-dev`, `pablo-paez-dev`, `dsw-factory` (doc).

### Entregables

- Auditoría 17 workflows → `docs/optimia/cicd/spec.md`
- ADR CI/CD 001–004 → `docs/optimia/cicd/decisions.md`
- `optimia-ci.yml`, `optimia-build-staging.yml`, `optimia-build-production.yml`
- Guards upstream en 11 workflows
- Legacy `build-optimia-chatwoot*.yml` deprecados
- Scripts `scripts/optimia/*.sh`
- Documentación runbooks y migración registry

### Registry elegido

| Rol | Valor |
|-----|-------|
| Objetivo | `ghcr.io/dsw-factory/optimia-chatwoot` |
| Fallback activo | `ghcr.io/pablo-paez-dev/chatwoot` |
| Bloqueo | GHCR cross-org sin `GHCR_TOKEN` |

### Controles

| Control | Resultado |
|---------|-----------|
| Producción sin modificar | ✅ |
| EasyPanel sin tocar | ✅ |
| Sin publish prod | ✅ |
| Sin deploy staging | ✅ |
| `validate-cicd.sh` | Ver commit |
| disruptive-dev eliminado de workflows activos | ✅ |

### Próximo paso exacto

1. Merge PR → `develop`.
2. Configurar variables GitHub + environment `production`.
3. Autorizar `optimia-build-staging` tag `staging-cw-4.10.1-optimia-0.2.0`.
4. Deploy staging EasyPanel por digest (humano).
5. Smoke tests → aprobar build producción.

---

<!-- Próximas entradas se agregan debajo, sin modificar las anteriores -->

---

## Hotfix — Super Admin 500 (navegación Technical Health)

| Campo | Valor |
|-------|-------|
| **Fecha** | 2026-11-18 |
| **Rama** | `develop` en `4cfeee9ff` (fast-forward desde `cursor/superadmin-nav-500-437b`) |
| **Commit original** | `c2af646b8` — Pablo Paez - Dev Teams. Cherry-pick: `07747ebd7` |
| **Deploy** | No. El merge no publica imagen ni toca EasyPanel. |
| **Producción modificada** | No |

### Causa

`develop` incluye `resource :technical_health, only: [:show]`. El sidebar de Administrate llama `resource_index_route` para ese recurso. No hay acción `index`, así que cualquier pantalla autenticada de Super Admin renderiza `public/500.html`. La ruta ya responde en `https://app.optimia.spectra-metrics.com` (302 a login). En la imagen documentada `v4.10.1-optimia.6` esa ruta no existía y la consola funcionaba.

### Próximo paso exacto

1. Build de imagen (staging, luego producción con digest validado). El workflow `optimia-build-production.yml` es manual, exige digest de staging y no despliega solo.
2. EasyPanel: mismo digest en `chatwoot` y `chatwoot-sidekiq`. No cambiar Postgres, Redis ni variables.

---

## CI verde — antes del hotfix Super Admin

| Campo | Valor |
|-------|-------|
| **Fecha** | 2026-11-20 |
| **Rama** | `cursor/optimia-ci-green-75b5` |
| **Base** | `develop` @ `dbecec644` |
| **Deploy** | No |
| **Producción modificada** | No |
| **EasyPanel modificado** | No |

### Causas y arreglo

- Zeitwerk abortaba con `ActiveRecord::ConnectionNotEstablished` porque eager load abre Postgres y el job no tenía servicio. Se añade Postgres y `db:create`. Redis de test es `MockRedis`.
- RuboCop: ofensas de estilo y métricas ya presentes en Channel Manager, Spectra y Technical Health. Autocorrect solo de Layout. El resto en `.rubocop_todo.yml`.
- ESLint: Prettier en los Vue/JS de WhatsApp, `commit` sin uso en `diagnose` y `:src` con literal en `Branding.vue`.
- RSpec: `en.yml` ya usa la marca OptimIA y los specs seguían el texto anterior. Spectra `health_check` llamaba el sanitizador de clase como si fuera de instancia. El acceso a otra cuenta en documentos Spectra responde 401 por `Pundit::NotAuthorizedError`, no 404.

No se marcó ningún ejemplo como pendiente. No hubo deploy.

### Próximo paso exacto

1. Merge de este PR a `develop`. No mergear el hotfix de Super Admin antes.
2. Dejar el PR del Super Admin encima de esta rama.
3. Con ambos CI verdes, mergear el hotfix y publicar `staging-cw-4.10.1-optimia-0.2.4`.

---

## Hotfix — Super Admin 500 (recurso sin ruta index)

| Campo | Valor |
|-------|-------|
| **Fecha** | 2026-11-20 |
| **Rama** | `cursor/superadmin-nav-index-guard-75b5` |
| **Base** | `cursor/optimia-ci-green-75b5` |
| **Deploy** | No |
| **Producción modificada** | No |
| **Imagen publicada** | No |

### Causa raíz

`Administrate::Namespace#resources` enumera cada controlador bajo `super_admin`, no solo los que tienen `index`. `resource :technical_health, only: [:show], controller: 'technical_health'` no define `index`. El sidebar llama `resource_index_route`, que hace `url_for(action: "index", controller: "/super_admin/technical_health")` y lanza `ActionView::Template::Error (No route matches ...)`. El layout envuelve todas las pantallas autenticadas, así que `/super_admin/users` y el resto responden 500. No es un rechazo de autorización: sin sesión, Devise redirige al login antes de renderizar el sidebar.

La imagen en producción `ghcr.io/disruptive-dev/chatwoot:staging-cw-4.10.1-optimia-0.2.3` corresponde al tag git `staging-cw-4.10.1-optimia-0.2.3` → `6a1ffc3d5`. Ese commit no excluye `technical_health` y el stack trace de producción coincide con `_navigation.html.erb` de ese tag (línea 35 sin `technical_health`, línea 38 `resource_index_route`). El commit posterior `07747ebd7` solo añadió el nombre a una lista fija; no está en la imagen 0.2.3 y no cubre otro controlador sin `index`.

Technical Health es una pantalla intencional (show, refresh, diagnose, timeline). No se convierte en recurso Administrate con `index` ni en dashboard: no existe `TechnicalHealthDashboard`, y `display_resource_name` lo cargaría.

### Corrección

- `SuperAdmin::NavigationHelper#super_admin_primary_nav_resources` solo enlaza recursos que están en `resources_with_index_route` y fuera de la lista histórica (incluye `technical_health`).
- El enlace "Technical Health" sigue usando `super_admin_technical_health_path`.
- `authenticate_super_admin!` no cambia.

### Prueba

`spec/controllers/super_admin/navigation_spec.rb`

Antes del filtro, con un controlador extra sin `index` (`nav_probe`):

`expected 200 but was 500` y en `log/test.log`: `No route matches {action: "index", controller: "super_admin/nav_probe"}`.

Después: 13 ejemplos, 0 fallos (`navigation_spec`, `technical_health_controller_spec`, `users_controller_spec`). RuboCop limpio en los archivos Ruby tocados.

### Cómo se publica la imagen

| Workflow | Disparo | Tag GHCR |
|----------|---------|----------|
| `.github/workflows/optimia-build-staging.yml` | Push de tag `staging-cw-*` o `workflow_dispatch` | `staging-cw-{chatwoot}-optimia-{optimia}` |
| `.github/workflows/optimia-build-production.yml` | Solo manual, environment `production`, digest de staging, `confirm_production=DEPLOY_OPTIMIA` | `cw-{chatwoot}-optimia-{optimia}` |

Registry por defecto en ambos workflows: `ghcr.io/disruptive-dev/chatwoot` (lo sustituye `vars.OPTIMIA_GHCR_REGISTRY` o el input `registry`). El build de `0.2.3` fue el run [31508160919](https://github.com/Disruptive-dev/chatwoot-2026/actions/runs/31508160919) al pushear el tag `staging-cw-4.10.1-optimia-0.2.3` sobre `6a1ffc3d5`. Ningún workflow despliega EasyPanel.

Producción hoy usa el tag con prefijo `staging-` aunque no haya entorno staging. El tag de producción del otro workflow (`cw-4.10.1-optimia-0.2.4`) no es el que EasyPanel tiene puesto. No se cambia ese esquema.

### Próximo paso exacto

1. Merge del PR a `develop`. No merge automático desde este agente.
2. Desde `develop` ya mergeado: `git tag staging-cw-4.10.1-optimia-0.2.4 && git push origin staging-cw-4.10.1-optimia-0.2.4`. Alternativa: Actions → OptimiA Build Staging → `optimia_version=0.2.4`, `chatwoot_version=4.10.1`, `dry_run=false`.
3. Copiar imagen y digest del job summary. Esperado si no hay override: `ghcr.io/disruptive-dev/chatwoot:staging-cw-4.10.1-optimia-0.2.4`.
4. EasyPanel, proyecto `optimia`: actualizar **chatwoot** y **chatwoot-sidekiq** a ese tag o, mejor, al digest. No tocar `chatwoot-db`, `chatwoot-redis` ni variables. Este hotfix no trae migración.
5. Smoke con super admin: `/super_admin/users` y `/super_admin/technical_health` responden 200 y el menú muestra Technical Health. Sin sesión, `/super_admin/users` redirige al login.
6. Rollback: volver ambos servicios al digest actual de `staging-cw-4.10.1-optimia-0.2.3`. No sobrescribir ese tag.
