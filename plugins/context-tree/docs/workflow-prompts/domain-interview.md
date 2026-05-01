# Phase 2: Domain Expert Interview

**Purpose:** Interactive Q&A with domain expert to capture institutional knowledge that can't be inferred from code

**Time:** 30-60 minutes (can span multiple sessions)

**Input:** `docs/context-tree-build/discovery.md`

**Output:** `docs/context-tree-build/interview.md` (append-only with summary section)

---

## ⭐ This Is The Crown Jewel

**Why this phase matters:** AI can explore code and infer structure, but it cannot know:
- Why architectural decisions were made
- What terminology means in business context
- What mistakes developers repeatedly make
- What takes longest to explain to new team members
- Institutional knowledge that exists only in people's heads

**This is the unique value of this tool.**

---

## Your Mission

You are conducting a structured interview with someone who knows this codebase intimately. Your goals:

1. **Ask focused questions** - One at a time, based on discovery findings
2. **Verify answers immediately** - Check claims against actual code
3. **Adapt based on answers** - Follow-up questions informed by previous answers
4. **Capture institutional knowledge** - The stuff that's not in the code
5. **Be resumable** - Append to markdown file, update summary after each session

---

## Interview Structure

### Before You Start

1. **Load discovery findings:** Read `docs/context-tree-build/discovery.md`
2. **Check for existing interview:** Read `docs/context-tree-build/interview.md` if it exists
3. **If resuming:** Scroll to "Interview Summary" section, parse current state, continue from next category

### Interview Categories (in order)

1. **Terminology Traps** (15-20 min)
2. **Architectural Gotchas** (15-20 min)
3. **Business Context & Workflows** (10-15 min)
4. **Common Pitfalls** (5-10 min)
5. **Pain Points & What Takes Longest to Explain** (5-10 min)

**You don't need to cover all categories if time is short.** Depth over breadth.

---

## Question Format: One Question at a Time

### Asking Questions

**DO THIS:**
```
Based on the codebase discovery, I found that the UI uses the term
"Application" but the code has an Order class.

Question: What does "Application" mean in your business context, and
why is it called "Order" in the code?
```

**NOT THIS:**
```
Tell me about:
1. Applications
2. Orders
3. Processes
4. Schools
5. Grades
[... 20 more questions]
```

### Processing Answers

After each answer:

1. **Verify against code immediately:**
   - Use Grep to find relevant code
   - Use Read to examine specific files
   - Check if answer matches what code actually does

2. **Append Q&A to interview.md:**
   - Question asked
   - Answer (verbatim from user)
   - Verification result (✅ Confirmed / ⚠️ Partially / ❌ Contradicted)
   - Code evidence (files, line numbers, grep results)
   - Value assessment (High/Medium/Low)
   - Security-critical flag if applicable

3. **Adaptive follow-up:**
   - If answer reveals new complexity: Ask clarifying question
   - If answer contradicts code: Ask about the discrepancy
   - If answer is clear: Move to next topic

4. **Update summary section:** After each Q&A or session break, update the summary at bottom

---

## Interview Categories & Question Examples

### Category 1: Terminology Traps (CRITICAL)

**Goal:** Map UI terms → Code terms → DB terms, identify confusing naming

**Seed questions from discovery.md terminology section**

**Question patterns:**
- "I see the UI says [X] but the code uses [Y]. Why the difference?"
- "What does [business term] actually mean in your domain?"
- "If I'm searching the codebase for [feature], what class/file should I look for?"
- "Are there other terminology mismatches like Application=Order?"

**What to capture:**
- UI term vs code term vs database term
- Why the naming difference exists
- How to search for features (keywords that actually work)
- Domain-specific jargon and what it means

---

### Category 2: Architectural Gotchas

**Goal:** Understand non-obvious architectural patterns and constraints

**Seed questions from discovery.md confusing areas**

**Question patterns:**
- "I noticed you use both [tech A] and [tech B]. What's the relationship?"
- "How does [pattern] actually work in practice?"
- "What happens if a developer forgets to [architectural rule]?"
- "Why are you still on [legacy version]? Are there constraints?"

**What to capture:**
- How systems interact (especially dual databases, multi-tenancy)
- Critical rules that must be followed (security, data integrity)
- Constraints from legacy tech stack
- What breaks if you violate architectural patterns

---

### Category 3: Business Context & Workflows

**Goal:** Understand what the system actually does and who uses it

**Question patterns:**
- "Who are the users of this system? What are their roles?"
- "Walk me through the main workflow from start to finish"
- "What's the core business problem this solves?"
- "What are the critical business rules?"

**What to capture:**
- User types and their goals
- Primary workflow (the happy path)
- Business rules that aren't obvious from code
- Edge cases that matter to the business

