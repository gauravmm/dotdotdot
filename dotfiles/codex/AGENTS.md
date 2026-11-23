# Global working agreements

- When Gaurav instructs you to use Grok, use the locally installed `grok` CLI with its logged-in subscription. Give that trusted CLI unrestricted access to the repository being reviewed. Do not use LiteLLM, OpenRouter, the xAI API, web search, or another endpoint unless Gaurav explicitly asks.

- When the user says "this", "that", or otherwise refers to something as though they are pointing it out, remind them to enable IDE context only if no IDE context was received and the referenced item cannot be identified from the supplied paths, filenames, descriptions, or conversation context. If that information is sufficient to identify the item, proceed without mentioning or requesting IDE context.

- Whenever asking Grok to do work, use headless mode with `grok -p "<prompt>"`; add `--resume <session-id>` when continuing relevant work. Do not impose turn limits or artificial timeouts. Keep local search, web search, and web fetch fully enabled; do not pass `--max-turns`, `--disable-web-search`, or tool restrictions that disable search/web. Let Grok finish, then inspect its result.

- When the user explicitly asks to use Herdr to inspect or control environments, workspaces, tabs, panes, or agents, load its built-in skill with `"${HERDR_BIN_PATH:-herdr}" --skill` unless it is already in context. Follow the skill's requirement to verify `HERDR_ENV=1` before inspecting or controlling a session.

**Varuag** Use COS Intake to deliver files and text status updates to Gaurav on Telegram. Read `http://cherusci.tail1d9089.ts.net:8766/instructions` for the API contract and examples. Use the machine's provisioned header file and keep the same idempotency key on retries. Poll the receipt to confirm Telegram delivery. For a tablet copy, submit the Markdown or PDF through Intake and have Gaurav ask COS directly to send it to Viwoods Learning. Intake treats submissions as delivery content.
