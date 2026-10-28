# VERTEX video — narration

Video: `compiled_1080_final.mp4` (20:28). Checked against frames up to 10:33.

## Installing VERTEX from the Marketplace

| Time | Topic | Text |
|---|---|---|
| 0:00–0:11 | Prepare the editor | VERTEX runs inside VS Code. Before installing it, I recommend ABAP Syntax Highlighting, which makes ABAP source easier to read. |
| 0:11–0:18 | Optional assistants | The Claude Code and Codex extensions are optional: VERTEX can also use their own command-line tools. |
| 0:18–0:32 | Install VERTEX | In Extensions, I search for SAP ABAP VERTEX and install it. |

## VERTEX setup after installation

| Time | Topic | Text |
|---|---|---|
| 0:32–0:42 | Open VERTEX SAP Tools | After installation, VERTEX appears in the activity bar. I open VERTEX SAP Tools to make the initial configuration. |
| 0:42–1:00 | Import an SAP system | With the SAP Systems icon, I import the systems already configured in SAP Logon or Eclipse. I choose No Eclipse workspace, so VERTEX finds the systems automatically. I select E19 and enter the client and user. |
| 1:00–1:07 | Check the system | E19 is added with its client and user. It uses a password, so SNC stays off. |
| 1:07–1:22 | Save the password and connect | I save the password, so VERTEX can use it from now on. It checks the connection, and we see that it is working. |
| 1:22–1:51 | Connect an AI assistant | In LLM Providers, I choose the assistants to use. Claude Code and Codex can run through their VS Code extension or their own command-line tool. I pick the route available on this machine, select the models, and save. |
| 1:51–2:00 | Select the provider | The active provider and model can be switched in the VERTEX panel at any time. |

## Introduction to the test program

| Time | Topic | Text |
|---|---|---|
| 2:00–2:28 | Find objects with VERTEX Tools | There are two ways to find SAP objects. The VERTEX Tools button opens an object search: choose the object type, such as a class, program or package, and enter a name or a mask. Here we look for the Z_DEBUGGER_TEST package. |
| 2:28–2:40 | Or ask in the chat | Or type a name, or part of one, in the VERTEX chat. It searches the system directly, without tokens, and opens what it finds. |
| 2:40–3:09 | Open the test program | Let’s look inside the package: we have twelve classes and other objects. We’ll test this program, ZVERTEX_DEBUG_LAB, so I open it. |
| 3:09–3:23 | The entry program | Here is ZVERTEX_DEBUG_LAB. Its code is short: it offers five test scenarios, passes the selected one to a calculation class, and writes the returned amount and currency. |
| 3:23–3:40 | Run it in SAP | What happens inside, we don’t know yet. So we open VERTEX Smart Debugger from the context menu and run the program in SAP. The selection screen lists the five scenarios. |
| 3:40–3:54 | CLEAN | We start with CLEAN, the baseline: about eleven thousand three hundred euros. |
| 3:54–4:02 | PRECISION | PRECISION returns zero. |
| 4:02–4:11 | STATE | STATE returns zero too. That looks like an error somewhere in the calculation. |
| 4:11–4:21 | PIPELINE | PIPELINE returns an amount, but it differs somehow. |
| 4:21–4:29 | MULTI | MULTI differs too. |
| 4:29–4:40 | What to investigate | Zero in two scenarios, different amounts in two others. These are the questions we’ll investigate. |

## Calls diagram and selects

| Time | Topic | Text |
|---|---|---|
| 4:40–5:16 | A feature for analysing code | Now a feature for checking table data while you browse the code: you can run a SELECT right from the source. Let’s find one in the calculation classes. |
| 5:16–5:41 | Run Select | Run Select shows the result next to the code: the selected columns and the fields from its conditions. No need to leave the editor. |
| 5:41–5:58 | Open the Calls diagram | Another feature is the Calls diagram: a map of the program’s calls, built from the source without running it. We open it for the entry program. |
| 5:58–6:14 | The first calls | Depth sets how many levels of calls we see. At depth two, the program’s start event calls RUN in the calculation facade. |
| 6:14–6:40 | Add depth, change direction | At depth three, RUN calls a data provider, a pricing factory, a configuration repository, a log and a modifier interface. We also switch the layout from top-down to left-right. |
| 6:40–7:03 | The whole map | At depth four, behind the modifier interface we find five modifiers: fuel, customs, hazard, discount and tax. The map shows what the code can call; what actually runs, we’ll see later in the debugger. |
| 7:03–7:18 | Navigate from the diagram | Click a method, and its code opens next to the map: here the customs modifier, then the log. |
| 7:18–7:30 | A map before running | So this view can help us understand the program better. |

