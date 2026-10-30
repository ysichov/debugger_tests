# VERTEX demo — speaker script

Intro per slide (10–20 s), then the clip narration. Times are positions inside compiled_1080_final.mp4.

## Slide 1. VERTEX: AI-Powered ABAP Plugins for VS Code & Eclipse

**Intro:** Hi, I'm Yurii Sychov, Lead Software Engineer. I'll show you a tool I built for this kind of work.

**What it is:** VERTEX is a set of AI-powered ABAP plugins for VS Code and Eclipse. It helps you understand ABAP code, find the cause of a problem without classic debugging, and review transports — with an AI that works on real data from the SAP system.

**Transition:** This is a short guided demo with video. Here is what we'll see.

## Slide 2. Overview

**Intro:** Four parts today. First, setup. Then an alternative to classic debugging on a small test program. Then code insight on a big real class: metrics, logic and path to line. And finally, a transport review with AI.

## Slide 3. Install and set up VERTEX

**Intro:** Let's start with setup. VERTEX installs from the VS Code Marketplace; then we connect an SAP system and choose an AI model. There is also an Eclipse ADT version with its own update site, but it is out of scope today.

*Clip: 01_install_setup.mp4 — 2:00.*

### Installing VERTEX from the Marketplace
| Time | Topic | Text |
|---|---|---|
| 0:00–0:11 | Prepare the editor | VERTEX runs inside VS Code. Before installing it, I recommend ABAP Syntax Highlighting, which makes ABAP source easier to read. |
| 0:11–0:18 | Optional assistants | The Claude Code and Codex extensions are optional: VERTEX can also use their own command-line tools. |
| 0:18–0:32 | Install VERTEX | In Extensions, I search for SAP ABAP VERTEX and install it. |

### VERTEX setup after installation
| Time | Topic | Text |
|---|---|---|
| 0:32–0:42 | Open VERTEX SAP Tools | After installation, VERTEX appears in the activity bar. I open VERTEX SAP Tools to make the initial configuration. |
| 0:42–1:00 | Import an SAP system | With the SAP Systems icon, I import the systems already configured in SAP Logon or Eclipse. I choose No Eclipse workspace, so VERTEX finds the systems automatically. I select E19 and enter the client and user. |
| 1:00–1:07 | Check the system | E19 is added with its client and user. It uses a password, so SNC stays off. |
| 1:07–1:22 | Save the password and connect | I save the password, so VERTEX can use it from now on. It checks the connection, and we see that it is working. |
| 1:22–1:51 | Connect an AI assistant | In LLM Providers, I choose the assistants to use. Claude Code and Codex can run through their VS Code extension or their own command-line tool. I pick the route available on this machine, select the models, and save. |
| 1:51–2:00 | Select the provider | The active provider and model can be switched in the VERTEX panel at any time. |

**Wrap-up (after the clip):** VERTEX is installed, connected to SAP and to an AI model. Now let's use it on a real problem.

## Slide 4. An alternative to classic debugging

**Intro:** Next, an alternative to classic debugging. We take a small test program, run its scenarios, and find out what goes wrong — with VERTEX views and the AI, without stepping through the debugger line by line.

*Clip: 02_debugging.mp4 — 14:39.*

