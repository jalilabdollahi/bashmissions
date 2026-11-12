#!/usr/bin/env bash
# lantern: a crew-roster CLI built as a mini framework. Commands and options are
# declared once (a registry), and the option parser, the help screens and the
# "did you mean" hints are all generated from that data.
#   lantern [--db FILE] [-h|--help] [-V|--version] [--] COMMAND [OPTIONS] [ARGS]

# TODO: the registry: command order, descriptions, argument words, min/max argument counts,
#       one options string per command (SHORT|LONG|VALUENAME|TEXT per line), allowed values
# TODO: overall_help and command_help, both printed from the registry
# TODO: usage_error (exit 64, with the "Run 'lantern help ...'" line) and a runtime fail (exit 1)
# TODO: subseq / suggest for the "did you mean" hints
# TODO: a generic parser: --opt value, --opt=value, -o value, options anywhere, `--`, -h
# TODO: global options: --db (flag > $LANTERN_DB > crew.db), -h, -V, --; unknown command handling
# TODO: argument count checks, then dispatch to cmd_add / cmd_list / cmd_remove / cmd_show / cmd_help / cmd_version
