# Workflow: Multi-Agent Status Check Loop

## 🎯 PURPOSE
Täglicher automatisierter Check aller Agent-Systeme, Services und Projekte mit **Push-Right Checkpoint** - maximal automatisiert, minimal menschliches Eingreifen.

## 🔄 LOOP SPECIFICATION

### Trigger
**Schedule**: Täglich 08:00 (oder manuell via `/status-check`)

### Execution Steps (Autonomous)

1. **System Health Check**
   - Hermes Gateway Status (`launchctl list ai.hermes.gateway`)
   - Docker MCP Gateway Profile Status
   - Loki OS Master Kernel (`curl http://localhost:8010/health`)
   - Antigravity PWA (`curl http://localhost:8081`)
   - Cali Atlas (`curl https://atlas-cali-coach-.../health`)

2. **Agent Activity Summary**
   - Letzte Cline Sessions (via `cline-session-history` skill)
   - Hermes Memory Updates (via `obsidian-second-brain`)
   - Agent Memory REST API Status (`localhost:3111/agentmemory/livez`)

3. **Project Status Dashboard**
   - Loki OS Entwicklung (git status, letzter commit)
   - Cali Atlas Deployment Status (GCP)
   - Antigravity Cloud Functions Status
   - Wichtige Issues/Pull Requests

4. **Resource & Capacity Check**
   - Docker Container Status (`docker ps`)
   - Disk Space auf kritischen Pfaden
   - API Quotas (Gemini, Claude, OpenRouter)

5. **Knowledge Base Sync Status**
   - Obsidian Vault Updates
   - Second Brain Consistency Check
   - Cross-Agent Knowledge Gaps

### Brief (Checkpoint Content)
```markdown
## Multi-Agent Status - {DATE}

**🟢 Systems Healthy**: {count}/{total} systems up
**🟡 Warnings**: {list}
**🔴 Critical Issues**: {list}

### Active Projects
- **Loki OS**: {status} - {last activity}
- **Cali Atlas**: {status} - {deployment status}
- **Antigravity**: {status} - {issues}

### Memory & Learning
- **Hermes**: {entries} new memories
- **Obsidian**: {updates} vault updates
- **Agent Memory**: {items} indexed

### Recommended Actions
1. [Link to detailed report]
2. [Action item 1]
3. [Action item 2]

**Full Report**: /tmp/multi-agent-status-{date}.md
```

### Checkpoint Decision
- **✓ Continue**: Keine kritischen Issues
- **🔍 Review**: Warnings vorhanden, manuelle Prüfung empfohlen
- **🚨 Action Needed**: Kritische Issues erfordern sofortiges Eingreifen

## 🛠️ IMPLEMENTATION

### Required Skills
- `cline-session-history` - Cline Aktivitäten
- `obsidian-second-brain` - Knowledge Base Status
- `agentmemory-rest-api` - Memory System Check
- `desktop-commander-overview` - Systemübergreifende Checks
- `managing-skills` - Skill-Management

### Cron Schedule (Hermes)
```bash
0 8 * * * /path/to/multi-agent-status-check.sh
```

### Manual Trigger
```bash
/status-check
```

## 📊 SUCCESS METRICS
- **Daily uptime**: Alle Systeme grün
- **Response time**: < 30 Sekunden für vollständigen Check
- **False positives**: < 5% über 30 Tage
- **Human intervention**: Nur bei echten Problemen

## 🔧 TROUBLESHOOTING
- **Hermes offline**: Check launchctl status → restart via `launchctl load`
- **Docker MCP down**: `docker mcp gateway restart --profile ai_coding`
- **Memory API down**: `pkill -f agentmemory && cd agentmemory && npm start`
- **Git conflicts**: Automatischer `git stash` + Warning in Brief

---
*Created: 2025-08-12*
*Last Updated: 2025-08-12*
*Version: 1.0*