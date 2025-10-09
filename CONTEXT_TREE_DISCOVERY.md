# Context Tree Discovery: Automated Analysis Commands

**For AI Assistants:** Run these commands to gather automated discovery data before starting the developer interview.

---

## Tech Stack Detection

### Language & Framework Detection

```bash
# Check for common package files
ls -la | grep -E "(pom.xml|build.gradle|package.json|requirements.txt|Gemfile|go.mod|Cargo.toml)"

# If Ruby project, check Ruby version and dependencies
[ -f Gemfile ] && grep -E "(ruby |gem )" Gemfile | head -20
[ -f .ruby-version ] && cat .ruby-version

# If Node.js, check package.json
[ -f package.json ] && cat package.json | grep -A 20 '"dependencies"'

# Check for framework markers
find . -name "*.rb" -o -name "*.js" | head -5 | xargs grep -h "^require\|^import" | grep -E "(rails|sinatra|express)" | sort -u | head -10
```

### Database Detection

```bash
# Check for database configs
find config -name "*.yml" -o -name "*.rb" 2>/dev/null | xargs grep -i -E "(mysql|postgres|mongo|redis|elasticsearch)" | head -20

# Check for database dependencies
[ -f Gemfile ] && grep -i -E "(mysql|postgres|mongo|redis|elasticsearch)" Gemfile
```

### Version Detection

```bash
# Look for version declarations
grep -r "version.*=" . --include="*.properties" --include="*.conf" --include="*.yml" | grep -v node_modules | head -20
```

---

## Directory Structure Analysis

```bash
# Top-level structure
tree -L 2 -d . 2>/dev/null || find . -maxdepth 2 -type d | head -30

# Key directories
ls -la app/ 2>/dev/null
ls -la src/ 2>/dev/null
ls -la config/ 2>/dev/null
ls -la lib/ 2>/dev/null
ls -la spec/ 2>/dev/null
ls -la test/ 2>/dev/null
```

---

## Entry Points & Routes

```bash
# Look for routes file (common in Rails, Django, etc.)
find . -name "routes.rb" -o -name "routes" -o -name "urls.py" | head -5

# If routes file exists, show sample
[ -f config/routes.rb ] && head -30 config/routes.rb

# Look for main entry points
find . -name "application.rb" -o -name "application_controller.rb" -o -name "app.js" -o -name "main.py" | head -10
```

---

## Pattern Detection

### Multi-Tenancy Detection

```bash
# Look for orgid patterns
grep -r "orgid\|org_id\|tenant" --include="*.rb" --include="*.js" --include="*.py" . | wc -l

# Show examples
grep -r "orgid" --include="*.rb" . | head -5
```

### Authentication Pattern Detection

```bash
# Look for auth patterns
grep -r "session\|JWT\|authenticate\|login" --include="*.rb" --include="*.js" . | grep -v test | head -10
```

### Architecture Pattern Detection

```bash
# Check for microservices indicators
ls -la | grep -E "(docker-compose|kubernetes|service)"

# Check for monolith indicators (MVC structure)
[ -d app/controllers ] && [ -d app/models ] && [ -d app/views ] && echo "MVC pattern detected"
```

---

## Existing Documentation Audit

```bash
# Find markdown files
find . -name "*.md" | head -20

# Check README
[ -f README.md ] && wc -l README.md

# Look for wiki references
grep -r "wiki\|confluence\|documentation" --include="*.md" . | head -10
```

---

## Build & Test Setup

```bash
# Build system detection
ls -la | grep -E "(Makefile|Rakefile|Gemfile|package.json)"

# Test framework detection
find . -name "*_spec.rb" -o -name "*test.js" -o -name "test_*.py" | head -5
[ -d spec ] && echo "Spec directory found" && ls spec/
```

---

## Usage for AI Assistants

**When starting context tree creation:**

1. Run commands in each section
2. Collect outputs
3. Summarize findings in structured format (see CONTEXT_TREE_BUILDER.md Phase 1 example)
4. Present to developer for validation
5. Use findings to customize interview questions

**Pro tips:**
- Don't run all at once - group by category
- Show sample outputs, not everything
- Ask developer to confirm/correct findings
- Use findings to skip irrelevant interview questions

**Example workflow:**

```
AI: I'm running automated discovery to understand the codebase structure...

[Runs tech stack commands]

AI: Found:
- Ruby 2.5 with Rails 5.2 (from Gemfile)
- MySQL 5.6 and Elasticsearch 2.4 dependencies
- MVC structure (app/controllers, app/models, app/views)

[Runs pattern detection]

AI: Detected patterns:
- Multi-tenant: Found "orgid" in 52 files
- Monolithic MVC application
- Session-based auth (application_controller.rb)

Does this match your understanding? Should I continue with the business context interview?
```

---

*This discovery checklist is part of the Context Tree Builder tool - see CONTEXT_TREE_BUILDER.md for the complete interview and generation process.*