### Introduction to the test program
| Time | Topic | Text |
|---|---|---|
| 0:00–0:28 | Find objects with VERTEX Tools | There are two ways to find SAP objects. The VERTEX Tools button opens an object search: choose the object type, such as a class, program or package, and enter a name or a mask. Here we look for the Z_DEBUGGER_TEST package. |
| 0:28–0:40 | Or ask in the chat | Or type a name, or part of one, in the VERTEX chat. It searches the system directly, without tokens, and opens what it finds. |
| 0:40–1:09 | Open the test program | Let’s look inside the package: we have twelve classes and other objects. We’ll test this program, ZVERTEX_DEBUG_LAB, so I open it. |
| 1:09–1:23 | The entry program | Here is ZVERTEX_DEBUG_LAB. Its code is short: it offers five test scenarios, passes the selected one to a calculation class, and writes the returned amount and currency. |
| 1:23–1:40 | Run it in SAP | What happens inside, we don’t know yet. So we open VERTEX Smart Debugger from the context menu and run the program in SAP. The selection screen lists the five scenarios. |
| 1:40–1:54 | CLEAN | We start with CLEAN, the baseline: about eleven thousand three hundred euros. |
| 1:54–2:02 | PRECISION | PRECISION returns zero. |
| 2:02–2:11 | STATE | STATE returns zero too. That looks like an error somewhere in the calculation. |
| 2:11–2:21 | PIPELINE | PIPELINE returns an amount, but it differs somehow. |
| 2:21–2:29 | MULTI | MULTI differs too. |
| 2:29–2:40 | What to investigate | Zero in two scenarios, different amounts in two others. These are the questions we’ll investigate. |

### Calls diagram and selects
| Time | Topic | Text |
|---|---|---|
| 2:40–3:16 | A feature for analysing code | Now a feature for checking table data while you browse the code: you can run a SELECT right from the source. Let’s find one in the calculation classes. |
| 3:16–3:41 | Run Select | Run Select shows the result next to the code: the selected columns and the fields from its conditions. No need to leave the editor. |
| 3:41–3:58 | Open the Calls diagram | Another feature is the Calls diagram: a map of the program’s calls, built from the source without running it. We open it for the entry program. |
| 3:58–4:14 | The first calls | Depth sets how many levels of calls we see. At depth two, the program’s start event calls RUN in the calculation facade. |
| 4:14–4:40 | Add depth, change direction | At depth three, RUN calls a data provider, a pricing factory, a configuration repository, a log and a modifier interface. We also switch the layout from top-down to left-right. |
| 4:40–5:03 | The whole map | At depth four, behind the modifier interface we find five modifiers: fuel, customs, hazard, discount and tax. The map shows what the code can call; what actually runs, we’ll see later in the debugger. |
| 5:03–5:18 | Navigate from the diagram | Click a method, and its code opens next to the map: here the customs modifier, then the log. |
| 5:18–5:30 | A map before running | So this view can help us understand the program better. |

### Variables, FLOW, Formula and Expression
| Time | Topic | Text |
|---|---|---|
| 5:30–5:42 | Open the debugger | Now a different question: where does the final amount come from? We open VERTEX Smart Debugger. |
| 5:42–5:58 | Variables before execution | Even before the program runs, Variables shows the declared fields and their types. Runtime values appear only when execution stops. |
| 5:58–6:13 | Choose the value | We select LS_RESULT-AMOUNT and ask VERTEX where it can change. Breakpoints mark the start of the calculation and the point where the result is returned. |
| 6:13–6:40 | 37 places | VERTEX follows the value through method calls and finds 37 places in the code that can change it, without running the program. |
| 6:40–6:54 | Classes | FLOW shows these places at several levels. Classes gives the broad structure. |
| 6:54–7:16 | Methods | Methods shows the calls between them. Click an item, and its code opens next to the tree. |
| 7:16–7:30 | Logic | Logic adds the branches and conditions. |
| 7:30–7:43 | Statements | And Statements shows every operation in detail. |
| 7:43–8:09 | From tree to diagram | The same flow is also a diagram, with the same levels and a choice of direction. |
| 8:09–8:33 | Logic, Fit and the lens | At the Logic level the picture is much larger. Fit gives an overview, and the lens lets us inspect a small area without losing our place. |
| 8:33–8:47 | Follow the formula | We haven't run anything yet, but Formula already shows what can contribute to the amount: base price, fuel, customs, hazard, discount and tax, each with its inputs. |
| 8:47–9:19 | The expression and its inputs | Expression writes the whole calculation out in one line, built from the source only. Below, each input with the SELECT it comes from: weight, distance, tariff, fuel index, tax rate. Which branches really run and with what values, we'll see after a run in SAP. |

