# Week 7 Lab: AI System Audit Exercise

## Lab Overview

**Duration:** 3-4 hours  
**Difficulty:** Advanced  
**Prerequisites:** Completion of Modules 7.1-7.4

## Learning Objectives

By completing this lab, you will:
- Conduct a simulated AI system audit
- Apply the 5 C's framework to document findings
- Practice audit planning and execution
- Develop audit workpapers
- Write professional audit findings

## Scenario

You are an external auditor hired by **MedTech Solutions**, a healthcare technology company that has deployed an AI-powered clinical decision support system called **DiagnosticAI**.

### System Overview: DiagnosticAI

**Purpose:** Assist physicians in diagnosing diseases based on patient symptoms, lab results, and medical history.

**Technical Details:**
- **Model Type:** Ensemble of gradient boosting and neural networks
- **Training Data:** 500,000 anonymized patient records
- **Deployment:** Cloud-based SaaS, 50 hospital clients
- **Decisions:** Suggests top 3 most likely diagnoses with confidence scores
- **Usage:** 10,000 diagnostic suggestions per day
- **Regulatory Status:** FDA Class II medical device (510(k) cleared)

### Audit Trigger

Your audit was triggered by:
1. **Regulatory requirement:** FDA post-market surveillance audit due
2. **Internal concerns:** Clinical staff reporting occasional "strange" recommendations
3. **Compliance gap:** Company realizes they lack comprehensive AI governance

### Your Task

Conduct a focused audit covering:
1. Model validation and testing
2. Data governance
3. Monitoring and performance tracking
4. Regulatory compliance (FDA requirements)
5. Fairness and bias assessment

---

## Lab Activities

### Activity 1: Audit Planning (45 minutes)

#### Task 1.1: Define Audit Scope

Create an audit scope statement that includes:
- **Objectives:** What are you trying to assess?
- **In Scope:** What will you audit?
- **Out of Scope:** What won't you audit?
- **Period Covered:** What timeframe?
- **Stakeholders:** Who will you interview?

**Template:**
```markdown
## Audit Scope Statement

**Audit Name:** DiagnosticAI System Audit

**Audit Objectives:**
1. [Objective 1]
2. [Objective 2]
3. [Objective 3]

**In Scope:**
- ✅ [System/process 1]
- ✅ [System/process 2]

**Out of Scope:**
- ❌ [System/process 1]
- ❌ [System/process 2]

**Audit Period:** [Date range]

**Key Stakeholders:**
- [Role 1] - [Name/Title]
- [Role 2] - [Name/Title]
```

#### Task 1.2: Develop Audit Test Plan

Create a test plan for one audit objective. Include:
- Test procedures
- Evidence to collect
- Sample size
- Pass/fail criteria

**Example Format:**
```markdown
## Test Area: Model Validation

**Objective:** Assess whether independent model validation was performed per FDA guidance

**Test Procedures:**
1. Request independent validation report
2. Verify validator independence
3. Review validation scope and methodology
4. Assess validation findings and management responses

**Evidence Required:**
- [ ] Independent validation report
- [ ] Validator qualifications and independence documentation
- [ ] Management responses to validation findings
- [ ] Interview notes with validator and model owner

**Sample Size:** Census (all validation documentation)

**Pass Criteria:**
- Independent validation completed before deployment
- Validator meets independence criteria
- Validation covered all FDA requirements
- Material findings addressed before production

**Fail Criteria:**
- No validation performed OR
- Validation not independent OR
- Critical findings not addressed
```

**Your Turn:** Create a test plan for **Data Governance**.

---

### Activity 2: Evidence Collection (60 minutes)

You're provided with simulated evidence from MedTech Solutions. Review and document your observations.

#### Evidence Package 1: Model Validation

**Provided Documents:**
```
VALIDATION REPORT - DiagnosticAI v2.1
Prepared by: John Smith, Senior Data Scientist
Date: March 15, 2024

Summary:
We conducted comprehensive testing of DiagnosticAI v2.1 prior to deployment.

Testing Methodology:
- Used hold-out test set of 10,000 patient records
- Calculated accuracy, precision, recall
- Compared to previous model version

Results:
- Overall accuracy: 87.3%
- Precision: 85.1%
- Recall: 89.4%
- Performance improved 2.1% vs. v2.0

Recommendation: Deploy to production.

Signed: John Smith, Data Science Team Lead
```

**Interview Notes:**
```
Interview with Sarah Chen, VP of Product
Q: "Who performed the model validation?"
A: "Our data science team. John Smith led it. He's very thorough."

Q: "Was there any independent validation?"
A: "Well, John reports to me, not to the development team lead, so there's some independence there."

Q: "Has an external party ever validated the model?"
A: "No, we haven't had the budget for that. But our team is highly qualified."
```

