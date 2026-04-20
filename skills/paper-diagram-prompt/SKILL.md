---
name: paper-diagram-prompt
description: Generates detailed English prompts for Gemini (or other image-generation models) to draw publication-quality architecture diagrams in the style of top-tier ML/AI conference papers (NeurIPS, CVPR, ICCV, ICML, ECCV, ACL, etc.). Use this skill whenever the user wants to visualize a model architecture, pipeline, framework, or method as a figure — even if they say "draw a diagram", "make a figure", "create a flowchart for my paper", "generate an architecture figure", or just describe their method and want a visual. Always activate when the user mentions paper figures, model diagrams, or architecture visualization.
---

# Paper Diagram Prompt Generator

You help researchers communicate their methods visually. Given a description of a model, pipeline, or framework, you produce a detailed English prompt that instructs Gemini (or similar) to generate a clean, publication-ready architecture diagram matching the visual conventions of top ML conference papers.

## Visual Style Reference

The target aesthetic is the standard figure style seen in NeurIPS / CVPR / ICCV / ICML papers:

**Layout**
- White background, generous whitespace
- Multi-panel layout: large dashed-border boxes group related sub-modules (e.g., "A. Training", "B. Inference")
- Sub-panels labeled with bold letters: **A.**, **B.**, **C.** … in the top-left corner
- Left-to-right or top-to-bottom information flow; arrows show data/gradient direction
- Legend in the bottom-left or right margin when node types vary

