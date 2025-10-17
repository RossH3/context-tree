# Context Tree Documentation Architecture

## Overview

Build and maintain a **context tree** - structured documentation that maximizes AI assistant effectiveness on codebases, particularly brownfield projects (existing production code with limited documentation). A conference management SaaS application serves as the reference implementation.

**Audience:** AI assistants (primary), senior developers and architects (secondary)

## What is the Context Tree?

A structured documentation architecture built on **hierarchical CLAUDE.md files** that provide decision-tree guidance for AI assistants and developers. It connects business domain knowledge, technical architecture, and implementation patterns to mirror how developers access information.

## Hierarchical CLAUDE.md Pattern

Following Anthropic's recommended approach, the context tree uses **CLAUDE.md files at each directory level**:

```
/CLAUDE.md                     # Root: Project-wide navigation, critical patterns, AI guidance
├── docs/CLAUDE.md             # Documentation navigation and quick reference
├── app/CLAUDE.md              # Application structure and MVC patterns
│   ├── controllers/CLAUDE.md  # Controller patterns and key controllers
│   └── views/CLAUDE.md        # Template patterns and view helpers
└── config/CLAUDE.md           # Configuration guide and settings
```

### Why Hierarchical CLAUDE.md?

**Predictable Discovery:** Always look for CLAUDE.md in the relevant directory
- Need controller guidance? → `app/controllers/CLAUDE.md`
- Need docs navigation? → `docs/CLAUDE.md`
- Need overall guidance? → Root `CLAUDE.md`

**Scoped Context:** Each CLAUDE.md provides relevant context at its level
- Smaller, focused files reduce cognitive load
- Better token efficiency for AI assistants
- Faster loading of relevant information

**Consistent Pattern:** One naming convention for all navigation files
- Developers know where to look
- AI assistants have predictable discovery path
- Easier maintenance and updates

## Root CLAUDE.md

Root CLAUDE.md provides:

- **Quick Start checklists** for new developers
- **Decision tree navigation** for common scenarios
- **Complete documentation map** with clear purposes
- **Critical architectural patterns** that apply project-wide
- **Comprehensive AI assistant guidance** and decision trees
- **Cross-references** to subdirectory CLAUDE.md files

### What Belongs Where: Root vs Subdirectory CLAUDE.md

**Root CLAUDE.md** contains project-wide essentials:
- ✅ Critical architectural patterns (multi-tenancy, data access)
- ✅ Decision trees for common scenarios
- ✅ Complete documentation map
- ✅ Quick start checklist
- ✅ System overview and technology stack
- ✅ Cross-cutting concerns (security, performance)
- ❌ Directory-specific implementation details
- ❌ Exhaustive API listings
- ❌ Detailed code walkthroughs

**Subdirectory CLAUDE.md** contains scoped, focused guidance:
- ✅ Patterns specific to that directory's domain
- ✅ Key files and their purposes within that directory
- ✅ Common tasks performed in that area
- ✅ Directory-specific gotchas and conventions
- ❌ Project-wide architectural decisions
- ❌ Patterns used across multiple directories
- ❌ Business context spanning multiple domains

