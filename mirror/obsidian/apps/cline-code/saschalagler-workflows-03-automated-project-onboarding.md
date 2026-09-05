---
app: cline-code
quelle: "saschalagler/workflows/03-automated-project-onboarding.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# Workflow: Automated Project Onboarding

## 🎯 PURPOSE
Vollautomatisches Einrichten neuer Projekte mit kompletter Multi-Agent-Infrastruktur, Repository-Setup, MCP-Konfiguration und Initial-Workflows in < 10 Minuten.

## 🔄 LOOP SPECIFICATION

### Trigger
**Event**: Neues Projekt gestartet via `/project new` oder Repository erkannt

### Execution Steps (Interactive Start, Autonomous Finish)

1. **Project Discovery** (Checkpoint 1 - User Input)
   - Projektname und Beschreibung
   - Technologie-Stack (auto-detected wenn möglich)
   - Zielplattform (Web, Mobile, Desktop, API)
   - Team-Mitglieder und Rollen

2. **Repository Setup** (Autonomous)
   - Git Repository initialisieren oder clonen
   - Branch-Struktur erstellen (`main`, `develop`, `feature/*`)
   - Initial-Commit mit Projektstruktur
   - CI/CD Pipeline Setup (GitHub Actions, GCP)

3. **Multi-Agent Configuration** (Autonomous)
   - **Cline**: `.clinerules` erstellen, Skill-Symlinks einrichten
   - **Hermes**: Projekt-spezifische Memory-Konfiguration
   - **Antigravity**: MCP-Server für Projekt hinzufügen
   - **Gemini**: Projekt-spezifische API-Konfiguration

4. **Infrastructure Setup** (Autonomous)
   - Docker-Konfiguration (falls benötigt)
   - Environment-Variablen Template (`.env.example`)
   - Datenbank-Schema (falls Backend)
   - API-Endpoints Struktur (falls API)

5. **Knowledge Base Integration** (Autonomous)
   - Obsidian Projekt-Seite erstellen
   - Context7 Index initialisieren
   - Agent Memory Categories einrichten
   - Project-Dokumentation in alle Systeme pushen

6. **Workflow Templates** (Autonomous)
   - Development Loop installieren
   - Deployment Workflow einrichten
   - Testing Strategy konfigurieren
   - Code Review Process setup

### Brief (Checkpoint Content)
```markdown
## Project Onboarding Complete: {PROJECT_NAME}

**🚀 Ready to Develop**: Full Multi-Agent Stack configured
**⏱️ Setup Time**: {duration} (target: < 10 min)
**🔧 Systems Configured**: {count}/{total} platforms

### Infrastructure Ready
- ✅ **Repository**: {repo_url} - {branch_structure}
- ✅ **CI/CD**: {ci_cd_provider} configured
- ✅ **Environment**: {env_setup} ready

### Multi-Agent Integration
- ✅ **Cline**: {skills} skills activated
- ✅ **Hermes**: Memory categories configured
- ✅ **Antigravity**: MCP servers active
- ✅ **Gemini**: API integration ready

### Workflows Active
- ✅ Development Loop: {status}
- ✅ Deployment: {status}
- ✅ Testing: {status}
- ✅ Code Review: {status}

### Knowledge Base
- ✅ **Obsidian**: {vault_path}/projects/{project_slug}.md
- ✅ **Context7**: {index_status}
- ✅ **Agent Memory**: {categories} categories

### Next Steps
1. **Start Development**: `cd {project_path} && cline`
2. **First Feature**: `/brainstorming` → `/implement`
3. **Team Onboarding**: Share project documentation

**Project Dashboard**: [link to internal dashboard]
```

### Checkpoint Decision
- **🚀 Start Development**: Alles bereit, kann sofort beginnen
- **⚙️ Configuration Needed**: Feinabstimmung erforderlich
- **🔴 Critical Issues**: Blockierende Probleme müssen gelöst werden

## 🛠️ IMPLEMENTATION

### Required Skills
- `projects` - Projekt Management
- `managing-skills` - Skill-Konfiguration
- `parallel-feature-development` - Workflow Setup
- `backend-development` / `frontend-design` - Stack-spezifisches Setup
- `obsidian-second-brain` - Knowledge Base Integration

### Technology Stack Templates
```yaml
web_modern:
  repos: main, develop, feature/*, hotfix/*
  ci_cd: github_actions + vercel_deploy
  agents: cline + antigravity + hermes
  mcp: fs-sync + macos-terminal + context7
  
mobile_swift:
  repos: main, develop, feature/*, release/*
  ci_cd: github_actions + testflight
  agents: ios-swift-development + developing-ios-apps
  mcp: xcode-tools + filesystem
  
api_python:
  repos: main, develop, feature/*, chore/*
  ci_cd: github_actions + gcp_cloud_functions
  agents: backend-development + claude-automation-recommender
  mcp: python-tools + firestore + logging
```

### Automated Configuration Files
```
{project}/
├── .clinerules (Cline-spezifisch)
├── .github/workflows/ (CI/CD)
├── .hermes/project-config.json (Hermes)
├── .env.example (Environment)
├── docs/ (Dokumentation)
└── workflows/ (Projekt-spezifische Workflows)
```

## 📊 SUCCESS METRICS
- **Setup time**: < 10 Minuten für Standard-Projekte
- **Success rate**: > 95% ohne manuelle Intervention
- **Agent readiness**: Alle Agenten können sofort arbeiten
- **Knowledge integration**: 100% Projekt-Infos in Knowledge Base

## 🔧 TROUBLESHOOTING
- **Git failures**: SSH-Key Issues, Permissions
- **MCP connection**: Docker Profile nicht verfügbar, Fallback zu lokalen Servern
- **API limits**: Quota exceeded, Warnung an User
- **Template mismatch**: Manuelle Anpassung erforderlich

## 🎯 USE CASES
1. **New Web App**: React/Next.js + Node.js + Firebase
2. **Mobile App**: Swift/SwiftUI + XcodeGen
3. **API Service**: Python/FastAPI + GCP Cloud Functions
4. **Microservice**: Docker + Kubernetes + Multi-Agent Monitoring

---
*Created: 2025-08-12*
*Last Updated: 2025-08-12*
*Version: 1.0*