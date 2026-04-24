# Milestone 4 — Ingeniería impulsada por IA

<!-- hide -->

Por [@4GeeksAcademy](https://github.com/4GeeksAcademy) y [otros colaboradores](https://github.com/4GeeksAcademy/ai-engineering-company-project-monorepo/graphs/contributors) en [4Geeks Academy](https://4geeksacademy.com/)

[![build by developers](https://img.shields.io/badge/build_by-Developers-blue)](https://4geeks.com)
[![4Geeks Academy](https://img.shields.io/twitter/follow/4geeksacademy?style=social&logo=x)](https://x.com/4geeksacademy)

_These instructions are also available in [English](./README.md)._

<!-- endhide -->

**Antes de empezar**: Lee tu **[CONTEXT.md](https://github.com/4GeeksAcademy/ai-engineering-syllabus/tree/main/content/contexts)** asignado antes de escribir código. Ese archivo define los datos específicos de la empresa, las convenciones de nomenclatura, los KPIs, las reglas de negocio y las restricciones para tu implementación.

---

## 🎯 El desafío

Ya construiste tres piezas de tu caso de empresa:

- la web pública,
- la lógica de negocio en TypeScript,
- y los primeros componentes generados con IA.

Lo que todavía no tienes es el sistema que conecta esas piezas y permite que crezcan sin volverse caóticas.

A partir de este hito, el monorepo deja de ser una colección de ejercicios aislados y se convierte en el núcleo técnico de tu empresa. Las próximas APIs, agentes, herramientas internas, automatizaciones y sistemas de conocimiento vivirán aquí. Antes de añadir más código de producto, primero debes crear la estructura que hará posible ese crecimiento de forma coherente, mantenible y AI-ready.

Tu tech lead ha tenido una tarea bloqueada en el tablero durante dos semanas:

> **Asunto: Monorepo AI Setup — necesitamos esto esta semana**
>
> Hola,
>
> He revisado el estado del repo y veo que estamos acumulando código sin estructura de soporte. Si meto un agente sobre esto ahora mismo va a cometer errores que nos van a costar el triple de tiempo.
>
> Necesito que el repositorio tenga un contexto claro y persistente antes de que sigamos añadiendo features: qué es la empresa, qué estamos construyendo y cuáles son las reglas del proyecto. Eso va al banco de memoria. El agente tiene que leerlo antes de tocar nada, y tiene que incluir tanto contexto de negocio como contexto técnico.
>
> También quiero un `AGENTS.md` que defina cómo opera cualquier agente en este repo y qué flujo debe seguir antes de hacer un commit. Nada de agentes escribiendo código sin pasar por el proceso de entrega.
>
> Para las reglas más específicas usaremos la carpeta `.agents/`. Piensa en qué convenciones necesita conocer el agente para no romper lo que ya tenemos, y documéntalas ahí con el alcance correcto.
>
> Por último, quiero que formalicemos al menos una skill que capture una tarea recurrente de nuestro flujo de trabajo, algo que el agente pueda ejecutar de forma consistente y que podamos reutilizar en próximos hitos. Tiene que tener criterios de aceptación explícitos: si no se puede verificar, no vale.
>
> En cuanto a la app, la web corporativa tiene que vivir en Next.js, no como copia, sino como una versión mejorada con componentes reutilizables. Una vez que lo esencial esté listo, puedes separar secciones en vistas adicionales de forma opcional. Además, deja preparada la ruta `/internal-app` con su propio layout y una pantalla de entrada básica, porque empezaremos a llenarla en el próximo hito. Integra ahí el script de TypeScript del módulo de lógica de negocio (Hito 2) para que haya algo visible.
>
> Cuando termines, abre una PR y avísame.
>
> — [Tu tech lead]

### 💡 Banco de memoria, reglas y skills: qué son y por qué importan

Un **banco de memoria** es un conjunto de archivos Markdown que el agente de programación lee antes de cada sesión. No es documentación estática. Es el contexto activo del proyecto: descripción del negocio, decisiones de arquitectura tomadas, restricciones en vigor y estado actual del desarrollo. Sin él, cada sesión del agente empieza desde cero y repite los mismos errores.

Por eso el banco de memoria debe actualizarse cada vez que el proyecto evoluciona: nuevas decisiones, cambios de arquitectura, funcionalidades completadas o problemas encontrados. Un banco de memoria que no se mantiene al día deja de ser útil en cuestión de días.

La estructura esperada para la configuración de agentes en el monorepo es:

```text
./.agents
└─ /rules
   └─ <rule-name>.md
└─ /skills
   └─ /<skill>
      └─ SKILL.md
./memory-bank
└─ <context>.md
```

> ⚠️ **Atención:** No confundas `.agents/` con las carpetas `/agents` y `/skills` que ya existen en el monorepo. `.agents/` es el directorio de configuración para agentes de código (Cursor, Windsurf, Claude Code, etc.). Las carpetas `/agents` y `/skills` son espacios de código de producto que usarás en hitos posteriores. Una cosa configura cómo trabaja el agente de desarrollo en este repositorio; la otra contiene entregables de la empresa.

Antes de crear una carpeta nueva, revisa el `README.md` dentro de cada carpeta del monorepo. El repositorio de plantilla ya explica qué debe vivir en cada espacio. Seguir esas instrucciones evita duplicidades y mantiene una estructura que el agente puede navegar sin ambigüedad.

Las **reglas de desarrollo** (`AGENTS.md` y `.agents/rules/`) definen el protocolo que debe seguir el agente: qué leer al iniciar, qué pasos son obligatorios antes de cada commit, qué convenciones respetar y cuándo detenerse para pedir confirmación.

Una **skill de agente** es una instrucción estructurada y reutilizable. Es más concreta que una regla genérica y debe incluir un objetivo claro, inputs definidos, output esperado y criterios de aceptación verificables. Una buena skill tiene un solo propósito y puede evaluarse de forma independiente.

---

## 🌱 Cómo iniciar el proyecto

Lee tu `CONTEXT.md` asignado antes de hacer cualquier otra cosa. El banco de memoria que construyas debe describir el escenario específico de tu empresa, no una empresa ficticia genérica.

1. Haz fork del repositorio de plantilla: [ai-engineering-company-project-monorepo](https://github.com/4GeeksAcademy/ai-engineering-company-project-monorepo)
2. Ábrelo en **GitHub Codespaces** o clónalo localmente
3. Revisa la estructura actual del monorepo antes de crear carpetas o archivos
4. Configura tu agente de programación con acceso al repositorio completo
5. Documenta las decisiones iniciales de setup en el banco de memoria **antes** de escribir código de aplicación

---

## 💻 Lo que debes hacer

### Infraestructura de agentes

- [ ] Crea la carpeta `memory-bank/` en la raíz del monorepo con al menos los siguientes archivos:
  - [ ] `projectbrief.md` — descripción del negocio, objetivos del proyecto y problema que resuelve
  - [ ] `techContext.md` — stack tecnológico, decisiones de arquitectura ya tomadas y restricciones técnicas
  - [ ] `progress.md` — estado actual del desarrollo, trabajo completado y próximos pasos previstos
- [ ] Asegúrate de que esos archivos del memory bank sean específicos de la empresa descrita en `CONTEXT.md`; no se aceptará texto genérico del template
- [ ] Crea el archivo `AGENTS.md` en la raíz del monorepo definiendo:
  - [ ] qué archivos del memory bank debe leer el agente al inicio de cada sesión
  - [ ] el flujo obligatorio antes de cada commit, con un mínimo de 4 pasos explícitos y ordenados
  - [ ] las carpetas y archivos que el agente **no debe modificar** sin confirmación explícita del desarrollador
- [ ] Crea la carpeta `.agents/` con al menos una regla de desarrollo documentada con alcance explícito:
  - [ ] siempre activa, o
  - [ ] basada en patrón de archivos, o
  - [ ] activada a petición del agente
- [ ] Implementa al menos una **skill de agente** para una tarea recurrente del flujo de trabajo, con:
  - [ ] un único objetivo claramente definido
  - [ ] inputs documentados
  - [ ] un procedimiento documentado
  - [ ] criterios de aceptación explícitos y verificables

⚠️ **IMPORTANTE:** El banco de memoria, las reglas y la skill deben estar alineados con los datos, procesos y restricciones definidos en tu `CONTEXT.md` asignado. No se aceptará una infraestructura que ignore el contexto de la empresa.

### Aplicación Next.js + TypeScript

- [ ] Crea una nueva aplicación Next.js + TypeScript dentro del monorepo, siguiendo la estructura del repositorio de plantilla
- [ ] Ubica esa aplicación dentro de `apps/`
- [ ] Migra y mejora la web corporativa del Hito 1 como ruta de inicio (`/`):
  - [ ] todas las secciones del Hito 1 están presentes y completas
  - [ ] la página está implementada con componentes React reutilizables y tipado TypeScript correcto
  - [ ] la identidad visual se mantiene consistente con la del Hito 1
- [ ] Implementa la ruta `/internal-app` dentro de la misma aplicación Next.js:
  - [ ] la ruta `/internal-app` es accesible
  - [ ] tiene su propio layout, separado del layout público de la web corporativa
  - [ ] renderiza una pantalla de entrada básica o una estructura inicial de dashboard
- [ ] Integra el script de TypeScript del módulo de lógica de negocio (Hito 2) dentro de `/internal-app`:
  - [ ] el código se importa desde su ubicación original en el monorepo
  - [ ] la lógica **no se copia ni se reescribe** dentro de la app Next.js
  - [ ] el resultado de esa lógica es visible en la interfaz, no solo en la consola
- [ ] Documenta cómo ejecutar la app en desarrollo para que pueda probarse en Codespaces sin ambigüedad

### Mejoras opcionales

- [ ] Opcionalmente, separa secciones de la web corporativa en vistas adicionales **después** de completar los entregables obligatorios

---

## ✅ Lo que evaluaremos

- [ ] El banco de memoria contiene contexto de negocio **y** contexto técnico
- [ ] El contenido del memory bank es específico del caso de empresa asignado, no boilerplate genérico
- [ ] `AGENTS.md` especifica un flujo con al menos 4 pasos ordenados antes del commit
- [ ] La carpeta `.agents/` contiene al menos una regla con alcance de aplicación explícito
- [ ] La skill implementada tiene un solo objetivo, inputs documentados, procedimiento definido y criterios de aceptación verificables
- [ ] La aplicación Next.js arranca sin errores con `npm run dev`
- [ ] La ruta `/` renderiza la web corporativa completa con componentes TypeScript reutilizables
- [ ] La ruta `/internal-app` existe, tiene layout propio y renderiza sin errores
- [ ] El script de TypeScript del Hito 2 está integrado en `/internal-app` y produce output visible en pantalla
- [ ] No hay código de lógica de negocio duplicado; se importa desde su ubicación original en el monorepo
- [ ] El proyecto puede ejecutarse en Codespaces siguiendo las instrucciones documentadas

---

## 📦 Cómo entregar

1. Asegúrate de que tu rama de trabajo se llama `milestone-4`
2. Ejecuta el flujo de entrega definido en tu `AGENTS.md` antes del commit final
3. Abre una Pull Request hacia la rama `main` de tu fork
4. En la descripción de la PR incluye:
   - captura de pantalla de la web corporativa renderizada en Next.js
   - captura de pantalla de `/internal-app` con la lógica TypeScript del Hito 2 visible en pantalla
   - enlace directo a tu `AGENTS.md`
   - una nota breve explicando desde qué módulo original se está importando la lógica del Hito 2
5. Entrega el enlace a tu PR en el campus de 4Geeks

---

Este y muchos otros proyectos son construidos por estudiantes como parte de los [Coding Bootcamps](https://4geeksacademy.com/) de 4Geeks Academy. Encuentra más acerca de [Full-Stack Software Developer](https://4geeksacademy.com/es/programas-de-carrera/desarrollo-full-stack), [Data Science & Machine Learning](https://4geeksacademy.com/es/programas-de-carrera/ciencia-de-datos-ml), [Cybersecurity](https://4geeksacademy.com/es/programas-de-carrera/ciberseguridad) e [AI Engineering](https://4geeksacademy.com/es/programas-de-carrera/ingenieria-ia).
