---
app: cline-code
quelle: "saschalagler/backups/20260906/workflows/02-cross-platform-knowledge-sync.md"
stand: 2026-09-06
tags: [spiegel, cline-code]
---

# Workflow: Cross-Platform Knowledge Sync

## 🎯 PURPOSE
Automatische Synchronisation von Wissen, Erkenntnissen und Patterns zwischen allen Agent-Plattformen (Hermes ↔ Cline ↔ Antigravity ↔ Gemini) zur Vermeidung von Wissensfragmentierung.

## 🔄 LOOP SPECIFICATION

### Trigger
**Event**: Neue relevante Erkenntnisse in einem Agent-System (Memory Update, wichtiges Coding Pattern, Troubleshooting-Lösung)

### Execution Steps (Fully Autonomous)

1. **Knowledge Detection**
   - Monitort Memory Updates in allen Systemen
   - Identifiziert "high-value" content (Lösungen, Patterns, Konfigurationen)
   - Klassifiziert nach Wichtigkeit und Relevanz

2. **Cross-Platform Mapping**
   - Hermes → Obsidian Second Brain (via `obsidian-second-brain` skill)
   - Cline Sessions → Agent Memory REST API (`localhost:3111/agentmemory/remember`)
   - Gemini Insights → Context7 (via MCP)
   - Antigravity Patterns → Alle Agenten (via Skill-Symlinks)

3. **Knowledge Transformation**
   - Adaptiert Format für Zielplattform
   - Erhält Metadaten (Quelle, Datum, Tags)
   - Verknüpft mit verwandtem Wissen

4. **Conflict Resolution**
   - Erkennt widersprüchliche Informationen
   - Automatische Merge-Strategie (neuester +权威ste)
   - Flaggt für manuelle Review bei kritischen Widersprüchen

5. **Distribution**
   - Push zu allen relevanten Agenten
   - Update von Search-Indices
   - Trigger für abhängige Workflows

### Brief (Checkpoint Content)
```markdown
## Knowledge Sync Summary - {TIMESTAMP}

**📚 Items Synced**: {count} items across {platforms} platforms
**🔄 Conflicts Resolved**: {count} automatic, {count} manual review needed
**🏷️ Tags Added**: {count} new knowledge tags

### High-Value Knowledge Synced
1. **[{category}]** {title} - {source} → {destinations}
   - Impact: {benefit}
   - Related: {linked items}

### Critical Conflicts (Manual Review)
- **[Conflict 1]**: {description} - [review link]
- **[Conflict 2]**: {description} - [review link]

### Knowledge Distribution Status
- ✅ Hermes → Obsidian: {count} items
- ✅ Cline → Agent Memory: {count} items  
- ✅ Gemini → Context7: {count} items
- ✅ Antigravity → All Agents: {count} items

**Next Auto-Sync**: {next_run_time}
```

### Checkpoint Decision
- **✓ Complete**: Alle synchronisiert, keine Konflikte
- **⚠️ Review Needed**: Manuelle Konfliktlösung erforderlich
- **🔧 Optimisation**: Vorschläge für bessere Klassifikation

## 🛠️ IMPLEMENTATION

### Required Skills
- `obsidian-second-brain` - Hermes → Obsidian Sync
- `agentmemory-rest-api` - Cline → Memory System
- `cline-session-history` - Cline Knowledge Extraction
- `context7-mcp` - Gemini → Context7 Integration
- `parallel-feature-development` - Multi-Agent Koordination

### Integration Points
```bash
# Hermes Memory Hook
~/.hermes/hooks/on_memory_update.sh → knowledge-sync

# Cline Session Hook  
~/.cline/hooks/post_session.sh → knowledge-sync

# Gemini API Webhook (optional)
POST /gemini/knowledge-sync → knowledge-sync
```

### Knowledge Classification
```python
HIGH_VALUE = [
    "troubleshooting_solutions",
    "architecture_decisions", 
    "security_patches",
    "performance_optimizations",
    "api_integration_patterns"
]

MEDIUM_VALUE = [
    "code_snippets",
    "configuration_examples",
    "debugging_techniques"
]
```

## 📊 SUCCESS METRICS
- **Sync coverage**: > 95% wertvoller Inhalte synchronisiert
- **Conflict accuracy**: < 2% fälschliche Konflikte
- **Cross-platform utility**: Agenten nutzen synchronisiertes Wissen
- **Memory efficiency**: Keine Duplikate, intelligente Deduplizierung

## 🔧 TROUBLESHOOTING
- **Sync failures**: Check API-Keys und MCP-Verbindungen
- **Corrupt knowledge**: Rollback via git + Re-sync
- **Performance issues**: Rate limiting, Batch-Processing optimieren
- **Platform offline**: Queue für späteres Sync speichern

## 🎯 USE CASES
1. **Troubleshooting**: Lösung in einem Agent, verfügbar für alle
2. **Patterns**: Coding-Patterns cross-platform verfügbar
3. **API Integration**: Auth-Flow einmalig, überall nutzbar
4. **Configuration**: Working Configs werden Knowledge Assets

---
*Created: 2025-08-12*
*Last Updated: 2025-08-12*
*Version: 1.0*