---

### Category 4: Common Pitfalls

**Goal:** Learn what developers repeatedly get wrong

**Question patterns:**
- "What's the most common mistake new developers make?"
- "What did you get wrong when you first started on this codebase?"
- "What breaks in production most often?"
- "If you could go back and warn yourself, what would you say?"

**What to capture:**
- Common mistakes (with examples)
- Hard-to-debug errors
- Gotchas that aren't obvious from code
- Anti-patterns to avoid

---

### Category 5: Pain Points & What Takes Longest to Explain

**Goal:** Understand what's genuinely hard about this codebase

**Question patterns:**
- "What takes longest to explain to new team members?"
- "What do you wish was better documented?"
- "What's the most confusing part of this system?"
- "If you were onboarding someone, what would you emphasize?"

**What to capture:**
- Complex subsystems that need extra explanation
- Subtle interactions between components
- Historical context (why things are the way they are)
- What to focus on during onboarding

---

## interview.md Format (Append-Only)

Save to: `docs/context-tree-build/interview.md`

**Structure:**
```markdown
# Phase 2: Domain Expert Interview

**Started:** 2025-12-16 14:00
**Interviewer:** Claude Code
**Expert:** [Optional - can be filled in]

---

## Interview Session 1 - 2025-12-16 14:00

### Category: Terminology Traps

---

#### Q1: Submission vs Order terminology

**Question:** The UI shows "Submission" but code uses Order class. What does "Submission" mean in your business context, and why is it called Order in the code?

**Answer:** Historical reasons. The system started as an order processing system before pivoting to its current domain. We kept Order in the code but changed UI language to be domain-appropriate. New developers always search for "Submission" first and get confused.

**Verified:** ✅ Confirmed
- Checked `app/models/Order.java` - handles user submissions
- Checked `app/controllers/Submissions.java` - delegates to Order model
- Pattern confirmed across codebase

**Value:** High - Critical for new developer onboarding

---

#### Q2: PostgreSQL + Redis relationship

**Question:** Discovery shows both PostgreSQL and Redis. What's the relationship between them?

**Answer:** PostgreSQL is the source of truth for all data. Redis is purely for caching and query acceleration. Data gets written to PostgreSQL, then cached in Redis. All reads check Redis first, then fall back to PostgreSQL. Never write directly to Redis - that will cause data loss.

**Verified:** ✅ Confirmed
- Found `CacheService.rb:87` - writes to PostgreSQL then triggers Redis caching
- No direct Redis writes found in controllers
- Pattern consistent across codebase

**Value:** High - Architectural pattern, critical for correctness

**Follow-up Asked:** What happens if Redis cache is out of sync with PostgreSQL?

**Follow-up Answer:** We have a cache invalidation job that runs nightly to catch any missed updates. Also have manual cache flush command for emergencies: `rake cache:flush`

---

### Category: Common Pitfalls

---

#### Q3: Most common developer mistake

**Question:** What's the most common mistake new developers make in this codebase?

**Answer:** Forgetting to filter queries by clientid. Because it's multi-tenant by hostname, EVERY query must extract clientid = request().host() and filter by it. Otherwise you leak data across tenants. We've had 3 security bugs from this in past 2 years.

**Verified:** ✅ Confirmed
- Found pattern `String clientid = request().host()` in 47 controller methods
- Found warning comments in several files about multi-tenant filtering
- Security-critical pattern

**Value:** Critical - Security issue

**Security Critical:** Yes ⚠️

---

## Interview Session 2 - 2025-12-16 15:30

*(Resuming after break)*

### Category: Business Context

---

#### Q4: Main user workflow

**Question:** Walk me through the main workflow for a parent using this system, from start to finish.

**Answer:** [Parent workflow details...]

[... interview continues, append-only ...]

---

## Interview Summary

**Total Questions Asked:** 12
**Sessions:** 2
**Categories Completed:** Terminology (4 Q&A), Architecture (3 Q&A), Pitfalls (2 Q&A)
**Categories Remaining:** Business Context, Pain Points

**High-Value Insights:** 8
**Security-Critical Items:** 1

**Status:** Can resume - continue with Business Context category

---

*Interview notes are append-only. Each session adds to this file.*
```

### Key Format Rules

1. **Sessions are demarcated:** `## Interview Session N - [timestamp]`
2. **Questions numbered sequentially:** `#### Q1:`, `#### Q2:`, etc.
3. **Verification uses symbols:** ✅ Confirmed, ⚠️ Partially, ❌ Contradicted
4. **Summary at bottom:** Always update after session breaks
5. **Append-only:** Never delete previous Q&As, only add new ones
6. **Horizontal rules:** Use `---` to separate major sections

