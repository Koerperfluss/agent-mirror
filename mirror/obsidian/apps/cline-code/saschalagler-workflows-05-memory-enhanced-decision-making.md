---
app: cline-code
quelle: "saschalagler/workflows/05-memory-enhanced-decision-making.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# Workflow: Memory-Enhanced Decision Making

## 🎯 PURPOSE
Entscheidungsfindung auf Basis von **cross-platform memory** - nutzt Wissen aus Hermes Learning, Cline Sessions, Obsidian Second Brain und Agent Memory für fundierte, kontextbewusste Entscheidungen.

## 🔄 LOOP SPECIFICATION

### Trigger
**Event**: Entscheidungspunkt erreicht, komplexe Wahl erforderlich, `/decide` Kommando

### Execution Steps (Autonomous Research, Human Decision)

1. **Context Gathering** (Autonomous)
   - Analysiert aktuelle Situation und Entscheidungskontext
   - Identifiziert Entscheidungstyp (technisch, strategisch, prioritäts-basiert)
   - Extrahiert verfügbare Optionen und Constraints

2. **Memory Query** (Autonomous)
   - **Hermes Memory**: Ähnliche vergangene Entscheidungen + Outcomes
   - **Cline Sessions**: Coding-Decisions mit Performance-Daten
   - **Obsidian Second Brain**: Strategische Entscheidungen + Dokumentation
   - **Agent Memory REST API**: Prozedurales Wissen + Best Practices

3. **Knowledge Synthesis** (Autonomous)
   - Konsolidiert Informationen aus allen Quellen
   - Identifiziert Muster und Trends
   - Berechnet Risiken und Benefits basierend auf Historie

### Brief (Checkpoint Content)
```markdown
## Decision Recommendation: {DECISION_TITLE}

**🎯 Context**: {situation_description}
**⚖️ Decision Type**: {type} (technical/strategic/priority)
**📚 Knowledge Sources**: {count} sources queried

### Analysis Summary
**Historical Patterns**: {key_findings_from_memory}
**Risk Factors**: {identified_risks}
**Success Predictors**: {positive_indicators}

### Options Ranked
**🥇 RECOMMENDED: Option 1 - {option_title}**
- **Score**: {score}/100
- **Pros**: {key_benefits}
- **Cons**: {key_drawbacks}
- **Risk Level**: {risk_level}
- **Historical Success**: {success_rate}%

### Recommended Action
**Choose**: Option 1 - {brief_justification}
**Timeline**: {implementation_timeline}
**Next Steps**: {immediate_actions}
```

## 🛠️ IMPLEMENTATION

### Required Skills
- `obsidian-second-brain` - Strategisches Wissen
- `cline-session-history` - Coding-Decisions & Performance  
- `agentmemory-rest-api` - Prozedurales Wissen & Best Practices
- `claude-automation-recommender` - Pattern-Erkennung

---
*Created: 2025-08-12*
*Version: 1.0*