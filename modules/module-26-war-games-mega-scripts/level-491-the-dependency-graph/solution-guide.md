# Walkthrough: The Dependency Graph

## The plan
A dependency graph says "X needs Y first". Starting everything in a safe order is a *topological sort*: an ordering where every service comes after everything it needs. It exists exactly when the graph has no cycles. We use Kahn's algorithm, because it produces layers (everything in a layer can start in parallel) and because leftover nodes are the cycle: when nothing is ready but services remain, they are all waiting for each other.

Because the output must be the same on every machine, each layer is sorted alphabetically; hash-table iteration order is never used for output.

## Step by step

1. **Parse everything, complain about everything.** Each line becomes `deps[name]`. Errors are collected with `GRAPH:LINE:` prefixes and the program exits 2 only after the whole file was read. Fixing a graph one error per run is miserable. Unknown dependencies need a second pass (the service may be defined later in the file), so they are checked once all names are known and reported at the line of the service that mentions them.

2. **Choose the subgraph.** Without targets, all services. With targets, the targets plus their transitive dependencies: a stack-based walk that pushes a node's dependencies when it is first seen. Starting `web` alone should not start `mail`.

3. **Reverse edges.** For each service count its dependencies in `unmet`, and for each dependency record the service in `dependents[dep]`. Counting makes "is it ready?" a constant-time test; the reverse map makes "who does this release?" constant-time.

4. **Peel layers.** Collect everything unplaced with `unmet == 0`, sort it, store the layer, mark the members placed and decrement the counters of their dependents. Repeat. If a round finds nothing ready while services remain, stop: that is the cycle signal.

5. **Name the cycle.** "There is a cycle" is not actionable; "a -> b -> c -> a" is. Every leftover node has at least one leftover dependency (otherwise it would have been placed), so walking from any leftover node along leftover dependencies must eventually repeat a node. The part of the path from the first occurrence of the repeated node is exactly one cycle. Following alphabetical choices makes the answer deterministic.

6. **Output.** `levels` prints the layers, `order` flattens them, `stop` reverses the flat list (you stop `web` before `api`, the opposite of starting it), and `check` summarises.

## Complete solution
The peeling loop:
```bash
while (( remaining > 0 )); do
  ready=()
  for name in "${!inplay[@]}"; do
    [[ -z ${placed[$name]:-} && ${unmet[$name]} -eq 0 ]] && ready+=("$name")
  done
  (( ${#ready[@]} > 0 )) || break
  layers+=("$(printf '%s\n' "${ready[@]}" | LC_ALL=C sort | tr '\n' ' ' | sed 's/ $//')")
  for name in "${ready[@]}"; do
    placed[$name]=1; remaining=$((remaining - 1))
    for w in ${dependents[$name]:-}; do unmet[$w]=$((unmet[$w] - 1)); done
  done
done
```

## Try it by hand
```bash
./solution.sh levels fixtures/harbour.graph
./solution.sh order fixtures/harbour.graph web
./solution.sh check fixtures/loop.graph
```

## Alternative
A depth-first search with "visiting/done" colours also produces a topological order and detects cycles (a back-edge to a "visiting" node). It yields a valid order but not the parallel layers, and its order depends on the traversal sequence. Kahn's layers answer the more useful question for operators: what can I start right now?