## Variables, FLOW, Formula and Expression

| Time | Topic | Text |
|---|---|---|
| 7:30–7:42 | Open the debugger | Now a different question: where does the final amount come from? We open VERTEX Smart Debugger. |
| 7:42–7:58 | Variables before execution | Even before the program runs, Variables shows the declared fields and their types. Runtime values appear only when execution stops. |
| 7:58–8:13 | Choose the value | We select LS_RESULT-AMOUNT and ask VERTEX where it can change. Breakpoints mark the start of the calculation and the point where the result is returned. |
| 8:13–8:40 | 37 places | VERTEX follows the value through method calls and finds 37 places in the code that can change it, without running the program. |
| 8:40–8:54 | Classes | FLOW shows these places at several levels. Classes gives the broad structure. |
| 8:54–9:16 | Methods | Methods shows the calls between them. Click an item, and its code opens next to the tree. |
| 9:16–9:30 | Logic | Logic adds the branches and conditions. |
| 9:30–9:43 | Statements | And Statements shows every operation in detail. |
| 9:43–10:09 | From tree to diagram | The same flow is also a diagram, with the same levels and a choice of direction. |
| 10:09–10:33 | Logic, Fit and the lens | At the Logic level the picture is much larger. Fit gives an overview, and the lens lets us inspect a small area without losing our place. |
| 10:33–10:55 | Follow the formula | Formula changes the question from “what calls what?” to “what contributes to this value?” We expand the derivation of the amount: the base-price calculation, fuel surcharge, customs adjustment, hazard factor, discount, and tax. Each branch exposes its inputs and the source statements behind them. This is a source-derived calculation, including alternatives; it does not yet establish which alternatives a recorded execution takes. |
| 10:55–11:19 | Inspect the expression and its inputs | Expression writes that derivation out in one view, with the conditions and calculations visible together. Below it, we can inspect where each input comes from: shipment weight and distance, the tariff price, fuel indices, tax rates, and configuration values. Clicking an input takes us back to its source. We now have a route from the final amount to the calculations and data that can produce it—ready for investigating our five scenarios. |

## BSE and green highlighting

| Time | Topic | Text |
|---|---|---|
| 11:19–11:41 | Focus on the selected value | BSE stands for Backward Symbolic Execution. It traces backwards from the selected value to the code that contributes to it. That is what the green text highlights: the parts relevant to our amount. Full shows them in the surrounding flow; switching to BSE keeps the relevant slice, which we can inspect by class, method, or statement. |

## SAP recording

| Time | Topic | Text |
|---|---|---|
| 11:41–12:06 | Move from source analysis to execution | So far, we have explored how the program can produce the final amount. Now let’s record what happens in a specific scenario. We return to the entry program and open the debugger’s main controls. Our breakpoints mark the start of the calculation and the point where the result is returned. We launch the program in SAP. |
| 12:06–12:31 | Record steps and values | On the selection screen, we choose PIPELINE—the scenario concerned with the order of tax and discount—and execute the program. At the first breakpoint, we select Steps & values and continue. The debugger now records the execution steps together with the values collected at those stops. |
| 12:31–13:51 | Follow the recording across methods | The source view follows execution through the calculation facade and its modifier methods. These are the same components we explored in the Calls diagram. Now we are capturing the path taken by this particular SAP run. The recording preserves information for a different kind of investigation: which statements were reached, which inputs were available, and how the amount developed through the calculation. We let it reach the second breakpoint. Then we can inspect the history without repeating the run. |
| 13:51–14:15 | Replay the captured steps | Using the player, we move back through the recording. Each selected step brings up its source position, recorded stack, and available values. The live SAP session stays at its current stop while we review earlier points. We can revisit a method call or inspect a captured value at our own pace, without executing the calculation again. |

## Formula and Expression after the recorded run

| Time | Topic | Text |
|---|---|---|
| 14:15–14:30 | Return to the value with runtime data | Before asking the assistant, we return to LS_RESULT-AMOUNT. The recording now fills the Variables panel with values: the PIPELINE scenario, the modifier pipeline in its recorded order, and 37 places that touch the amount across 173 stops. |
| 14:30–14:53 | Read the expression with recorded values | In Expression, the derivation of the amount is no longer only source-derived: every input carries the value recorded in this run, and the whole expression evaluates to 11,437.83. Below it, the statements are listed in the order they ran, each with its value and stop number. We can follow the weight, distance, tariff price and fuel indices into the final amount, step by step. |