### BSE and green highlighting
| Time | Topic | Text |
|---|---|---|
| 9:19–9:41 | Focus on the selected value | BSE, Backward Symbolic Execution, goes back from our amount to the code that really affects it. Green marks that code; the BSE view keeps only this slice. |

### SAP recording
| Time | Topic | Text |
|---|---|---|
| 9:41–10:06 | Move from source analysis to execution | So far we've seen how the program can calculate the amount. Now let's see what really happens. We go back to the entry program and run it in SAP from the debugger. |
| 10:06–10:31 | Record steps and values | On the selection screen we choose PIPELINE, "VAT before discount", and execute. The debugger stops at the first breakpoint. We switch on Steps & values and continue: now every step is recorded with its values. |
| 10:31–11:51 | Follow the recording across methods | The program runs, and the editor follows it: the facade, the pricing class, the log and each modifier — the same classes we saw in the Calls diagram. This time it is the real path of this run. The step counter grows; every step is saved with its values. At the second breakpoint the run stops: one hundred seventy-four steps recorded. |
| 11:51–12:15 | Replay the captured steps | With the player we go back through the recording. Each step shows its source line, stack and values. SAP stays where it stopped, so we don't need to run again. |

### Formula and Expression after the recorded run
| Time | Topic | Text |
|---|---|---|
| 12:15–12:30 | Return to the value with runtime data | Back to LS_RESULT-AMOUNT. Now Variables has real values: the PIPELINE scenario and the modifiers in the order they ran. |
| 12:30–12:53 | Read the expression with recorded values | And now Expression has numbers: every input has its recorded value, and the whole formula gives eleven thousand four hundred thirty-eight. Below, the statements in the order they ran, each with its value and step. |

### AI-assisted diagnosis
| Time | Topic | Text |
|---|---|---|
| 12:53–13:34 | Ask AI to investigate the history | Now let's ask the AI. In the VERTEX chat I write: analyse the debug history and find a bug. I switch to Claude and send. The assistant gets the recording itself — the steps and their values — not just the source code. |
| 13:34–13:59 | Read the diagnosis | And here is the answer: VAT is calculated before the discount. The discount lowers the amount, but the tax stays as it was. So the steps run in the wrong order. |
| 13:59–14:39 | Check the evidence behind the answer | Every claim has a link to a recorded step. One click, and the player jumps there: the fuel surcharge, the customs adjustment, the modifier pipeline — with the source line and the values. So we can check the AI instead of just trusting it. It also says what the bug costs: about one hundred thirty-six euros too much, and suggests a fix. |

**Wrap-up (after the clip):** So we found the cause from the calls, the formula and the recorded run, without stepping through the debugger once.

## Slide 5. Metrics, logic and path to line

**Intro:** Beyond one program, VERTEX helps to assess and refactor large code. Metrics show where the complexity is, the logic diagram shows a method's branches, and Path to line shows which conditions lead to a given line.

*Clip: 03_path_metrics_logic.mp4 — 2:55.*

