# ABOUTME: Automated codebase discovery commands for context tree building
# ABOUTME: Systematic analysis scripts to understand tech stack, architecture, and patterns

# Automated Codebase Discovery Commands

These commands provide systematic analysis to understand codebase structure when building a context tree. Run all sections to get a complete picture.

## Tech Stack Detection

```bash
# Language & Framework Detection
ls -la | grep -E "(pom.xml|build.gradle|package.json|requirements.txt|Gemfile|go.mod|Cargo.toml)"

# Ruby project
[ -f Gemfile ] && grep -E "(ruby |gem )" Gemfile | head -20
[ -f .ruby-version ] && cat .ruby-version

# Node.js project
[ -f package.json ] && cat package.json | grep -A 20 '"dependencies"'

# Java project
[ -f pom.xml ] && grep -A 5 "<dependencies>" pom.xml | head -30
[ -f build.gradle ] && grep "implementation\|compile" build.gradle | head -20

# Framework markers
find . -name "*.rb" -o -name "*.js" -o -name "*.java" | head -5 | xargs grep -h "^require\|^import\|^package" | grep -E "(rails|sinatra|express|spring|play)" | sort -u | head -10
```

## Database Detection

```bash
# Check for database configs
find config -name "*.yml" -o -name "*.rb" -o -name "*.conf" 2>/dev/null | xargs grep -i -E "(mysql|postgres|mongo|redis|elasticsearch|cassandra)" | head -20

# Check for database dependencies
[ -f Gemfile ] && grep -i -E "(mysql|postgres|mongo|redis|elasticsearch)" Gemfile
[ -f pom.xml ] && grep -i -E "(mysql|postgres|mongo|redis|elasticsearch|cassandra)" pom.xml
[ -f package.json ] && grep -i -E "(mysql|postgres|mongo|redis|elasticsearch)" package.json
```

## Directory Structure Analysis

```bash
# Top-level structure
tree -L 2 -d . 2>/dev/null || find . -maxdepth 2 -type d | head -30

# Key directories
ls -la app/ 2>/dev/null
ls -la src/ 2>/dev/null
ls -la config/ 2>/dev/null
ls -la spec/ test/ 2>/dev/null
```

## Entry Points & Routes

```bash
# Look for routes file
find . -name "routes.rb" -o -name "routes" -o -name "urls.py" -o -name "routes.*" | head -5

# Show sample routes
[ -f config/routes.rb ] && head -30 config/routes.rb
[ -f conf/routes ] && head -30 conf/routes

# Main entry points
find . -name "application.rb" -o -name "application_controller.rb" -o -name "app.js" -o -name "Application.java" -o -name "main.py" | head -10
```

## Pattern Detection

```bash
# Multi-Tenancy Detection
grep -r "orgid\|org_id\|tenant\|clientid\|client_id" --include="*.rb" --include="*.js" --include="*.py" --include="*.java" . | wc -l

# Show examples
grep -r "clientid\|tenant" --include="*.java" --include="*.rb" . | head -5

# Authentication Pattern
grep -r "session\|JWT\|authenticate\|login" --include="*.rb" --include="*.js" --include="*.java" . | grep -v test | head -10

# Architecture Pattern Detection
[ -d app/controllers ] && [ -d app/models ] && [ -d app/views ] && echo "MVC pattern detected"
ls -la | grep -E "(docker-compose|kubernetes|service)" && echo "Microservices indicators found"
```

## Existing Documentation Audit

```bash
# Find markdown files
find . -name "*.md" -type f | head -20

# Check README quality
[ -f README.md ] && echo "README exists ($(wc -l < README.md) lines)"

# Look for documentation references
grep -r "wiki\|confluence\|documentation" --include="*.md" . | head -10
```

## Build & Test Setup

```bash
# Build system detection
ls -la | grep -E "(Makefile|Rakefile|Gemfile|package.json|pom.xml|build.gradle)"

# Test framework detection
find . -name "*_spec.rb" -o -name "*test.js" -o -name "test_*.py" -o -name "*Test.java" | head -5
[ -d spec ] && echo "Spec directory found" && ls spec/
[ -d test ] && echo "Test directory found" && ls test/
```

## Reporting Results

After running discovery commands, announce findings in structured format:

```
I've analyzed the codebase:

Tech Stack:
- [Language + version]
- [Framework + version]
- [Database(s)]

Structure:
- [Architecture pattern]
- [Key directories]

Patterns Detected:
- [Multi-tenant? How?]
- [Auth pattern]
- [Monolith vs microservices]

Does this match your understanding?
```
