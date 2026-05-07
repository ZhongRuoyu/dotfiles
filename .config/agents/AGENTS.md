# Agent Instructions

These are the instructions for you on how to behave while working on a project.
They should always be followed, unless you are explicitly told to ignore them.

## Communication

- Keep communication concise.
- When given a task, complete it fully.
  Do not stop halfway through unless explicitly told so.
- When there is a follow-up, assume that files you previously edited may have
  been changed, and always refer to the latest version of them.

## Programming

- Follow DRY, KISS, and YAGNI.
- Prefer self-documenting code to explanatory comments.
  Though non-trivial code and public-facing functions should have docstrings or
  comments explaining their purpose and behavior.
- Ensure that your code does not produce new errors or warnings;
  fix any that arise from your changes.
- If there is a reason why a warning cannot be fixed, at least add a bypass
  comment (`// NOLINTNEXTLINE(...)`, `# noqa: ...`, etc.), with an explanation
  of why the warning cannot be fixed and/or should be ignored.

## Styles

### Code style

- For all code and text, use 2-space indentation, with max 80 characters per
  line, though existing style should be followed if it differs.
  Long paths and URLs should always be preserved in full even if the line
  exceeds 80 characters.

### Text style

- When writing text, use U.S. English, though existing style should be followed
  if it differs.
- Use semantic line breaks (i.e., start new lines after sentence boundaries),
  though the max 80 characters rule still applies.
- Use ASCII characters only, unless the text is in a language that does not use
  the Latin alphabet.
- Avoid contractions.
- Avoid emojis.

### Filename style

- Separate words in filenames by hyphens (`-`), unless the file specifies a
  class, package, or similar entity, in which case use the language's naming
  convention (e.g., `PascalCase` for Java, `snake_case` for C/C++ and Python).

## Creating new files

- Do not create files for summary, guide, etc., unless asked to do so.
- You can create temporary files for testing or keeping track of information,
  but only inside the repository, not at any other global location like `/tmp`.
  Clean up temporary files after use.

## Commit messages

- Do not commit changes directly unless asked to do so.
- After making changes, always provide a concise but descriptive commit message
  following the 50/72 rule, whether or not you are committing the changes.
- Conventional commit messages are not necessary.
- Never add `Co-Authored-By` with the name of the agent.
