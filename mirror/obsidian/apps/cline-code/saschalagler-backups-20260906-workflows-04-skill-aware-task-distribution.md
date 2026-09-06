---
app: cline-code
quelle: "saschalagler/backups/20260906/workflows/04-skill-aware-task-distribution.md"
stand: 2026-09-06
tags: [spiegel, cline-code]
---

# Workflow: Skill-Aware Task Distribution

## 🎯 PURPOSE
Intelligente Verteilung von Aufgaben an die optimalen Agenten basierend auf deren Skills, Workload und Historische Performance - maximale Effizienz durch **Right Agent, Right Task**.

## 🔄 LOOP SPECIFICATION

### Trigger
**Event**: Neue Aufgabe eingegeben via `/task create` oder automatische Erkennung

### Execution Steps (Fully Autonomous with Fallback)

1. **Task Analysis & Classification**
   - Natural Language Parsing der Aufgabe
   - Kategorisierung: Frontend, Backend, DevOps, Design, Research, Testing
   - Komplexitäts-Einschätzung (Low, Medium, High)
   - Skill-Anforderungen extrahieren

2. **Agent Capability Matching**
   - Prüft verfügbare Skills in jedem Agenten (via `managing-skills`)
   - Historische Performance für ähnliche Tasks
   - Aktueller Workload und Verfügbarkeit
   - Plattform-Kompatibilität (z.B. iOS Tasks nur an iOS-fähige Agenten)

3. **Skill-Score Calculation**
   ```python
   score = (skill_match * 0.4) + (performance_history * 0.3) + 
            (availability * 0.2) + (platform_fit * 0.1)
   ```

4. **Distribution Strategy**
   - **Single Agent**: Hoher Score > 0.8, einfache Task
   - **Parallel Execution**: Unabhängige Subtasks, Multi-Agent capability
   - **Sequential Handoff**: Komplexe Tasks mit spezialisierten Phasen
   - **Collaborative**: Gleichzeitige Bearbeitung mit Coordination

5. **Agent Assignment & Handoff**
   - Erstellt Task-Spezifikation für jeden Agenten
   - Setzt Dependencies zwischen Subtasks
   - Initialisiert Handoff-Prozess
   - Monitoring Setup

### Brief (Checkpoint Content)
```markdown
## Task Distribution Complete: {TASK_ID}

**🎯 Task**: {task_description}
**🤖 Assigned Agents**: {count} agents
**⚡ Distribution Strategy**: {strategy}

### Agent Assignments

1. **[{agent_name}]** - {subtask}
   - **Skills Used**: {matched_skills}
   - **Score**: {score}/1.0
   - **Est. Duration**: {time_estimate}
   - **Dependencies**: {depends_on}

2. **[{agent_name}]** - {subtask}
   - **Skills Used**: {matched_skills}
   - **Score**: {score}/1.0
   - **Est. Duration**: {time_estimate}
   - **Dependencies**: {depends_on}

### Distribution Rationale
**Primary Factor**: {dominant_factor} (e.g., skill matching)
**Secondary Factors**: {other_factors}

### Execution Plan
- **Start**: {start_time}
- **Milestones**: {milestone_timeline}
- **Expected Completion**: {completion_time}

### Monitoring
**Progress Tracking**: [link to dashboard]
**Fallback Strategy**: {backup_plan}
**Escalation Threshold**: {time/quality limits}

**Review Assignment**: [adjust agents] | [proceed with execution]
```

### Checkpoint Decision
- **▶️ Execute**: Start mit aktueller Zuweisung
- **🔄 Adjust**: Agenten ändern oder Strategy anpassen
- **⏸️ Hold**: Task zurückhalten, zusätzliche Infos benötigt

## 🛠️ IMPLEMENTATION

### Required Skills
- `managing-skills` - Skill-Discovery & Capability Analysis
- `parallel-feature-development` - Multi-Agent Koordination
- `cline-session-history` - Performance Historie
- `claude-automation-recommender` - Automatische Erkennung von Wiederholungen

### Agent Capability Matrix
```python
AGENT_SKILLS = {
    "cline": {
        "core": ["frontend-design", "backend-development", "fullstack"],
        "specialized": ["react", "next.js", "typescript", "testing"],
        "performance": 0.85,
        "availability": "high"
    },
    "hermes": {
        "core": ["learning", "coordination", "automation"],
        "specialized": ["multi-platform", "memory_management", "scheduling"],
        "performance": 0.92,
        "availability": "medium"
    },
    "gemini": {
        "core": ["multimodal", "vision", "code_understanding"],
        "specialized": ["api_integration", "data_analysis", "live_interaction"],
        "performance": 0.88,
        "availability": "high"
    }
}
```

### Distribution Strategies
```python
STRATEGIES = {
    "single_agent": "Simple task, one capable agent",
    "parallel_execution": "Independent subtasks, multiple agents",
    "sequential_handoff": "Phased approach, specialist handoffs",
    "collaborative": "Simultaneous work with coordination",
    "hierarchical": "Main agent with sub-agent delegation"
}
```

## 📊 SUCCESS METRICS
- **Task completion time**: < 80% von geschätzter Zeit
- **First-time success**: > 90% ohne Re-Assignment
- **Agent utilization**: Balancierte Auslastung (+/- 20%)
- **Skill coverage**: Alle Tasks mit passenden Skills

## 🔧 TROUBLESHOOTING
- **No capable agents**: Fallback zu menschlicher Zuweisung + Skill Training
- **Performance below threshold**: Re-Evaluation der Skill-Scores
- **Agent unavailable**: Automatische Re-Distribution
- **Dependencies failing**: Escalation zu menschlichem Review

## 🎯 USE CASES
1. **Full Feature Development**: Frontend + Backend + Testing parallel
2. **Bug Investigation**: Research → Reproduction → Fix → Test
3. **API Integration**: Authentication → Implementation → Documentation
4. **Performance Optimization**: Analysis → Profiling → Optimization → Validation

---
*Created: 2025-08-12*
*Last Updated: 2025-08-12*
*Version: 1.0*