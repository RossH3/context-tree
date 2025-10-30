# Phase 2: Domain Expert Interview

**Purpose:** Interactive Q&A with domain expert to capture institutional knowledge that can't be inferred from code

**Time:** 30-60 minutes (can span multiple sessions)

**Input:** `docs/context-tree-build/discovery_summary.json`

**Output:** `docs/context-tree-build/interview_notes.json` (updated incrementally)

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
5. **Be resumable** - Save progress after each verified Q&A

---

## Interview Structure

### Before You Start

1. **Load discovery findings:** Read `docs/context-tree-build/discovery_summary.json`
2. **Check for existing interview:** Read `docs/context-tree-build/interview_notes.json` if it exists
3. **If resuming:** Review previous Q&As and continue from where you left off

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

2. **Update interview_notes.json with:**
   - The question
   - The answer (verbatim from user)
   - Verification result (confirmed/partially confirmed/contradicted by code)
   - Code evidence (files, line numbers, grep results)

3. **Adaptive follow-up:**
   - If answer reveals new complexity: Ask clarifying question
   - If answer contradicts code: Ask about the discrepancy
   - If answer is clear: Move to next topic

4. **Save progress:** Write updated interview_notes.json after each verified Q&A

---

## Interview Categories & Question Examples

### Category 1: Terminology Traps (CRITICAL)

**Goal:** Map UI terms → Code terms → DB terms, identify confusing naming

**Seed questions from discovery_summary.json.terminology_discovered**

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

**Example:**
```
Q: "The UI shows 'School Choice Process' but I found 'Opportunity' in code.
    What's the relationship?"

A: "An Opportunity is actually the combination of a Process, a School, and a
    Grade level. So 'School Choice Process' in the UI is the parent, and each
    school offering in that process is an Opportunity."

Verification: ✅ Confirmed - grep shows Opportunity has fields processId,
              schoolId, gradeId in app/models/Opportunity.java:42-44

Follow-up: "So if a parent is applying to 3 schools in the same process,
            that's 3 separate Opportunity records?"
```

---

### Category 2: Architectural Gotchas

**Goal:** Understand non-obvious architectural patterns and constraints

**Seed questions from discovery_summary.json.confusing_areas**

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

**Example:**
```
Q: "Discovery shows both PostgreSQL and Redis. What's the relationship?"

A: "PostgreSQL is the source of truth for all data. Redis is purely
    for caching and query acceleration. Data gets written to PostgreSQL,
    then cached in Redis. All reads check Redis first, then fall back to
    PostgreSQL. Never write directly to Redis."

Verification: ✅ Confirmed - Found CacheService.rb that writes to PostgreSQL
              then triggers Redis caching. No direct Redis writes in controllers.

Follow-up: "What happens if Redis cache is out of sync with PostgreSQL?"
```

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

**Example:**
```
Q: "What's the main workflow for a parent using this system?"

A: "District admin creates a process and adds schools/grades. Parent logs in,
    fills out application (which generates an Order), ranks their school
    choices. After deadline, system runs lottery algorithm and generates
    assignments. Parent sees their assignment and accepts/declines."

Verification: ✅ Confirmed - Found workflow stages in Process.java status enum:
              DRAFT, OPEN, CLOSED, LOTTERY_RUN, RESULTS_PUBLISHED

Follow-up: "What happens if a parent doesn't accept or decline?"
```

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

**Example:**
```
Q: "What's the most common mistake new developers make in this codebase?"

A: "Forgetting to filter queries by clientid. Because it's multi-tenant by
    hostname, EVERY query must extract clientid = request().host() and filter
    by it. Otherwise you leak data across tenants. We've had 3 security bugs
    from this."

Verification: ✅ Confirmed - Found pattern in secure controllers. Also found
              comments in several files warning about this.

Capture: ⚠️ SECURITY-CRITICAL pitfall - add to Common Pitfalls section
```

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

**Example:**
```
Q: "What takes the longest time to explain to new developers?"

A: "The dual database pattern. People don't understand why we have both
    PostgreSQL and Redis, which one to query, when data is out of sync, how
    caching works, why we can't just use one. I spend 30 minutes on this
    every onboarding."

Verification: ✅ Confirmed - This explains the complexity I saw in discovery

Capture: Add detailed explanation to ARCHITECTURE.md (if generated)
```

---

## interview_notes.json Format

Save incrementally at: `docs/context-tree-build/interview_notes.json`