---

## Resumability with Markdown

### Starting Fresh
1. Read discovery.md to seed questions
2. Create new interview.md with header
3. Start first session with timestamp
4. Begin with Category 1 (Terminology)

### Resuming Existing Interview
1. Read existing interview.md
2. **Scroll to "Interview Summary" section**
3. Parse current state:
   - Total questions asked
   - Categories completed
   - Categories remaining
   - Next category to tackle
4. Start new session block: `## Interview Session N+1 - [timestamp]`
5. Continue with next category
6. Append new Q&As
7. Update summary section after session

### Parsing Summary Section

The summary section provides all resumability state:

```markdown
## Interview Summary

**Total Questions Asked:** 12
**Sessions:** 2
**Categories Completed:** Terminology (4 Q&A), Architecture (3 Q&A), Pitfalls (2 Q&A)
**Categories Remaining:** Business Context, Pain Points

**High-Value Insights:** 8
**Security-Critical Items:** 1

**Status:** Can resume - continue with Business Context category
```

**Parse this to determine:**
- How many questions have been asked (continue numbering from this)
- Which categories are done (skip these)
- Which category is next (start here)
- How many sessions (number next session accordingly)

### Session Break Points

Good places to pause:
- After completing a category
- After 10-12 questions (about 30-40 minutes)
- When user indicates time is running out

**Always update summary section before pausing.**

---

## Critical Principles

### ✅ DO
- **One question at a time** - don't overwhelm with question lists
- **Verify every answer against code** - immediately, before moving on
- **Adapt based on answers** - follow interesting threads
- **Append after each Q&A** - make it resumable
- **Update summary regularly** - after each session or every 3-4 Q&As
- **Push for specifics** - "Can you give me an example?" when answers are vague
- **Note value for docs** - mark high-value insights
- **Focus on what code can't show** - institutional knowledge, historical context, gotchas

### ❌ DON'T
- **Don't ask generic questions** - "Tell me about the architecture" is too broad
- **Don't accept vague answers** - push for specific examples
- **Don't skip verification** - if you can't verify, note it as "unverified"
- **Don't batch questions** - one at a time, verify, then next
- **Don't ask what code already shows** - focus on non-obvious knowledge
- **Don't lose answers** - append to interview.md after every Q&A
- **Don't forget to update summary** - critical for resumability

---

## Handling Special Cases

### If Answer Contradicts Code
```
"You mentioned [X], but when I checked [file], I found [Y].
 Can you help me understand the discrepancy?"
```

### If Answer Is Vague
```
"That's helpful context. Can you give me a specific example of when [X]
 happens or what [Y] looks like in practice?"
```

### If Answer Reveals New Complexity
```
"That's more complex than I realized. Let me ask a follow-up: [specific question]"
```

### If Unsure How to Verify
```
"I understand what you're saying, but I'm not sure how to verify this in the code.
 Can you point me to a file or pattern I should look for?"
```

---

## Quality Checks

Before moving to next category, ensure:
- [ ] At least 3 high-value insights captured (or note "category has limited insights")
- [ ] All answers verified against code (or marked "unverified" with reason)
- [ ] Follow-ups asked when answers revealed complexity
- [ ] Specific examples captured, not generic statements
- [ ] Security-critical or architecture-critical items flagged
- [ ] interview.md summary section updated

---

## Completion Criteria

Interview is complete when:
- **Minimum:** Categories 1-2 completed (Terminology + Architecture) - ~8-10 Q&As
- **Recommended:** Categories 1-4 completed (+ Business Context + Pitfalls) - ~12-15 Q&As
- **Comprehensive:** All 5 categories completed - ~15-20 Q&As

**Or:**
- User indicates time is up (update summary, save for later resume)
- Diminishing returns (answers becoming repetitive or low-value)

---

## After Completion

1. **Update summary section** with final counts
2. **Update status.md:** Mark Phase 2 as complete
3. **Commit interview.md** (message: "feat: complete Phase 2 domain expert interview")
4. **Report to orchestrator:**
   - "Phase 2 complete. Captured [X] terminology traps, [Y] architecture gotchas, [Z] total insights."
   - "Ready for Phase 3 documentation generation."

---

## Remember

**This interview is the unique value of this tool.** Take your time. Ask good questions. Verify answers. Capture institutional knowledge that would otherwise be lost.

**The quality of Phase 3 documentation depends entirely on the quality of this interview.**

The markdown format provides:
- ✅ Human-readable git diffs
- ✅ Easy to scan and review
- ✅ Clear resumability via summary section
- ✅ Appendable structure for multi-session interviews
- ✅ No JSON parsing complexity

---

**Begin domain expert interview now. One question at a time.**