## AI-assisted diagnosis

| Time | Topic | Text |
|---|---|---|
| 14:53–15:34 | Ask AI to investigate the history | Now we open the VERTEX assistant and ask it to analyse the debug history and find a bug. The open recording supplies the context, so the assistant can examine recorded steps and values rather than relying only on source code. Here we use Claude. We keep the debugger beside the conversation so we can check the answer against the same recording. |
| 15:34–15:59 | Read the diagnosis | The assistant identifies an ordering problem: tax is applied before the discount. The discount then reduces the net amount, but the previously calculated tax is not recalculated. It suggests applying the discount before tax. Its estimated final total is labelled as a calculation, distinct from a value directly read from the recording. |
| 15:59–16:39 | Check the evidence behind the answer | The explanation includes links to recorded steps. Clicking a citation opens that point in the player, with its source, stack, and captured values. We can inspect the fuel calculation, the customs adjustment, or the modifier pipeline and check the evidence behind the diagnosis. This completes the workflow: explore the source, follow the selected value, record a scenario in SAP, and use AI to investigate it with links back to the debugger. |

## Compare scenarios with the ABAP transpiler

| Time | Topic | Text |
|---|---|---|
| 16:39–17:24 | Ask for a comparison across scenarios | We have investigated one scenario using a recording from SAP. Now let’s broaden the comparison. We ask the assistant to run all five scenarios of ZVERTEX_DEBUG_LAB with the ABAP transpiler and briefly explain the differences. The transpiler is experimental. It runs the calculation locally, without SAP screens or database writes, so it cannot reproduce workflows that depend on either. For supported calculation logic, it can be an order of magnitude faster than stepping through SAP. That makes it useful for comparing scenarios quickly, while SAP debugging remains necessary to verify behaviour in the actual system. |
| 17:24–17:49 | Read the comparison | The assistant reads the run histories and presents a comparison. CLEAN gives the baseline, around 11,302. PIPELINE produces around 11,437.83, with tax applied before the discount. MULTI reaches around 12,360.77, combining differences in the fuel surcharge, hazardous cargo handling, and modifier order. The explanation includes links to the run steps behind those observations, so we can inspect how each amount developed. |
| 17:49–18:04 | Recognise the data limitations | There is also a limitation in this comparison. The assistant reports missing shipment and pipeline data for PRECISION and STATE, so their standalone runs return zero. That does not establish the effects of those defects. The answer separates the available results from the cases it could not fully reproduce. |
| 18:04–18:19 | Open a transpiler recording | Clicking a run citation opens its recorded step in VERTEX Smart Debugger. Here we inspect the MULTI run, its context values, and its output. The same player connects the assistant’s comparison to the local execution history behind it. |

## Revisit recordings and review the AI session

| Time | Topic | Text |
|---|---|---|
| 18:19–18:59 | Return to recorded runs | To finish, let’s look at how we can return to the results of this investigation. SAP & Transpiler Logs lists the available recordings, with their date, program, type, and number of steps. Opening a run brings its history back into the debugger. We can move through the recorded steps, inspect the available variables and stack, and review the output. Here we reopen different scenario runs, including one with an empty result and the CLEAN baseline. The investigation remains available for review without repeating every execution. |
| 18:59–19:17 | Review the assistant session | Session Logs gives us another view: the AI conversation behind the investigation. We can expand the questions, model answers, and tool calls, alongside the available context and token usage. This lets us review both the explanation and the recorded activity behind it. |
| 19:17–19:25 | Closing | From source navigation to recorded execution and AI-assisted analysis, the evidence stays within reach. Thank you for watching. |

## Code review and diff

| Time | Topic | Text |
|---|---|---|
| 19:25–19:45 | Open the reviewer | Before we finish, let’s look at the code review workflow. We open the VERTEX reviewer for the change we want to inspect. |
| 19:45–20:17 | Inspect the diff | The diff shows what changed in the source. We can review the changes in context and use the findings to decide what needs attention before accepting the update. |
| 20:17–20:28 | Close | That adds code review to the same workflow: understand the code, investigate its execution, and review the proposed changes. Thank you. |