### Metrics, logic diagram and Path to line
| Time | Topic | Text |
|---|---|---|
| 0:00–0:15 | Open a big class | Now a real class from Version Explorer: ZCL_AVE_POPUP. I type its name in the chat, and VERTEX opens it. |
| 0:15–0:30 | Metrics | From VERTEX Tools I open Metrics. In seconds: ninety-one methods, about four thousand six hundred lines, and for each method its complexity and other metrics. |
| 0:30–0:45 | What the numbers mean | If a metric is unfamiliar, the question mark explains each one: what it counts and how to read it. |
| 0:45–1:00 | Find the hot spot | I sort by complexity and switch to the visual view: the bigger and redder the tile, the more complex the method. One stands out: ON_TOOLBAR_CLICK — two hundred sixty-four lines, complexity fifty-three. |
| 1:00–1:30 | Logic view | Let's look inside. From the context menu I open the Logic view. It keeps only the control flow — CASE, IF, LOOP, RETURN — and hides the rest. Depth opens it level by level. |
| 1:30–2:00 | The diagram | Now as a diagram. Depth two… six. What a wonderful spaghetti of AI-generated code — and that is just one method. Here we see all its branches at once. |
| 2:00–2:10 | Path to line | Now a concrete question: how can we get to this line — to catch a breakpoint, for example? On line 2648 I choose Path to line. |
| 2:10–2:30 | Read the path | VERTEX shows every condition on the way: which WHEN branch must be taken, which IFs must be true or false, and which RETURNs must not be reached before it. |
| 2:30–2:55 | Other lines | Another line, another path. For any line we see what must happen to get there — which scenario to prepare to hit a breakpoint, or why a line never runs. |

**Wrap-up (after the clip):** One program is easy. Metrics, the logic diagram and Path to line help when the code is big and someone else wrote it — or an AI did.

## Slide 6. Review a transport

**Intro:** Finally, the review. We open a transport, see what it changes, ask the AI what the changes are for and whether they contain bugs, and give each changed block a verdict.

*Clip: 04_review_new.mp4 — 2:28.*

### Code review with AI
| Time | Topic | Text |
|---|---|---|
| 0:00–0:12 | Open the transport | In the object search I choose Transport request, enter its number and switch to Review. |
| 0:12–0:24 | What the request changes | We see who changed what: one developer, four classes, nine changed blocks. The review is saved in SAP. |
| 0:24–0:36 | Look at the diffs | Click a method, and we see its diff: the old version against the active one. |
| 0:36–0:44 | Review by developer | Or click the developer: all their blocks in one list, with filters. |
| 0:44–1:16 | Ask about the purpose | Now the AI. In the chat I ask: what is the business purpose of these changes, briefly? The answer: interfaces now show up correctly in the transport review, with their own author, tasks and dates. |
| 1:16–2:00 | Ask about bugs | Next question: do we have bugs here? This code was generated by Codex; now Claude Opus reviews it — and finds a real bug: interface names of thirty characters are not recognised. Plus two risks: the same logic is copied four times, and one path was not checked. It even suggests a fix. |
| 2:00–2:20 | Give a verdict | Now the reviewer decides. Each block can be approved, declined or just commented; a decline always needs a comment. I decline the first block and write why. |
| 2:20–2:28 | Close | The verdict and the comment are saved, and the developer sees them. |

**Wrap-up (after the clip):** So the review adds the last step: understand the code, investigate its execution, and check the changes before they go further.

## Slide 7. Key Takeaways

**Intro:** To sum up, five things to take away. *(The cards appear one by one — one line per click.)*

| Click | Card | Text |
|---|---|---|
| 1 | UNDERSTAND | First, understand before you debug. Calls, FLOW and Formula show how a value is built, without stepping through the code line by line. |
| 2 | EVIDENCE | Second, evidence instead of guesses. The AI reads the recorded SAP run, so its answer is based on real values from the system. |
| 3 | BIG PICTURE | Third, the big picture. Metrics show where the complexity is, the logic diagram shows the branches, and Path to line shows how you reach a specific line — even in a wonderful spaghetti. |
| 4 | REVIEW | Fourth, review before release. You see what a transport changes, ask the AI about its purpose and possible bugs, and approve or decline each block with a comment. |
| 5 | Banner | And the most important one: don't be afraid to build the plugins you really need. Use AI to vibe-code them — VERTEX itself was built this way. |

## Slide 8. Questions & Answers

**Intro:** Thank you. I'm happy to take your questions.

## Slide 9. Thank you!

**Intro:** All links are on the slide: the repository, the Marketplace page, the Eclipse update site and the demo source. Thank you!