```json
{
  "metadata": {
    "started_at": "2025-10-30T10:00:00Z",
    "last_updated": "2025-10-30T11:42:00Z",
    "status": "in_progress",
    "questions_asked": 14,
    "session_count": 2,
    "can_resume": true
  },
  "qa_sessions": [
    {
      "id": 1,
      "category": "terminology",
      "question": "The UI says 'Application' but code uses 'Order'. Why the difference?",
      "answer": "Historical reasons. The system started as an order processing system before pivoting to school choice. We kept Order in the code but changed UI language. Search for 'Order' not 'Application'.",
      "verified": true,
      "verification": {
        "result": "confirmed",
        "evidence": "app/models/Order.java exists, handles student applications. app/controllers/Applications.java delegates to Order model.",
        "files_checked": ["app/models/Order.java", "app/controllers/Applications.java"]
      },
      "timestamp": "2025-10-30T10:15:00Z",
      "value_for_docs": "high"
    },
    {
      "id": 2,
      "category": "architecture",
      "question": "I see both PostgreSQL and Redis. What's the relationship?",
      "answer": "PostgreSQL is source of truth, Redis is cache only. Write to PostgreSQL, async cache in Redis. All queries check Redis first, fall back to PostgreSQL. Never write directly to Redis.",
      "verified": true,
      "verification": {
        "result": "confirmed",
        "evidence": "CacheService.rb:87 writes to PostgreSQL then triggers Redis caching. No direct Redis writes found in controllers.",
        "files_checked": ["app/services/cache_service.rb", "app/controllers/*.rb"]
      },
      "timestamp": "2025-10-30T10:22:00Z",
      "value_for_docs": "high",
      "follow_up_asked": "What happens if Redis is out of sync with PostgreSQL?",
      "follow_up_answer": "We have a cache invalidation job that runs nightly to catch any missed updates. Also manual cache flush command for emergencies."
    },
    {
      "id": 3,
      "category": "pitfalls",
      "question": "What's the most common mistake new developers make?",
      "answer": "Forgetting clientid filter in queries. Every query MUST filter by clientid or you leak data across tenants. We've had 3 security bugs from this in the past 2 years.",
      "verified": true,
      "verification": {
        "result": "confirmed",
        "evidence": "Found pattern 'String clientid = request().host()' in 47 controller methods. Found warning comments in several files about multi-tenant filtering.",
        "files_checked": ["app/controllers/*.java", "code comments"]
      },
      "timestamp": "2025-10-30T10:35:00Z",
      "value_for_docs": "critical",
      "security_critical": true
    }
  ],
  "categories_completed": ["terminology", "architecture"],
  "categories_in_progress": ["pitfalls"],
  "categories_remaining": ["business_context", "pain_points"],
  "insights_summary": {
    "terminology_traps": 4,
    "architecture_gotchas": 3,
    "business_rules": 2,
    "common_pitfalls": 2,
    "pain_points": 1,
    "security_critical_items": 1
  }
}
```

---

## Critical Principles

### ✅ DO
- **One question at a time** - don't overwhelm with question lists
- **Verify every answer against code** - immediately, before moving on
- **Adapt based on answers** - follow interesting threads
- **Save after each Q&A** - make it resumable
- **Push for specifics** - "Can you give me an example?" when answers are vague
- **Note value for docs** - mark high-value insights
- **Focus on what code can't show** - institutional knowledge, historical context, gotchas

### ❌ DON'T
- **Don't ask generic questions** - "Tell me about the architecture" is too broad
- **Don't accept vague answers** - push for specific examples
- **Don't skip verification** - if you can't verify, note it as "unverified"
- **Don't batch questions** - one at a time, verify, then next
- **Don't ask what code already shows** - focus on non-obvious knowledge
- **Don't lose answers** - save interview_notes.json after every Q&A

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

## Resumability

### Starting Fresh
1. Read discovery_summary.json
2. Create new interview_notes.json with empty qa_sessions
3. Start with Category 1 (Terminology)

### Resuming Existing Interview
1. Read existing interview_notes.json
2. Review previous Q&As
3. Check categories_completed and categories_remaining
4. Continue from where you left off
5. Append new Q&As to qa_sessions array

### Session Break Points
Good places to pause:
- After completing a category
- After 10-12 questions (about 30-40 minutes)
- When user indicates time is running out

**Always save progress before pausing.**

---

## Quality Checks

Before moving to next category, ensure:
- [ ] At least 3 high-value insights captured (or note "category has limited insights")
- [ ] All answers verified against code (or marked "unverified" with reason)
- [ ] Follow-ups asked when answers revealed complexity
- [ ] Specific examples captured, not generic statements
- [ ] Security-critical or architecture-critical items flagged
- [ ] interview_notes.json saved with latest Q&As

---

## Completion Criteria

Interview is complete when:
- **Minimum:** Categories 1-2 completed (Terminology + Architecture) - ~8-10 Q&As
- **Recommended:** Categories 1-4 completed (+ Business Context + Pitfalls) - ~12-15 Q&As
- **Comprehensive:** All 5 categories completed - ~15-20 Q&As

**Or:**
- User indicates time is up (save progress for later resume)
- Diminishing returns (answers becoming repetitive or low-value)

---

## After Completion

1. **Mark status as "completed"** in interview_notes.json metadata
2. **Calculate insights_summary** (counts by category)
3. **Commit interview_notes.json** (message: "feat: complete Phase 2 domain expert interview")
4. **Report to orchestrator:**
   - "Phase 2 complete. Captured [X] terminology traps, [Y] architecture gotchas, [Z] total insights."
   - "Ready for Phase 3 documentation generation."

---

## Remember

**This interview is the unique value of this tool.** Take your time. Ask good questions. Verify answers. Capture institutional knowledge that would otherwise be lost.

**The quality of Phase 3 documentation depends entirely on the quality of this interview.**

---

**Begin domain expert interview now. One question at a time.**
