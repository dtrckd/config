#!/usr/bin/env python

import argparse
import os
import sqlite3
import subprocess
import sys
from rich.console import Console
from rich.spinner import Spinner
from rich.live import Live

DB_DIR = os.path.join(os.environ.get("XDG_DATA_HOME", os.path.expanduser("~/.local/share")), "dict")
DB_PATH = os.path.join(DB_DIR, "dict.db")
DEFAULT_MODEL = "openai:gpt-4o"

LANG_COMMANDS = {
    "en",
    "fr",
    "it",
    "enfr",
    "fren",
    "frit",
    "itfr",
}

TASKS = {"syn", "ant", "conj", "etym", "code"}


def db_init():
    os.makedirs(DB_DIR, exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    conn.execute("""CREATE TABLE IF NOT EXISTS entries (
        id       INTEGER PRIMARY KEY AUTOINCREMENT,
        query    TEXT NOT NULL,
        category TEXT NOT NULL,
        task     TEXT NOT NULL DEFAULT '',
        alt      INTEGER NOT NULL DEFAULT 0,
        result   TEXT NOT NULL,
        model    TEXT NOT NULL,
        created  DATETIME DEFAULT (datetime('now'))
    )""")
    conn.execute("CREATE INDEX IF NOT EXISTS idx_lookup ON entries(query, category, task, alt)")
    conn.execute("CREATE INDEX IF NOT EXISTS idx_category_date ON entries(category, created DESC)")
    conn.commit()
    return conn


def db_lookup(conn, query, category, task, alt):
    cur = conn.execute(
        "SELECT result FROM entries WHERE query=? AND category=? AND task=? AND alt=? ORDER BY created DESC LIMIT 1",
        (query.lower().strip(), category, task, alt),
    )
    row = cur.fetchone()
    return row[0] if row else None


def db_insert(conn, query, category, task, alt, result, model):
    conn.execute(
        "INSERT INTO entries(query, category, task, alt, result, model) VALUES(?,?,?,?,?,?)",
        (query.lower().strip(), category, task, alt, result, model),
    )
    conn.commit()


def db_list(conn, category=None, limit=10):
    if category:
        cur = conn.execute(
            "SELECT created, category, task, query, substr(result,1,80) FROM entries WHERE category=? ORDER BY created DESC LIMIT ?",
            (category, limit),
        )
    else:
        cur = conn.execute(
            "SELECT created, category, task, query, substr(result,1,80) FROM entries ORDER BY created DESC LIMIT ?",
            (limit,),
        )
    return cur.fetchall()


def build_prompt(category, task, alt):
    prompt = ""

    if task == "code":
        prompt += "\nAnswer like a documentation manual (most likely about linux, terminal or code), give a straightforward answer with no explanation."
    elif task == "syn":
        prompt += "\nProvide a synonym, give a straightforward answer with no explanation."
    elif task == "ant":
        prompt += "\nProvide an antonym, give a straightforward answer with no explanation."
    elif task == "conj":
        prompt += "\nGive the conjugaison table, in the language of the given word, give a straightforward answer with no explanation."
    elif task == "etym":
        prompt += "\nGive the etymology of the word, give a straightforward answer with no explanation."

    prompts = {
        "_guess_": "\nGive the definition of the word or sentences as if you were a dictionary. (try to guess from which language is the word and answer in the same lang, otherwise use english)",
        "en": "\nGive the ENGLISH definition of the word or sentences as if you were a dictionary.",
        "fr": "\nGive the FRENCH definition of the word or sentences as if you were a dictionary. (answer in french)",
        "it": "\nGive the ITALIAN definition of the word or sentences as if you were a dictionary. (answer in italian)",
        "enfr": "\nTranslate this ENGLISH text in FRENCH.",
        "fren": "\nTranslate this FRENCH text in ENGLISH.",
        "frit": "\nTranslate this FRENCH text in ITALIAN.",
        "itfr": "\nTranslate this ITALIAN text in FRENCH.",
    }

    prompt += prompts.get(category, "")

    if alt > 1:
        prompt += f"\nGive {alt} alternatives solution."

    return prompt


def generate(text, prompt, model):
    cmd = ["aichat", "-m", model, "--prompt", prompt]

    console = Console()

    with Live(Spinner("dots", text="", style="cyan"), console=console, transient=True):
        result = subprocess.run(cmd, input=text, capture_output=True, text=True)

    if result.returncode != 0:
        print(f"aichat error: {result.stderr}", file=sys.stderr)
        sys.exit(1)

    return result.stdout.strip()


def print_list(rows):
    if not rows:
        print("No entries found.")
        return
    fmt = "{:<19}  {:<8}  {:<6}  {:<20}  {}"
    print(fmt.format("DATE", "CATEGORY", "TASK", "QUERY", "RESULT"))
    print("-" * 90)
    for date, cat, task, query, result in rows:
        result_line = result.replace("\n", " ")[:60]
        print(fmt.format(date or "", cat, task, query[:20], result_line))


def main():
    parser = argparse.ArgumentParser(description="Dict CLI — LLM-powered dictionary with local cache")
    parser.add_argument("words", nargs="*", help="[LANG] WORD(S)...")
    parser.add_argument("-m", "--model", default=DEFAULT_MODEL, help="Model to use")
    parser.add_argument("-n", "--alt", type=int, default=0, help="Number of alternatives")
    parser.add_argument("-c", "--code", action="store_true", help="Code/doc mode")
    parser.add_argument("-s", "--syn", action="store_true", help="Synonym")
    parser.add_argument("-a", "--ant", action="store_true", help="Antonym")
    parser.add_argument("-b", "--conj", action="store_true", help="Conjugation")
    parser.add_argument("-e", "--etym", action="store_true", help="Etymology")
    parser.add_argument("-f", "--force", action="store_true", help="Force re-generation")
    parser.add_argument("-l", "--list", nargs="?", const="__all__", metavar="CAT", help="List recent entries")
    parser.add_argument("-N", "--last", type=int, default=10, help="Number of entries to list")

    args = parser.parse_args()

    conn = db_init()

    # List mode
    if args.list is not None:
        cat = None if args.list == "__all__" else args.list
        rows = db_list(conn, category=cat, limit=args.last)
        print_list(rows)
        conn.close()
        return

    if not args.words:
        parser.print_help()
        sys.exit(1)

    # Determine category and text
    if args.words[0] in LANG_COMMANDS:
        category = args.words[0]
        text = " ".join(args.words[1:])
    else:
        category = "_guess_"
        text = " ".join(args.words)

    if not text:
        parser.print_help()
        sys.exit(1)

    # Determine task
    task = ""
    alt = args.alt
    if args.code:
        task = "code"
        if category != "_guess_":
            text = category + " " + text
            category = "_guess_"
    elif args.syn:
        task = "syn"
        alt = alt or 5
    elif args.ant:
        task = "ant"
        alt = alt or 5
    elif args.conj:
        task = "conj"
    elif args.etym:
        task = "etym"

    # Cache lookup
    if not args.force:
        cached = db_lookup(conn, text, category, task, alt)
        if cached:
            print(cached)
            conn.close()
            return

    # Generate
    prompt = build_prompt(category, task, alt)
    result = generate(text, prompt, args.model)
    print(result)

    # Store
    db_insert(conn, text, category, task, alt, result, args.model)
    conn.close()


if __name__ == "__main__":
    main()
