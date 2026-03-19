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

## View specifications (aligned with project brief)

The following view-level specs can be used as reference requirements when validating the solution.

### 1) Dashboard

- Show exactly 4 metric cards in a responsive grid: total revenue, discount/coupon losses, active agents, and failing agents; each card includes icon, label, and hardcoded value.
- Render a full-width weekly activity chart placeholder below the cards with clear visual separation from KPI content.
- Keep layout consistent in light/dark mode, with readable contrast for card labels, values, and icons.

### 2) User Management

- Display a table with at least 5 users and columns for name, email, plan, and status badge.
- Provide a `⋮` action dropdown per row with at least "View detail" and "Delete" actions.
- Open a modal with full user details when "View detail" is selected; modal must close via close button and backdrop click.

### 3) Agent Management

- List at least 4 agents with name, owner, status badge, and a skill list collapsed by default.
- Include an expand/collapse control to reveal skills with a visible smooth transition.
- Provide a row action dropdown with "Configure" and "Delete"; "Configure" opens a modal containing the agent system prompt in an editable `textarea`.

### 4) Skills (Catalog)

- Show at least 4 skills, each with name, short description, and enabled-agents count.
- Include an in-view explanatory text that defines what a "skill" means in the AgentHub platform context.
- Provide a `⋮` action dropdown per skill with "View detail" and "Delete".

### 5) Agent Contracts

- Display a contracts table with at least 4 entries including client, rented agent, contracted skills, start/end dates, and total paid amount.
- Include a row `⋮` action dropdown with a "View detail" action.
- Show a detail modal with full contract breakdown and itemized skill pricing.

### 6) Error Log

- Render at least 6 error entries with timestamp, agent name, error type badge, and short description.
- Use color-coded badges to distinguish error types or severities.
- Include a `⋮` dropdown per entry with "View detail" (opens modal with trace details) and "Mark as resolved".