**Nodes**
- Rounded rectangles or plain rectangles for modules
- Soft pastel fills: light blue (#BDD7EE), light purple (#D9B3FF), light yellow (#FFF2CC), light pink (#FFD7D7), light green (#C6EFCE)
- White fill for "frozen" or secondary modules, sometimes with a lock icon
- Node labels: short, bold, math-style text (e.g., `z_t`, `ε_θ(z,t,c)`, `LDM: UNet`, `GNN(f_G)`)
- Subscripts and superscripts rendered as actual math notation, not plain text

**Edges**
- Thin black arrows (solid for forward pass, dashed for optional/skip connections)
- Arrow labels sparingly, only when the data type is non-obvious
- Red dots on connections to indicate trainable coupling points (e.g., ControlNet-style)

**Typography**
- Section titles: bold serif or sans-serif, 11–12pt equivalent
- Node labels: 9–10pt, math italic for variables
- Caption below the figure: "Figure N: …" in regular weight

**Color discipline**
- Each semantic role gets one consistent color across the whole figure
- Never use more than 4–5 fill colors total
- Borders are always dark gray or black, 1–1.5pt weight

---

## Your Workflow

### Step 0 — Parse the input (paper vs. direct description)

The user may provide input in two forms:

**Form A — Direct method description**: The user describes their model/pipeline in their own words. Proceed to Step 1 immediately.

**Form B — A paper (PDF, text, or URL)**: The user pastes paper content or attaches a PDF. In this case:

1. Read the paper thoroughly, focusing on: abstract, introduction, method/approach section, and any figure captions.
2. Extract the method structure:
   - Core contribution in one sentence
   - Main components and their roles
   - Data flow (inputs → intermediate representations → outputs)
   - Distinct phases (training / inference / pre-training / fine-tuning / etc.)
   - Loss functions and how they connect to modules
   - Any special mechanisms (attention, graph structure, iterative loops, frozen modules)
3. Write a brief **Method Summary** (3–5 bullet points) and show it to the user before proceeding. This confirms you understood the paper correctly.
4. Then continue to Step 1 using your extracted understanding — do not ask the user to re-describe what you already read.

If the paper is long or dense, focus on the section titled "Method", "Approach", "Model", or "Framework" and the main architecture figure caption.

### Step 1 — Understand the method

Ask the user (or extract from their description / paper) the following:

1. **What does the method do?** (one sentence)
2. **What are the main components / modules?** (list them)
3. **What is the data flow?** (input → … → output)
4. **Are there distinct phases?** (e.g., training vs. inference, encoder vs. decoder)
5. **Any special visual elements?** (frozen modules, loss functions, iterative loops, graphs/trees)
6. **Preferred layout?** (left-right / top-bottom / grid; number of panels)

If the user's description or the paper already answers most of these, proceed directly — don't ask redundant questions.

### Step 2 — Plan the layout

Before writing the prompt, sketch the panel structure in your response:

```
Panel A: [name] — [what it shows]
Panel B: [name] — [what it shows]
...
Data flow: X → Panel A → Panel B → Y
Color assignments: blue=encoder, purple=decoder, yellow=condition, pink=loss
```

Show this plan to the user briefly and confirm before generating the full prompt.

### Step 3 — Generate the Gemini prompt

Output a single, self-contained English prompt under the heading **`## Gemini Prompt`**. The prompt must:

- Open with the overall figure description and canvas spec (e.g., "Create a white-background architecture diagram at 2400×1200px…")
- Describe each panel in order, specifying: position, dashed border, bold label, internal nodes with colors and text, arrows with directions and labels
- Specify typography, line weights, and color hex codes explicitly
- End with a one-sentence style note: "The overall style should match figures in NeurIPS/CVPR papers — clean, minimal, academic."

Keep the prompt under 600 words. Gemini performs better with structured, specific instructions than with long prose.

---

## Prompt Template

Use this structure as your scaffold (fill in the `[…]` placeholders):

```
Create a white-background academic architecture diagram at [W]×[H]px, suitable for a [venue] paper figure.

OVERALL LAYOUT: [brief description of panel arrangement and data flow direction]

PANEL A — "[Panel Title]" (top-left, dashed border, bold label "A." in corner):
  - Node "[label]": [shape], fill [hex], text "[content]"
  - Node "[label]": [shape], fill [hex], text "[content]"
  - Arrow from "[src]" to "[dst]": solid black, labeled "[label if any]"
  [repeat for all nodes and edges]

PANEL B — "[Panel Title]" (top-right, dashed border, bold label "B." in corner):
  [...]

CONNECTIONS BETWEEN PANELS:
  - Arrow from Panel A output "[node]" to Panel B input "[node]": solid black

LEGEND (bottom-right, no border):
  - Light blue rectangle = [meaning]
  - Light purple rectangle = [meaning]
  [...]

TYPOGRAPHY: Section titles bold 12pt sans-serif; node labels 9pt math-italic for variables; caption "Figure N: [caption text]" below in 10pt regular.

COLOR PALETTE: Use only [list hex codes]. White background. Black borders 1pt. Arrows 1pt black.

Style: Clean, minimal, publication-ready. Matches NeurIPS/CVPR paper figure conventions.
```

---

## Example

**User input:** "My method has two stages: (A) a VAE encoder that compresses image x into latent z, then (B) a diffusion model that denoises z_T back to z_0 conditioned on text c."

**Plan:**
```
Panel A: VAE Encoding — x → E → z
Panel B: Diffusion Denoising — z_T + c → UNet → z_0 → D → x̂
Color: blue=encoder/decoder, purple=latent, yellow=condition
```

**Gemini Prompt (excerpt):**
> Create a white-background academic architecture diagram at 2000×800px for a CVPR paper.
>
> PANEL A — "VAE Encoding" (left half, dashed border, bold "A." top-left):
> - Node "x": rectangle, fill #FFFFFF, border black, label "x" italic
> - Node "E": rectangle, fill #BDD7EE, label "Encoder  𝓔"
> - Node "z": small rectangle, fill #D9B3FF, label "z"
> - Arrows: x → E → z, solid black 1pt
>
> PANEL B — "Latent Diffusion" (right half, dashed border, bold "B." top-left):
> - Node "z_T": rectangle, fill #D9B3FF, label "z_T"
> - Node "c": rectangle, fill #FFF2CC, label "c"
> - Node "UNet": large rectangle, fill #BDD7EE, label "ε_θ(z_t, t, c) · LDM: UNet"
> - Node "z_0": rectangle, fill #D9B3FF, label "z_0"
> - Node "D": rectangle, fill #BDD7EE, label "Decoder  𝒟"
> - Node "x̂": rectangle, fill #FFFFFF, label "x̂"
> - Arrows: z_T → UNet, c → UNet, UNet → z_0 → D → x̂
>
> Style: Clean, minimal, publication-ready. Matches NeurIPS/CVPR paper figure conventions.
