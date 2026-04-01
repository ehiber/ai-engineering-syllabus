---
name: project-solution-file
description: Define and maintain a canonical solution file per project under .learn/solution and link it from the project's .learn/learn.json via a solution attribute. Use when creating or updating project solutions so students and LLMs can compare their work against a reference implementation.
---

# Project Solution File

## Purpose

Use this skill to ensure each project has one canonical reference solution under `.learn/solution/`, documented with a README, and linked from `.learn/learn.json` using `solution`.

This enables:

- Students to compare their submission against a clear reference.
- LLM-based evaluators to contrast submissions with a canonical solution.

## When to use

Use this skill whenever:

- You create a new evaluable project (milestones, guided projects, collaborative projects).
- You add or update a reference solution for an existing project.
- You audit whether a project has a valid solution link in `.learn/learn.json`.

## Required conventions

1. **Solution location**
   - Keep all reference solution files in `.learn/solution/` at project root.
   - Example: `content/projects/<project-slug>/.learn/solution/`

2. **Mandatory README**
   - Always include `.learn/solution/README.md` (or `README.html` only if explicitly needed).
   - The README is the canonical entry point and must explain:
     - Solution structure
     - Key implementation decisions
     - How solution files connect

3. **`learn.json` linkage**
   - Add/update `"solution"` in `.learn/learn.json`.
   - The value should be the repository URL of `.learn/solution/README.*`.
   - Use the repository's canonical pattern consistently.

4. **One canonical solution per project**
   - Avoid multiple competing reference implementations.
   - If there are auxiliary files, reference them from `.learn/solution/README.*`.

5. **Language**
   - Human-readable explanatory content inside the solution (README/comments/documentation) should be in English.

## Allowed solution formats

### 1) HTML/CSS/JS solution

Use when the deliverable is a web interface, layout, or page.

Requirements:

- Semantic HTML structure (`header`, `main`, `section`, `footer`, etc.) when applicable.
- Include evaluated requirements (for example, schema.org markup, accessibility metadata, headings hierarchy).
- Keep non-obvious comments only.

Recommended files in `.learn/solution/`:

- `README.md` (mandatory)
- `solution.html`
- `styles.css`
- `script.js`

### 2) Source-code solution (`.py`, `.js`, `.ts`, etc.)

Use when the deliverable is programming logic, scripts, modules, or backend code.

Requirements:

- Complete, readable implementation covering expected grading criteria.
- Reasonable validations/error handling where relevant.
- Optional helper utilities and concise usage examples.

Recommended files in `.learn/solution/`:

- `README.md` (mandatory)
- `solution.py` / `solution.ts` / `solution.js` (or split files like `main.ts`, `utils.ts`)

### 3) Explanatory solution (`.md`)

Use when there is no single valid implementation and the key is evaluating criteria/approach.

Should include:

- Expected visual/structural/code criteria.
- Recommended algorithms or design patterns.
- Small snippets for key points (not necessarily full implementation).

Recommended files in `.learn/solution/`:

- `README.md` (mandatory)
- Optional auxiliary examples

## Workflow (create/update)

1. **Identify project root**
   - Locate project folder under `content/projects/...`.

2. **Ensure `.learn/solution/` exists**
   - Create `.learn/` and `.learn/solution/` if missing.

3. **Choose format**
   - Always include `.learn/solution/README.md`.
   - Add implementation files matching the project requirements.

4. **Create/update solution files**
   - Keep all solution files inside `.learn/solution/`.
   - Ensure README matches actual implementation files.

5. **Link in `.learn/learn.json`**
   - Add/update `"solution"` with the README URL.
   - Ensure no duplicated conflicting `solution` entries.

6. **Consistency review**
   - Verify project README/context and solution are aligned.
   - Ensure no missing evaluated requirements in the reference solution.

## LLM and student usage guidance

- Students: use as comparison reference, not copy-paste output.
- LLM evaluators: treat solution as the golden reference for criteria coverage.

When evaluating:

1. Read project instructions/context and `.learn/learn.json`.
2. Read `.learn/solution/README.*` as the primary key.
3. Compare submission against required aspects from the reference solution.

## Quick checklist

- [ ] Project has `.learn/` and `.learn/learn.json`.
- [ ] Project has `.learn/solution/`.
- [ ] `.learn/solution/README.md` exists and is clear.
- [ ] All solution files are inside `.learn/solution/`.
- [ ] `.learn/learn.json` includes valid `"solution"` reference.
- [ ] Solution covers evaluated project requirements.
- [ ] Explanatory solution content is in English.