**When to Move Content:**
- **Root → Subdirectory**: Content only relevant when working in specific directory
- **Subdirectory → Root**: Pattern used across multiple directories, or critical for understanding system
- **Either → docs/**: Comprehensive reference material too detailed for CLAUDE.md

**Token Efficiency Test**: If content is rarely needed, move it deeper or to reference docs.

## Documentation Structure

**Note:** The file listings below show a conference management project's implementation as a concrete example. Other projects will have different files based on architecture and needs, but should follow the same organizational patterns.

### 1. Hierarchical Navigation (CLAUDE.md files)
```
CLAUDE.md                      → Root navigation hub, AI guidance, critical patterns
docs/CLAUDE.md                 → Documentation navigation and quick reference
app/CLAUDE.md                  → Application structure and MVC patterns
app/controllers/CLAUDE.md      → Controller patterns and key controllers
app/views/CLAUDE.md            → Template patterns and view helpers
config/CLAUDE.md               → Configuration guide and settings
```

**Purpose:** Consistent, predictable navigation at each directory level. See [Hierarchical CLAUDE.md Pattern](#hierarchical-claudemd-pattern) above.

### 2. Detailed Reference Documentation (docs/)

**Core System Knowledge (6 files)**
```
docs/ARCHITECTURE.md           → System architecture and technical stack
docs/BUSINESS_CONTEXT.md       → Business workflows and domain knowledge
docs/RAILS_5.2_REFERENCE.md    → Rails 5.2-specific patterns and gotchas
docs/CONFIGURATION.md          → Organization settings and configuration system
docs/DATA_FLOWS.md             → How data moves through the system
docs/VENUESYSTEMS_INTEGRATION.md → External VenueSystems libraries and services
```

**AI & Development Reference (2 files)**
```
docs/AI_STRATEGIES.md          → Search patterns and AI navigation strategies
docs/VIEW_PATTERNS.md          → Template architecture and view patterns
```

**Entity & API Reference (6 files)**
```
docs/ENTITIES.md               → Core domain entities and relationships
docs/API_REFERENCE.md          → API endpoints with business context
docs/KEY_CONTROLLERS.md        → Deep dive on critical controllers
docs/TROUBLESHOOTING.md        → Common issues and solutions
docs/GLOSSARY.md               → Business and technical terms
docs/BADGE_PRINTING.md         → Badge generation and printing workflows
```

**Component Documentation (6 files)**
```
docs/PAYMENTS_STORAGE.md       → Payment processing and data access layer (Elasticsearch/MySQL)
docs/PAYMENTS.md               → Payment system and data querying utilities
docs/CACHING.md                → Caching framework (Redis)
docs/NOTIFICATIONS.md          → Email and notification service integration
docs/AUDIT_LOGGING.md          → Logging and audit trail infrastructure
docs/UTILITIES.md              → Utility libraries reference
```

**Purpose:** Comprehensive, detailed reference materials with descriptive names for human browsability.


## Design Principles

### 1. Hierarchical CLAUDE.md Pattern
The hierarchical CLAUDE.md pattern (detailed in [Hierarchical CLAUDE.md Pattern](#hierarchical-claudemd-pattern) section) is the cornerstone of context tree architecture, enabling predictable navigation, scoped context, and token-efficient AI assistance.

### 2. Flexible Content, Consistent Navigation
- **Content flexibility** - Teams write context in their voice, adapting to codebase needs
- **Navigation consistency** - Predictable CLAUDE.md discovery pattern across all directories
- **Dual purpose** - CLAUDE.md files serve both humans and AI assistants
- **AI optimization** - Structure designed for Claude Code's automatic loading

### 3. Two-Tier Documentation Model
- **CLAUDE.md files** - Navigation hubs with quick reference, patterns, and decision trees
- **Detailed .md files** - Comprehensive reference materials with descriptive names
- **Benefit** - Consistent AI navigation + human-browsable reference docs
- **Prevents** - Information overload from massive single files

### 4. Decision Tree Navigation
Documentation provides decision tree navigation:
- **Debugging something broken?** → Specific diagnosis paths
- **Building a feature?** → Implementation guidance paths
- **Understanding the system?** → Learning sequence paths

### 5. Just-in-Time Information
Consume documents when needed, with clear purposes:
- **When to Read** columns in CLAUDE.md documentation maps
- **Specific problem → Specific document** routing via decision trees
- **Cross-references** between related concepts and hierarchy levels

### 6. Business-Technical Integration
Technical documentation includes business context:
- Controllers organized by business domain, not alphabetically
- API documentation includes business purpose
- Code patterns explain business reasoning

### 7. Hard vs Soft Context Separation
Context trees focus on semantic meaning that complements structural analysis:
- **Hard Context** (Language Server Domain): Symbols, types, imports, syntax
  - Example: `class Registration < ActiveRecord::Base`
- **Soft Context** (Context Tree Domain): Business logic, design decisions, gotchas, institutional knowledge
  - Example: "Registrations represent attendee signups - search for Registration not Signup"
- **Principle**: Capture what cannot be automatically extracted from code structure

### 8. AI-Optimized Structure
- **Predictable file locations** - Always check for CLAUDE.md first
- **Rich cross-referencing** - Links between hierarchy levels and reference docs
- **Consistent formatting** - Similar section structures across all CLAUDE.md files
- **Decision tree logic** - Mirrors how AI assistants work through problems

## Content Principles

### Keep the Meat, Throw Away the Bones
Prioritize **token efficiency and signal-to-noise ratio**:
- **Keep**: Essential patterns, gotchas, business context, architectural decisions
- **Remove**: Verbose explanations, repetitive examples, information derivable from code
- **Principle**: Every line must justify its token cost
- **Why**: AI assistants have token limits; maximize value per token consumed

### Single Source of Truth for Architectural Facts
Architectural facts have **one authoritative location** to prevent documentation drift:
- **Core architecture** → `docs/ARCHITECTURE.md`
- **Technology stack versions** → `docs/ARCHITECTURE.md`
- **Data storage patterns** → `docs/ARCHITECTURE.md` (high-level) + `docs/PAYMENTS_STORAGE.md` (implementation)
- **Business workflows** → `docs/BUSINESS_CONTEXT.md`

**Rule**: Other documents reference the source of truth, never duplicate it
**Example**: "MySQL = Primary Storage, Elasticsearch = Query Engine" lives in ARCHITECTURE.md; other docs link to it

### Bad Context is Worse Than Bad Code
Outdated or incorrect documentation misleads:
- **Bad code**: Can be debugged, identified through testing, fixed incrementally
- **Bad context**: Silently trains AI assistants incorrectly, compounds errors, erodes trust
- **Maintenance priority**: Context tree maintenance is as critical as code maintenance
- **Validation**: Cross-check facts when updating; fix inconsistencies immediately

### Verify Architectural Claims Against Code
Documentation propagates incorrect architecture without validation:
- **Anti-pattern**: Documenting based on other documentation without code verification
- **Risk**: Architectural misunderstandings spread across multiple files, compounding misinformation
- **Best practice**: Verify claims against actual code implementation
- **Example lesson**: A configuration system was incorrectly documented as a three-layer hierarchy (System → App → Org) when actual implementation was two-layer (Static + Per-Organization with multiple types)
- **Detection**: Look for inconsistencies between documentation claims and actual API calls in code
- **Remedy**: When correcting architectural documentation, search entire context tree for propagated errors

### Work in Progress
The context tree **evolves**:
- We're still learning optimal patterns for AI-assisted coding
- Maintenance strategies will evolve (likely automated review hooks)
- Be selective and deliberate when adding new guidance
- Document lessons learned as we discover them

## Repository Structure

### Integrated Context Tree Model

The context tree lives in the main codebase alongside production code on feature branches. Hierarchical CLAUDE.md pattern and focused reference files minimize merge conflicts - changes to `app/controllers/CLAUDE.md` don't conflict with `app/views/CLAUDE.md`, and developers typically work on different domain areas.

**Development Workflow:**
1. Update context tree on your feature branch alongside code changes
2. Commit documentation with related code changes
3. Standard git workflow - branch, commit, merge like any other code asset
4. Multiple team members can update different parts concurrently

## Maintenance

### Adding New Documentation
1. **Create on your branch** - Follow existing patterns (hierarchical CLAUDE.md or focused reference docs)
2. **Update navigation** - Add reference in appropriate CLAUDE.md documentation map section
3. **Cross-reference** - Link from related documents for discoverability
4. **Update decision trees** - Add to CLAUDE.md decision trees if new guidance paths needed
5. **Merge with code** - Documentation updates merge alongside code changes

### Updating Existing Documentation
1. **Edit on feature branch** - Context tree updates merge easily due to hierarchical structure
2. **Maintain alignment** - Keep business and technical contexts synchronized
3. **Validate references** - Update cross-references when moving or restructuring content
4. **Test links** - Verify all CLAUDE.md links resolve correctly
5. **Consistent formatting** - Follow established patterns for easier merging

### Best Practices for Merge-Friendly Updates
- **Scope your changes** - Work within relevant directory's CLAUDE.md to minimize conflicts
- **Atomic commits** - Commit documentation with related code changes
- **Clear commit messages** - Describe both code and doc changes
- **Review cross-references** - Check links after merging branches
- **Hierarchical isolation** - Most updates stay within their directory scope, reducing conflicts

## Usage

### For Developers
Use CLAUDE.md for documentation navigation and follow decision trees relevant to your task.

### For AI Assistants

**Hierarchical Loading Strategy:**

Claude Code automatically loads root `CLAUDE.md`. From there, load context hierarchically based on your focus:

- **Root CLAUDE.md** - Auto-loaded by Claude Code
  - Project-wide patterns, decision trees, and navigation map
  - Use decision trees for task-specific routing
  - Reference point for all documentation discovery

- **Subdirectory CLAUDE.md** - Load when working in that directory
  - Working on controllers? → Load `app/controllers/CLAUDE.md`
  - Need docs guidance? → Load `docs/CLAUDE.md`
  - Configuring system? → Load `config/CLAUDE.md`
  - Scoped, focused context without token overhead

- **Reference .md files** - Load as needed for detailed information
  - Follow cross-references from CLAUDE.md files
  - Comprehensive data for specific domains
  - Load only when decision trees or CLAUDE.md files indicate relevance

**Key Advantage:** Hierarchical structure matches how AI assistants work through problems - start broad (root), focus as needed (subdirectories), dive deep when required (references).

### For New Team Members
Follow the "First Day Checklist" in CLAUDE.md for structured onboarding.

---

*This context tree represents a comprehensive knowledge architecture designed to eliminate AI tech debt and maximize development velocity through structured, accessible documentation.*
