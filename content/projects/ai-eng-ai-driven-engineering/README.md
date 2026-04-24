# Milestone 4 — AI-driven Engineering

<!-- hide -->

By [@4GeeksAcademy](https://github.com/4GeeksAcademy) and [other contributors](https://github.com/4GeeksAcademy/ai-engineering-company-project-monorepo/graphs/contributors) at [4Geeks Academy](https://4geeksacademy.com/)

[![build by developers](https://img.shields.io/badge/build_by-Developers-blue)](https://4geeks.com)
[![4Geeks Academy](https://img.shields.io/twitter/follow/4geeksacademy?style=social&logo=x)](https://x.com/4geeksacademy)

_Estas instrucciones tambien estan disponibles en [espanol](./README.es.md)._

<!-- endhide -->

**Before you start**: Read your assigned **[CONTEXT.md](https://github.com/4GeeksAcademy/ai-engineering-syllabus/tree/main/content/contexts)** before writing any code. It defines the specific company data, naming conventions, KPIs, business rules, and constraints for your implementation.

---

## 🎯 The Challenge

You have already built three pieces of your company case:

- the public website,
- the business logic in TypeScript,
- and the first AI-generated components.

What you still do not have is the system that connects those pieces and allows them to grow without becoming chaotic.

From this milestone onward, the monorepo stops being a collection of isolated exercises and becomes the technical core of your company. Future APIs, agents, internal tools, automations, and knowledge systems will all live here. Before adding more product code, you must first create the structure that makes that growth coherent, maintainable, and AI-ready.

Your tech lead has had a ticket sitting on the board for two weeks:

> **Subject: Monorepo AI Setup — we need this done this week**
>
> Hi,
>
> I've reviewed the state of the repo and we're accumulating code without any supporting structure. If I drop an agent on this right now it's going to make mistakes that will cost us triple the time to fix.
>
> I need the repository to have clear, persistent context before we keep adding features: what the company is, what we're building, and what the project rules are. That goes into the memory bank. The agent has to read it before touching anything, and it has to include both business context and technical context.
>
> I also want an `AGENTS.md` that defines how any agent operates in this repo and what workflow it must follow before making a commit. No agents writing code without going through the delivery process.
>
> For more specific rules we'll use the `.agents/` folder. Think about what conventions the agent needs to know to not break what we already have, and document them there with the correct scope.
>
> Finally, I want us to formalise at least one skill that captures a recurring task in our workflow, something the agent can execute consistently and that we can reuse in upcoming milestones. It needs explicit acceptance criteria: if it can't be verified, it doesn't count.
>
> As for the app, the corporate website needs to live in Next.js, not as a copy, but as an improved version with reusable components. Once the essentials are complete, you may optionally split sections into additional views. Also set up the `/internal-app` route with its own layout and a basic entry screen, because we start filling it in next milestone. Bring in the TypeScript script from the business logic module (Milestone 2) so we have something visible there.
>
> When you're done, open a PR and let me know.
>
> — [Your tech lead]

### 💡 Memory bank, rules, and skills: what they are and why they matter

A **memory bank** is a set of Markdown files that the coding agent reads before each session. It is not static documentation. It is the active context of the project: business description, architectural decisions made, active constraints, and the current state of development. Without it, every agent session starts from scratch and repeats the same mistakes.

That is why the memory bank must be updated whenever the project evolves: new decisions, architecture changes, completed features, or problems encountered. A memory bank that is not maintained stops being useful within days.

The expected structure for agent configuration in the monorepo is:

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

> ⚠️ **Attention:** Do not confuse `.agents/` with the `/agents` and `/skills` folders already present in the monorepo. `.agents/` is the configuration directory for coding agents (Cursor, Windsurf, Claude Code, etc.). The `/agents` and `/skills` folders are product-code spaces you will use in later milestones. One configures how the development agent works in this repository; the other contains company deliverables.

Before creating any new folder, review the `README.md` inside each monorepo folder. The template repository already explains what belongs in each space. Following those instructions prevents duplication and keeps a structure the agent can navigate without ambiguity.

**Development rules** (`AGENTS.md` and `.agents/rules/`) define the protocol the agent must follow: what to read at the start, what steps are mandatory before each commit, which conventions to respect, and when to stop and ask for confirmation.

An **agent skill** is a structured, reusable instruction. It is more concrete than a generic rule and must include a clear objective, defined inputs, expected output, and verifiable acceptance criteria. A good skill has one purpose and can be evaluated independently.

---

## 🌱 How to Start the Project

Read your assigned `CONTEXT.md` before doing anything else. The memory bank you build must describe your specific company scenario, not a generic fictional company.

1. Fork the template repository: [ai-engineering-company-project-monorepo](https://github.com/4GeeksAcademy/ai-engineering-company-project-monorepo)
2. Open your fork in **GitHub Codespaces** or clone it locally
3. Review the current monorepo structure before creating folders or files
4. Configure your coding agent with access to the full repository
5. Document the initial setup decisions in the memory bank **before** writing application code

---

## 💻 What You Need to Do

### Agent Infrastructure

- [ ] Create the `memory-bank/` folder at the root of the monorepo with at least the following files:
  - [ ] `projectbrief.md` — business description, project objectives, and the problem it solves
  - [ ] `techContext.md` — tech stack, architectural decisions already made, and technical constraints
  - [ ] `progress.md` — current state of development, completed work, and planned next steps
- [ ] Ensure those memory-bank files are specific to the company described in `CONTEXT.md`; generic template text will not be accepted
- [ ] Create the `AGENTS.md` file at the root of the monorepo defining:
  - [ ] which memory-bank files the agent must read at the start of each session
  - [ ] the mandatory workflow before each commit, with a minimum of 4 explicit ordered steps
  - [ ] the folders and files the agent **must not modify** without explicit developer confirmation
- [ ] Create the `.agents/` folder with at least one development rule documented with an explicit scope:
  - [ ] always active, or
  - [ ] file-pattern based, or
  - [ ] agent-requested
- [ ] Implement at least one **agent skill** for a recurring workflow task, with:
  - [ ] a single clearly defined objective
  - [ ] documented inputs
  - [ ] a documented procedure
  - [ ] explicit and verifiable acceptance criteria

⚠️ **IMPORTANT:** The memory bank, rules, and skill must be aligned with the data, processes, and constraints defined in your assigned `CONTEXT.md`. Infrastructure that ignores the company context will not be accepted.

### Next.js + TypeScript Application

- [ ] Create a new Next.js + TypeScript application inside the monorepo, following the template repository structure
- [ ] Place that application inside `apps/`
- [ ] Migrate and improve the corporate website from Milestone 1 as the home route (`/`):
  - [ ] all Milestone 1 sections are present and complete
  - [ ] the page is implemented with reusable React components and correct TypeScript typing
  - [ ] the visual identity remains consistent with Milestone 1
- [ ] Implement the `/internal-app` route inside the same Next.js application:
  - [ ] the route `/internal-app` is accessible
  - [ ] it has its own layout, separate from the public corporate website layout
  - [ ] it renders a basic entry screen or starter dashboard structure
- [ ] Integrate the TypeScript script from the business-logic module (Milestone 2) into `/internal-app`:
  - [ ] the code is imported from its original location in the monorepo
  - [ ] the logic is **not copied or rewritten** inside the Next.js app
  - [ ] the output of that business logic is visible in the interface, not only in the console
- [ ] Document how to run the app in development so it can be tested in Codespaces without ambiguity

### Optional Enhancements

- [ ] Optionally split sections of the corporate website into additional views **after** the required deliverables are complete

---

## ✅ What We Will Evaluate

- [ ] The memory bank contains both business context **and** technical context
- [ ] The memory-bank content is specific to the assigned company case, not generic boilerplate
- [ ] `AGENTS.md` specifies a workflow with at least 4 ordered steps before the commit
- [ ] The `.agents/` folder contains at least one rule with an explicit application scope
- [ ] The implemented skill has one objective, documented inputs, a defined procedure, and verifiable acceptance criteria
- [ ] The Next.js application starts without errors with `npm run dev`
- [ ] The `/` route renders the complete corporate website with reusable TypeScript components
- [ ] The `/internal-app` route exists, has its own layout, and renders without errors
- [ ] The TypeScript script from Milestone 2 is integrated in `/internal-app` and produces visible output on screen
- [ ] No business-logic code is duplicated; it is imported from its original location in the monorepo
- [ ] The project can be run in Codespaces following the documented instructions

---

## 📦 How to Submit

1. Make sure your working branch is named `milestone-4`
2. Run the delivery workflow defined in your `AGENTS.md` before the final commit
3. Open a Pull Request targeting the `main` branch of your fork
4. In the PR description include:
   - screenshot of the corporate website rendered in Next.js
   - screenshot of `/internal-app` with the Milestone 2 TypeScript logic visible on screen
   - direct link to your `AGENTS.md`
   - a short note explaining where the original Milestone 2 business-logic module is being imported from
5. Submit the link to your PR on the 4Geeks campus

---

This and many other projects are built by students as part of the [Coding Bootcamps](https://4geeksacademy.com/) at 4Geeks Academy. By [@4GeeksAcademy](https://github.com/4GeeksAcademy) and [other contributors](https://github.com/4GeeksAcademy/ai-engineering-company-project-monorepo/graphs/contributors). Find out more about [Full-Stack Software Developer](https://4geeksacademy.com/en/career-programs/full-stack), [Data Science & Machine Learning](https://4geeksacademy.com/en/career-programs/data-science-ml), [Cybersecurity](https://4geeksacademy.com/en/career-programs/cybersecurity) and [AI Engineering](https://4geeksacademy.com/en/career-programs/ai-engineering).
