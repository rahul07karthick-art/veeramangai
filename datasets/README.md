# VEERAMANGAI dataset note

## Model training data: none

VEERA currently calls Gemini through a stateless server-side request. No model was trained or fine-tuned for this prototype, so there is no training dataset to provide. The app does not use athlete records, menstrual-cycle logs, symptom notes, voice recordings, or private training plans as model-training data.

The CSV in this folder is an **empty ingestion template**, not a dataset and not model training material. It describes the public opportunity catalogue that the agent may retrieve at answer time. Populate it only with current notices whose source and reuse are permitted. A human should verify each provider, eligibility, benefit, deadline, and official link; then record `verified_at` and set `status=verified`. Retire expired or corrected notices promptly.

Preferred source types: Tamil Nadu Sports Development Authority and district sports offices; Ministry of Youth Affairs and Sports / Khelo India; official competition federations and organizers; registered NGOs and foundations; and official company CSR or athlete-support pages. Each row must link directly to its provider's notice. Never scrape personal athlete routines or include financial identifiers, contact details, or health information.

The agent receives a small set of verified public catalogue rows as context for a single request. Chat and catalogue lookups are not saved by VEERA's code. Provider processing and retention still depend on the configured Gemini/Sarvam account and contract; review those terms before real athlete use.
