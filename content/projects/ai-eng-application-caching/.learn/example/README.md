# Neighbourhood Library — Caching Mini-Lab (Class Example)

> **For instructors:** Parallel classroom scenario for `ai-eng-application-caching`. Same spine (lazy load, `useMemo`, FastAPI TTL cache + invalidation, short report), different domain. Students still follow the full monorepo brief in the project root `README.md`.

_Estas instrucciones también están disponibles en [español](./README.es.md)._

---

## The challenge

**Maple Street Library** runs a small stack: public catalog site (`catalog-site`, Next.js), staff holds desk (`desk-app`, Next.js), and a FastAPI service (`library-api`). Telemetry shows repeated identical `GET /books` calls and a heavy filter panel re-rendering on every keystroke. In one session, demo **deliberate caching** on a reduced surface — not the full corporate monorepo scope of the graded project.

### Scope note

| Graded project (`ai-eng-application-caching`) | This class example                                       |
| --------------------------------------------- | -------------------------------------------------------- |
| Company website + backoffice (2 apps)         | Catalog site + desk app                                  |
| ≥2 lazy-loaded components/routes              | 1 lazy-loaded component                                  |
| ≥1 `useMemo` on non-trivial computation       | 1 `useMemo` on book filter/sort                          |
| ≥2 cached endpoints + full endpoint audit     | 1 cached `GET` + list why others are skipped             |
| Full `CACHING_REPORT.md` rubric               | Short `CACHING_CLASS.md` (4 sections)                    |
| Invalidation on all write paths               | Invalidation on one `POST` that affects the cached `GET` |

---

## What to build

### 1. Frontend — one lazy load

- [ ] Pick **one** heavy component (e.g. `BookCoverGallery` or `LoanHistoryChart`) used only on a secondary route or below the fold.
- [ ] Load it with `next/dynamic` (or `React.lazy` + `Suspense` if not on App Router).
- [ ] One sentence in notes: why deferring this chunk helps TTI.

### 2. Frontend — one `useMemo`

- [ ] In the desk app list view, memoize a **non-trivial** derived list (filter + sort over ≥50 mock books).
- [ ] Dependency array: `[books, searchQuery, sortKey]` (or equivalent).
- [ ] Do **not** memoize trivial string formatting.

### 3. Backend — one TTL cache + invalidation

| Endpoint          | Cache? | TTL | Notes                                    |
| ----------------- | ------ | --- | ---------------------------------------- |
| `GET /books`      | Yes    | 45s | Public catalog; stable between check-ins |
| `GET /members/me` | No     | —   | Per-user; shared key = leak              |
| `POST /books`     | —      | —   | Must invalidate `GET /books` cache       |

- [ ] Implement in-process dict cache (or `functools` + expiry) for `GET /books` only.
- [ ] On `POST /books` (new title), clear or prefix-invalidate catalog cache.
- [ ] Log or comment why `GET /members/me` was rejected.

### 4. Short report

- [ ] Create `CACHING_CLASS.md` with:
  - **Frontend** (lazy + memo choices)
  - **Backend** (TTL + invalidation for `/books`)
  - **One tradeoff** (e.g. 45s stale catalog vs. faster browse)
  - **Not cached** (at least `/members/me` with reason)

---

## Verify together

- [ ] Second `GET /books` is faster than first (or returns same payload from cache — demonstrate with logs).
- [ ] After `POST /books`, next `GET /books` includes the new title.
- [ ] Lazy chunk appears only when navigating to the route that needs it (Network tab: separate JS chunk).
- [ ] `useMemo` deps change → list recalculates (toggle sort in UI).
- [ ] Apps and API still start (`docker compose up` or local dev commands).

---

## Discussion questions

1. Why is a 45s TTL acceptable for a public book list but not for “books I have checked out right now”?
2. When does lazy loading hurt UX (loading spinners, layout shift) more than it helps bundle size?
3. How would you move the in-process cache to Redis without changing the invalidation story?