**Your Task:** Analyze this evidence

1. **Is there a finding here?** Yes / No

2. **If yes, document using 5 C's:**

**CONDITION (What Is):**
[What did you observe?]

**CRITERIA (What Should Be):**
[What is the requirement/standard?]

**CAUSE (Why the Gap):**
[Why doesn't reality meet criteria?]

**CONSEQUENCE (Impact):**
[What could happen because of this?]

**RECOMMENDATION (Corrective Action):**
[What should be done?]

3. **Classify Severity:** Critical / High / Medium / Low

4. **Supporting Evidence:**
- [Evidence item 1]
- [Evidence item 2]

---

#### Evidence Package 2: Fairness Testing

**Provided Documents:**
```
PERFORMANCE TESTING REPORT
DiagnosticAI v2.1

Overall Performance:
- Accuracy: 87.3%
- False Positive Rate: 6.2%
- False Negative Rate: 6.5%

Top Conditions Diagnosed:
1. Diabetes (accuracy: 92%)
2. Hypertension (accuracy: 91%)
3. Pneumonia (accuracy: 88%)
[... 20 more conditions ...]

Conclusion: Model meets performance targets.
```

**Interview Notes:**
```
Interview with Dr. Lisa Rodriguez, Chief Medical Officer
Q: "Have you tested the model's performance across different patient demographics?"
A: "What do you mean by demographics?"

Q: "For example, does it perform equally well for men and women? Different age groups? Different ethnicities?"
A: "Hmm, I don't think we've looked at that specifically. The overall accuracy is good though."

Q: "Do you have demographic data in your training data?"
A: "Yes, the patient records include age, gender, and race."

Q: "But you haven't analyzed if the model performs differently for different groups?"
A: "No, I don't think so. Should we have?"
```

**Your Task:** 

1. Is there a finding? Document using 5 C's framework.

2. What specific fairness tests should have been performed?

3. What are the regulatory implications (hint: FDA guidance on bias)?

---

#### Evidence Package 3: Ongoing Monitoring

**Provided Documents:**
```
Email Subject: Monthly DiagnosticAI Stats
From: John Smith
To: Sarah Chen
Date: June 1, 2024

Hi Sarah,

Here are this month's stats:

- Uptime: 99.8%
- Queries: 312,450
- Avg response time: 1.2 seconds

Everything looks good!

John
```

**Interview Notes:**
```
Interview with John Smith, Data Science Team Lead
Q: "How do you monitor the model's accuracy in production?"
A: "We track uptime and response time. Performance has been stable."

Q: "Do you track prediction accuracy? Compare predictions to actual diagnoses?"
A: "That's tricky because we don't always get feedback on whether our suggestions were correct. Doctors don't report back."

Q: "Do you have any mechanism to collect that feedback?"
A: "Not systematically, no."

Q: "What if the model's accuracy degrades over time?"
A: "The model was well-tested, so we don't expect that to happen."
```

**Your Task:**

1. What's missing from their monitoring approach?

2. Document the finding using 5 C's.

3. What specific monitoring practices should they implement?

---

### Activity 3: Finding Development (60 minutes)

#### Task 3.1: Prioritize Findings

You've identified multiple findings. Prioritize them:

**Identified Issues:**
1. No independent validation
2. No fairness/bias testing
3. Inadequate ongoing monitoring
4. Incomplete documentation
5. No formal governance structure

**Your Task:** Create a finding priority matrix

| Finding | Regulatory Risk | Clinical Impact | Likelihood | Overall Priority |
|---------|----------------|-----------------|------------|------------------|
| No independent validation | High/Med/Low | High/Med/Low | High/Med/Low | Critical/High/Med/Low |
| [Add others...] | | | | |

#### Task 3.2: Write One Complete Finding

Choose your highest priority finding and write a complete audit finding:

**Template:**
```markdown
# FINDING F-001: [Title]

## Classification
**Severity:** 🔴 Critical / ⚠️ High / ⚠️ Medium / ℹ️ Low
**Category:** [Model Risk / Compliance / Data Governance / etc.]
**Regulation:** [FDA / HIPAA / etc. if applicable]

## Finding Details (5 C's)

### CONDITION (What Is)
[Describe current state - what you observed]

### CRITERIA (What Should Be)
[Cite specific requirements]
- Regulation/Standard reference
- Specific requirement text
- Why this requirement exists

### CAUSE (Why the Gap)
[Root cause analysis]
- Why doesn't the organization meet the criteria?
- Contributing factors?

### CONSEQUENCE (Impact)
[What could happen if not fixed?]
**Immediate Impacts:**
- [Impact 1]
- [Impact 2]

**Long-term Risks:**
- [Risk 1]
- [Risk 2]

**Estimated Financial Impact:** [If quantifiable]

### RECOMMENDATION (Corrective Action)
**Immediate Actions (0-30 days):**
1. [Action 1]
2. [Action 2]

**Short-term Actions (31-90 days):**
1. [Action 1]
2. [Action 2]

**Long-term Actions (90+ days):**
1. [Action 1]
2. [Action 2]

## Supporting Evidence
- [Evidence item 1 - document name, page, etc.]
- [Evidence item 2 - interview note, date, quote]
- [Evidence item 3 - observation, test result, etc.]

## Management Response
[Leave blank for management to complete]
**Concur / Partially Concur / Do Not Concur**  
**Planned Actions:**  
**Responsible Party:**  
**Target Completion:**  
```

---

### Activity 4: Audit Report Summary (45 minutes)

#### Task 4.1: Write Executive Summary

Create a 1-page executive summary of your audit:

**Template:**
```markdown
# AUDIT EXECUTIVE SUMMARY
## DiagnosticAI System Audit

**Audit Date:** [Date]
**Auditor:** [Your Name]
**Report Date:** [Date]

### Overall Opinion
[Overall assessment: Satisfactory / Needs Improvement / Unsatisfactory]

### Key Findings Summary
- 🔴 Critical: [Number]
- ⚠️ High: [Number]
- ⚠️ Medium: [Number]
- ℹ️ Low: [Number]

### Critical Findings
1. **[Finding Title]** - [One sentence summary]
2. **[Finding Title]** - [One sentence summary]

### Risk Assessment
**Regulatory Compliance:** [High/Medium/Low Risk]
**Patient Safety:** [High/Medium/Low Risk]
**Operational:** [High/Medium/Low Risk]

### Required Actions
**Immediate (Critical):**
- [Action 1]
- [Action 2]

**Short-term (High Priority):**
- [Action 1]
- [Action 2]

### Overall Conclusion
[2-3 sentences summarizing the state of AI governance and whether the system should continue operating]
```

#### Task 4.2: Create Audit Presentation

Create a 5-slide presentation for senior management:

**Slide 1: Audit Overview**
- Scope
- Methodology
- Timeline

**Slide 2: Key Findings**
- Finding summary (by severity)
- Heat map or dashboard

**Slide 3: Critical Finding Detail**
- Pick one critical finding
- Explain impact
- Show evidence

**Slide 4: Recommendations**
- Prioritized action plan
- Timeline
- Resources needed

**Slide 5: Next Steps**
- Management response due date
- Follow-up audit timing
- Questions

---

## Lab Deliverables

Submit the following:

1. **Audit Planning Documents** (Word/PDF)
   - Audit scope statement
   - Test plan for data governance

2. **Findings Workpapers** (Word/PDF)
   - Analysis of all 3 evidence packages
   - At least 3 complete findings using 5 C's framework
   - Finding priority matrix

3. **Audit Report** (Word/PDF)
   - Executive summary (1 page)
   - Detailed findings (3-5 pages)

4. **Audit Presentation** (PowerPoint)
   - 5 slides as specified

---

## Evaluation Rubric

| Component | Points | Criteria |
|-----------|--------|----------|
| Audit Planning | 20 | Clear scope, comprehensive test plan |
| Evidence Analysis | 30 | Thorough analysis, correct identification of issues |
| Findings Documentation | 30 | Complete 5 C's framework, appropriate severity |
| Executive Summary | 10 | Clear, concise, decision-ready |
| Presentation | 10 | Professional, clear, compelling |
| **Total** | **100** | **Passing: 70 points** |

---

## Additional Resources

**FDA Guidance:**
- Clinical Decision Support Software (2022)
- Software Validation Guidance
- Postmarket Surveillance Guidance

**Audit Standards:**
- IIA Standards for Internal Auditing
- ISO 19011 Audit Guidelines
- ISACA IT Audit Framework

**AI Governance:**
- NIST AI Risk Management Framework
- SR 11-7 Model Risk Management
- WHO AI Ethics Guidance for Healthcare

---

## Tips for Success

✅ **DO:**
- Be objective and fact-based
- Use specific evidence to support findings
- Consider both technical and business impacts
- Write clearly for non-technical executives
- Prioritize based on risk

❌ **DON'T:**
- Make personal attacks or judge intent
- Include opinions without evidence
- Overwhelm with technical jargon
- Ignore business context
- Treat all findings as equal priority

---

## Bonus Challenge (Optional)

**Advanced Exercise:** Your audit reveals that patients diagnosed by doctors who used DiagnosticAI have better outcomes than those diagnosed without it. However, the system still has the validation and monitoring gaps you identified.  

**Question:** How does this impact your findings and recommendations? Should the system continue to be used while improvements are made? Document your reasoning.

---

*Lab Version 1.0 | Last Updated: January 2025*