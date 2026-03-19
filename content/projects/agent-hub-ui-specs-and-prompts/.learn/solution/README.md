# AI Agent Rental Platform - Reference solution

This README documents the reference implementation for the **"AI Agent Rental Platform - Admin Panel Prototype"** project.

## Solution structure

The reference solution is implemented as multiple HTML views, plus shared JavaScript and styles:

- `dashboard.html`
- `user_management.html`
- `agent_management.html`
- `skills_catalog.html`
- `agent_contracts.html`
- `error_log.html`
- `js/agenthub-ui.js`
- `styles/custom-styles.css`

## What this reference implementation demonstrates

- A persistent admin layout pattern across all views (sidebar + top bar).
- Hardcoded business data in all required sections.
- Working interaction patterns implemented with vanilla JavaScript:
  - row action dropdowns (`⋮`)
  - detail/configuration modals
  - collapsible skill lists in agent rows
  - global dark/light mode toggle
- Semantic HTML usage for tables, sections, navigation, and main content regions.

## Expected behavior checklist

Use this checklist when comparing student submissions against the reference:

- [ ] All 6 required sections exist and are accessible.
- [ ] Each data row/card group exposes the required fields from the brief.
- [ ] Action dropdowns open and close correctly (including outside click behavior).
- [ ] "View detail" (or "Configure") actions open modals with section-specific information.
- [ ] Modals close through the close button and backdrop click.
- [ ] Agent skill lists are collapsed by default and expand/collapse on demand.
- [ ] Dark/light mode updates the whole UI and persists while moving between views.
- [ ] Hardcoded entities are consistent across sections (agents, contracts, and errors match).

## Reviewer notes

- The core of this project is **spec-driven frontend implementation** and interaction quality, not backend integration.
- Visual polish can vary, but required UI behaviors must work reliably.
